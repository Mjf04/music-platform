<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { formatTime } from '@/utils'
import { UserStore } from '@/stores/modules/user'
import { useAudioStore } from '@/stores/modules/audio'
import { collectSong, cancelCollectSong } from '@/api/system'
import { ElMessage } from 'element-plus'
import { computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLibraryStore } from '@/stores/modules/library'
import { useArtistStore } from '@/stores/modules/artist'
import { usePlaylistStore } from '@/stores/modules/playlist'
import { useFavoriteStore } from '@/stores/modules/favorite'
import { isSongLiked, syncTrackListLikeStatus } from '@/utils/songFavorite'

const userStore = UserStore()
const audioStore = useAudioStore()
const favoriteStore = useFavoriteStore()
const route = useRoute()
const libraryStore = useLibraryStore()

const {
  isPlaying,
  currentTime,
  duration,
  nextTrack,
  prevTrack,
  togglePlayPause,
  seek,
} = useAudioPlayer()

/**
 * 获取当前播放歌曲的喜欢状态
 *
 * @returns 喜欢状态值（0=未喜欢，1=已喜欢）
 */
const currentSongLikeStatus = computed(() => {
  const currentTrack = audioStore.trackList[audioStore.currentSongIndex]
  if (!currentTrack) return 0
  const songId = Number(currentTrack.id)
  return isSongLiked(songId, currentTrack.likeStatus) ? 1 : 0
})

watch(
  () => [audioStore.currentSongIndex, favoriteStore.favoriteSongIds.length] as const,
  () => {
    syncTrackListLikeStatus(audioStore.trackList)
  },
)

/**
 * 统一更新所有页面中同一首歌曲的喜欢状态
 *
 * 同时更新以下位置的喜欢状态以确保界面一致性：
 * - 全局播放列表 (audioStore.trackList)
 * - 当前页面歌曲列表 (audioStore.currentPageSongs)
 * - 曲库页面数据 (libraryStore.tableData)
 * - 歌手详情页数据 (artistStore.artistInfo.songs)
 * - 歌单详情页数据 (playlistStore.songs)
 *
 * @param songId - 需要更新的歌曲 ID
 * @param status - 新的喜欢状态（0=未喜欢，1=已喜欢）
 */
const updateAllSongLikeStatus = (songId: number, status: number) => {
  audioStore.trackList.forEach(track => {
    if (Number(track.id) === songId) {
      track.likeStatus = status
    }
  })

  if (audioStore.currentPageSongs) {
    audioStore.currentPageSongs.forEach(song => {
      if (song.songId === songId) {
        song.likeStatus = status
      }
    })
  }

  if (route.path === '/library' && libraryStore.tableData?.items) {
    const song = libraryStore.tableData.items.find(song => song.songId === songId)
    if (song) {
      song.likeStatus = status
    }
  }

  if (route.path.startsWith('/artist/')) {
    const artistStore = useArtistStore()
    if (artistStore.artistInfo?.songs) {
      const song = artistStore.artistInfo.songs.find(song => song.songId === songId)
      if (song) {
        song.likeStatus = status
      }
    }
  }

  if (route.path.startsWith('/playlist/')) {
    const playlistStore = usePlaylistStore()
    if (playlistStore.songs) {
      const song = playlistStore.songs.find(song => song.songId === songId)
      if (song) {
        song.likeStatus = status
      }
    }
  }
}

/**
 * 处理收藏/取消收藏当前播放歌曲的操作
 *
 * 执行流程：
 * 1. 检查用户登录状态
 * 2. 获取当前播放歌曲的 ID
 * 3. 根据当前喜欢状态调用对应的 API
 * 4. 成功后更新所有页面的喜欢状态
 * 5. 显示操作结果提示
 */
const handleLike = async () => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    return
  }

  const currentTrack = audioStore.trackList[audioStore.currentSongIndex]
  if (!currentTrack) return

  try {
    const songId = Number(currentTrack.id)
    if (currentSongLikeStatus.value === 0) {
      const res = await collectSong(songId)
      if (res.code === 0) {
        favoriteStore.addFavoriteSong(songId)
        updateAllSongLikeStatus(songId, 1)
        ElMessage.success('已添加到我的喜欢')
      } else {
        ElMessage.error(res.message || '添加到我的喜欢失败')
      }
    } else {
      const res = await cancelCollectSong(songId)
      if (res.code === 0) {
        favoriteStore.removeFavoriteSong(songId)
        updateAllSongLikeStatus(songId, 0)
        ElMessage.success('已取消喜欢')
      } else {
        ElMessage.error(res.message || '取消喜欢失败')
      }
    }
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}
</script>

<template>
  <!-- 播放控制区域容器 -->
  <div class="flex items-center flex-1">
    <!-- 播放控制按钮组 -->
    <div class="flex items-center mr-2">
      <!-- 上一首按钮 -->
      <button
        @click="prevTrack"
        class="p-2 rounded-full hover:bg-hoverMenuBg transition"
      >
        <icon-solar:skip-previous-bold class="text-lg" />
      </button>

      <!-- 播放/暂停按钮 -->
      <button
        @click="togglePlayPause"
        class="p-2 rounded-full hover:bg-hoverMenuBg transition"
      >
        <Icon
          :icon="
            isPlaying ? 'ic:round-pause-circle' : 'material-symbols:play-circle'
          "
          class="text-5xl"
          :color="'#2a68fa'"
        />
      </button>

      <!-- 下一首按钮 -->
      <button
        @click="nextTrack"
        class="p-2 rounded-full hover:bg-hoverMenuBg transition"
      >
        <icon-solar:skip-previous-bold class="transform scale-x-[-1] text-lg" />
      </button>

      <!-- 喜欢/取消喜欢按钮 -->
      <button class="p-2 rounded-full hover:bg-hoverMenuBg transition" @click="handleLike">
        <icon-mdi:cards-heart-outline v-if="currentSongLikeStatus === 0" class="text-lg" />
        <icon-mdi:cards-heart v-else class="text-lg text-red-500" />
      </button>
    </div>

    <!-- 进度条和时间显示 -->
    <div class="w-full flex items-center space-x-2">
      <!-- 拖动滑块调整播放进度 -->
      <el-slider
        v-model="currentTime"
        :step="1"
        :show-tooltip="false"
        @change="seek"
        :max="duration"
        class="w-full"
        size="small"
      />
      <!-- 当前播放时间 -->
      <span class="text-xs">{{ formatTime(currentTime) }}</span>
      <span> / </span>
      <!-- 歌曲总时长 -->
      <span class="text-xs">{{ formatTime(duration) }}</span>
    </div>
  </div>
</template>
