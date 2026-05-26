<script setup lang="ts">
import { formatMillisecondsToTime, getImageUrl } from '@/utils'
import { trackModel } from '@/stores/interface'
import { useAudioStore } from '@/stores/modules/audio'

const audio = useAudioStore()
const { loadTrack, play, audioElement } = useAudioPlayer()

const mouseOverIndex = ref(-1)

/**
 * 播放指定歌曲
 *
 * 将歌曲添加到播放列表，加载并立即播放
 *
 * @param song - 要播放的歌曲对象
 */
const playMusic = async (song: trackModel) => {
  audio.addTracks(song)
  await loadTrack()
  play()
}

/**
 * 清空播放列表
 *
 * 移除所有歌曲并将音频源置空，停止当前播放
 */
const handleClearAll = () => {
  audio.setAudioStore('trackList', [])
  if (audioElement.value) {
    audioElement.value.src = ''
  }
}
</script>

<template>
  <!-- 播放列表弹出框 -->
  <el-popover :width="450" trigger="click" placement="top-end" popper-class="!rounded-lg !p-0">
    <!-- 触发按钮：播放列表图标 -->
    <template #reference>
      <div class="flex items-center">
        <button class="p-2 rounded-full hover:bg-hoverMenuBg transition w-9">
          <icon-ri-play-list-2-fill class="w-full h-full" />
        </button>
      </div>
    </template>

    <!-- 播放列表内容 -->
    <div class="bg-popoverBg rounded-lg p-2">
      <!-- 标题和清空按钮 -->
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm text-gray-400">播放列表</span>
        <button class="p-2 rounded-full hover:bg-hoverMenuBg transition" @click="handleClearAll">
          <icon-material-symbols:delete-outline-rounded class="text-sm text-gray-500" />
        </button>
      </div>

      <!-- 歌曲列表 -->
      <div class="flex flex-col">
        <el-scrollbar class="h-96">
          <div v-for="(item, index) in audio.trackList" :key="index" @click="playMusic(item)"
            @mouseover="mouseOverIndex = index" @mouseleave="mouseOverIndex = -1"
            class="flex items-center gap-2 p-2 my-1 rounded-lg transition group cursor-pointer"
            :class="`hover:bg-gray-300 ${audio.currentSongIndex == index ? 'bg-gray-300 dark:bg-[#414243]' : ''} dark:hover:bg-[#414243] `">
            <!-- 歌曲封面 -->
            <div class="w-10 h-auto rounded-lg overflow-hidden relative">
              <img :src="getImageUrl(item.cover)" alt="" />
              <!-- 悬停时显示的播放按钮 -->
              <div
                class="absolute inset-0 flex items-center justify-center text-white opacity-0 transition-opacity duration-300 z-10 group-hover:opacity-100 group-hover:bg-black/50 rounded-md">
                <icon-tabler:player-play-filled class="text-lg" />
              </div>
            </div>

            <!-- 歌曲信息（标题和艺术家） -->
            <div class="flex-1">
              <div class="text-sm">{{ item.title }}</div>
              <div class="text-xs text-gray-400">{{ item.artist }}</div>
            </div>

            <!-- 歌曲时长 -->
            <div class="text-xs text-gray-400">
              {{ formatMillisecondsToTime(Number(item.duration) * 1000) }}
            </div>

            <!-- 删除按钮（仅悬停时显示） -->
            <el-button v-show="mouseOverIndex == index" type="primary" text circle @click="audio.deleteTrack(item.id)">
              <icon-material-symbols:delete-outline-rounded class="text-lg text-gray-500" />
            </el-button>
          </div>
        </el-scrollbar>
      </div>
    </div>
  </el-popover>
</template>
