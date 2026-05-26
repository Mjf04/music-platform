<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAudioPlayer } from '@/hooks/useAudioPlayer'
import DrawerMusic from '@/components/DrawerMusic/index.vue'
import { getImageUrl, replaceUrlParams } from '@/utils'

// 绑定全局音频播放器的当前播放歌曲状态
const { currentTrack } = useAudioPlayer()
const showDrawerMusic = ref(false)

/**
 * 安全获取歌曲标题
 *
 * @returns 当前播放歌曲标题，若无则返回 '未播放'
 */
const trackTitle = computed(() => currentTrack.value?.title || '未播放')

/**
 * 安全获取歌曲艺术家
 *
 * @returns 当前播放歌曲艺术家，若无则返回空字符串
 */
const trackArtist = computed(() => currentTrack.value?.artist || '')

/**
 * 安全获取歌曲封面
 *
 * @returns 当前播放歌曲封面地址，若无则返回空字符串
 */
const trackCover = computed(() => currentTrack.value?.cover || '')
</script>

<template>
  <!-- 左侧歌曲信息卡片 -->
  <div
    class="flex items-center gap-2 w-64 cursor-pointer select-none hover:bg-hoverMenuBg transition-colors rounded-lg p-1" 
    @click="showDrawerMusic = !showDrawerMusic"
  >
    <!-- 歌曲封面图片 -->
    <div class="min-w-12 max-w-12 h-full">
      <img
        :src="(getImageUrl(trackCover) && replaceUrlParams(getImageUrl(trackCover), 'param=90y90')) || trackCover || ''"
        :alt="trackTitle"
        class="w-full h-full object-cover rounded-lg m-1"
      />
    </div>

    <!-- 歌曲标题和艺术家信息 -->
    <div>
      <!-- 歌曲标题 -->
      <div
        class="text-base text-primary-foreground line-clamp-1 mb-0.5 mx-2"
        :title="trackTitle"
      >
        {{ trackTitle }}
      </div>
      <!-- 歌曲艺术家 -->
      <div class="text-xs text-muted-foreground line-clamp-1 h-4 mt-0.5 mx-2">
        {{ trackArtist }}
      </div>
    </div>

    <!-- 音乐详情抽屉 -->
    <DrawerMusic v-model="showDrawerMusic" />
  </div>
</template>
