<script setup lang="ts">
import { Song } from '@/api/interface'
import { PropType, watch } from 'vue'
import { formatMillisecondsToTime, getImageUrl } from '@/utils'
import default_album from '@/assets/default_album.jpg'
import { collectSong, cancelCollectSong } from '@/api/system'
import { useFavoriteStore } from '@/stores/modules/favorite'
import { isSongLiked } from '@/utils/songFavorite'
import { ElMessage } from 'element-plus'
import { UserStore } from '@/stores/modules/user'
import { useAudioStore } from '@/stores/modules/audio'
/*你点击歌曲
更新全局 audio store 里的 currentSongIndex
封面、标题、播放器都监听 store，自动同步更新*/

// 音频播放全局播放状态
const audio = useAudioStore()
const favoriteStore = useFavoriteStore()
////用户登录状态
const userStore = UserStore()
//播放器
const { loadTrack, play } = useAudioPlayer()

const props = defineProps({
  data: {
    type: Array as PropType<Song[]>,
    default: () => [],
  },
})

/**
 * 监听歌曲数据变化，同步到音频 store 中
 *
 * 当父组件传入的歌曲列表发生变化时，
 * 自动更新当前页面的歌曲列表状态
 */
watch(() => props.data, (newData) => {
  audio.setCurrentPageSongs(newData)
}, { immediate: true })

/**
 * 将后端返回的歌曲数据转换为播放器所需的格式
 *
 * @param song - 原始歌曲数据对象
 * @returns 转换后的播放轨道对象，如果数据不完整则返回 null
 */
const convertToTrackModel = (song: Song) => {
  if (!song.songId || !song.songName || !song.audioUrl) {
    console.error('歌曲数据不完整:', song)
    return null
  }
  return {
    id: song.songId.toString(),
    title: song.songName,
    artist: song.artistName,
    album: song.album,
    cover: song.coverUrl || default_album,
    url: song.audioUrl,
    duration: Number(song.duration) || 0,
    likeStatus: song.likeStatus || 0,
  }
}

/**
 * 处理歌曲播放逻辑
 *
 * 执行流程：
 * 1. 将所有歌曲数据转换为播放列表
 * 2. 找到当前点击歌曲在列表中的索引
 * 3. 更新全局播放列表和当前播放索引
 * 4. 加载并开始播放选中的歌曲
 *
 * @param row - 用户点击的歌曲数据对象
 */
const handlePlay = async (row: Song) => {
  // 将所有歌曲数据转换为播放列表
  const allTracks = props.data
    .map(song => convertToTrackModel(song))
    .filter(track => track !== null)
  //找到你点的是第几首
  const selectedIndex = props.data.findIndex(song => song.songId === row.songId)
  // 更新全局播放列表和当前播放索引
  audio.setAudioStore('trackList', allTracks)
  // 设置当前播放索引为选中的歌曲
  audio.setAudioStore('currentSongIndex', selectedIndex)
// 开始播放
  await loadTrack()
  play()
}

/**
 * 统一更新所有位置中同一首歌曲的喜欢状态
 *
 * 同时更新三个地方的状态以确保界面一致性：
 * - 全局播放列表 (audio.trackList)
 * - 当前页面歌曲列表 (audio.currentPageSongs)
 * - 组件接收的原始数据 (props.data)
 *
 * @param songId - 需要更新的歌曲 ID
 * @param status - 新的喜欢状态（0=未喜欢，1=已喜欢）
 */
const updateAllSongLikeStatus = (songId: number, status: number) => {
  audio.trackList.forEach(track => {
    if (Number(track.id) === songId) {
      track.likeStatus = status
    }
  })

  if (audio.currentPageSongs) {
    audio.currentPageSongs.forEach(song => {
      if (song.songId === songId) {
        song.likeStatus = status
      }
    })
  }

  if (props.data) {
    const song = props.data.find(song => song.songId === songId)
    if (song) {
      song.likeStatus = status
    }
  }
}

/**
 * 处理收藏/取消收藏歌曲的操作
 *
 * 执行流程：
 * 1. 检查用户登录状态
 * 2. 根据当前喜欢状态调用对应的 API
 * 3. 成功后更新所有位置的喜欢状态
 * 4. 显示操作结果提示
 *
 * @param row - 操作的歌曲数据对象
 * @param e - 点击事件对象，用于阻止事件冒泡
 */
const handleLike = async (row: Song, e: Event) => {
  e.stopPropagation()
  
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    return
  }

  try {
    const liked = isSongLiked(row.songId, row.likeStatus)
    if (!liked) {
      const res = await collectSong(row.songId)
      if (res.code === 0) {
        favoriteStore.addFavoriteSong(row.songId)
        updateAllSongLikeStatus(row.songId, 1)
        ElMessage.success('已添加到我的喜欢')
      } else {
        ElMessage.error(res.message || '添加到我的喜欢失败')
      }
    } else {
      const res = await cancelCollectSong(row.songId)
      if (res.code === 0) {
        favoriteStore.removeFavoriteSong(row.songId)
        updateAllSongLikeStatus(row.songId, 0)
        ElMessage.success('已取消喜欢')
      } else {
        ElMessage.error(res.message || '取消喜欢失败')
      }
    }
  } catch (error: any) {
    ElMessage.error(error.message || '操作失败')
  }
}

/**
 * 下载音乐文件到本地
 *
 * 通过创建隐藏的 <a> 标签触发浏览器下载，
 * 文件名格式为："歌名 - 歌手"
 *
 * @param row - 要下载的歌曲数据对象
 * @param e - 点击事件对象，用于阻止事件冒泡
 */
const downLoadMusic = (row: Song, e: Event) => {
  e.stopPropagation()
  const link = document.createElement('a')
  link.href = row.audioUrl
  link.setAttribute('download', `${row.songName} - ${row.artistName}`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

/**
 * 判断指定歌曲是否是当前正在播放的歌曲
 *
 * @param songId - 需要判断的歌曲 ID
 * @returns true 表示正在播放，false 表示未播放
 */
const isCurrentPlaying = (songId: number) => {
  const currentTrack = audio.trackList[audio.currentSongIndex]
  return currentTrack && Number(currentTrack.id) === songId
}
</script>

<template>
  <el-table :data="data" style="
      --el-table-border: none;
      --el-table-border-color: none;
      --el-table-tr-bg-color: none;
      --el-table-header-bg-color: none;
      --el-table-row-hover-bg-color: transparent;
    " class="!rounded-lg !h-full transition duration-300">
    <el-table-column>
      <template #header>
        <div class="grid grid-cols-[auto_4fr_3fr_3fr_1fr_2fr_1fr] items-center gap-6 w-full text-left mt-2">
          <div class="ml-3">标题</div>
          <div class="w-12"></div>
          <div class="ml-1">歌手</div>
          <div>专辑</div>
          <div>喜欢</div>
          <div class="ml-7">时长</div>
          <div>下载</div>
        </div>
      </template>
      <template #default="{ row }">
        <div
          class="grid grid-cols-[auto_4fr_3fr_3fr_1fr_2fr_1fr] items-center gap-6 w-full group transition duration-300 rounded-2xl p-2"
          :class="[
            isCurrentPlaying(row.songId) ? 'bg-[hsl(var(--hover-menu-bg))]' : 'hover:bg-[hsl(var(--hover-menu-bg))]',
            'cursor-pointer'
          ]"
          @click="handlePlay(row)">
          <!-- 标题和封面 -->
          <div class="w-10 h-10 relative" v-if="row.coverUrl">
            <el-image :src="getImageUrl(row.coverUrl) || row.coverUrl" fit="cover" lazy :alt="row.songName" class="w-full h-full rounded-md" />
            <!-- Play 按钮，使用 group-hover 控制透明度 -->
            <div
              class="absolute inset-0 flex items-center justify-center text-white opacity-0 transition-opacity duration-300 z-10 group-hover:opacity-100 group-hover:bg-black/50 rounded-md">
              <icon-tabler:player-play-filled class="text-lg" />
            </div>
          </div>

          <!-- 歌曲名称 -->
          <div class="text-left">
            <div class="flex-1 line-clamp-1">{{ row.songName }}</div>
          </div>

          <!-- 歌手 -->
          <div class="text-left">
            <div class="line-clamp-1 w-48">{{ row.artistName }}</div>
          </div>

          <!-- 专辑 -->
          <div class="text-left">{{ row.album }}</div>

          <!-- 喜欢 -->
          <div class="flex items-center ml-1">
            <el-button text circle @click="handleLike(row, $event)">
              <icon-mdi:cards-heart-outline v-if="!userStore.isLoggedIn || !isSongLiked(row.songId, row.likeStatus)" class="text-lg" />
              <icon-mdi:cards-heart v-else class="text-lg text-red-500" />
            </el-button>
          </div>

          <!-- 时长 -->
          <div class="text-left ml-8">
            <span>{{ formatMillisecondsToTime(Number(row.duration) * 1000) }}</span>
          </div>

          <!-- 下载 -->
          <div class="flex items-center ml-1">
            <el-button text circle @click.stop="downLoadMusic(row, $event)">
              <icon-material-symbols:download class="text-lg" />
            </el-button>
          </div>
        </div>
      </template>
    </el-table-column>
  </el-table>
</template>

<style scoped>
:deep(.el-table__row) {
  background: transparent !important;
}

:deep(.el-table__row:hover) td {
  background: transparent !important;
}

:deep(.el-table__cell) {
  padding: 0 !important;
}
</style>