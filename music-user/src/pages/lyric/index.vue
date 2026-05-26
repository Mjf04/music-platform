<!-- 文件位置：D:\music-platform\music-user\src\pages\lyric\index.vue -->
<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAudioPlayer } from '@/hooks/useAudioPlayer'
import { getImageUrl } from '@/utils'
import vinylImg from '@/assets/vinyl.png'

const router = useRouter()
const { currentTrack, currentLyricIndex, currentTime, duration, seek, isPlaying, togglePlayPause } = useAudioPlayer()

const lyricContainerRef = ref<HTMLElement | null>(null)
const showCover = ref(true)

/**
 * 判断当前歌曲是否有歌词
 *
 * @returns true 表示有歌词，false 表示无歌词
 */
const hasLyrics = computed(() => {
  return currentTrack.value.lyrics?.lines && currentTrack.value.lyrics.lines.length > 0
})

/**
 * 获取当前歌曲的歌词行数组
 *
 * @returns 歌词行数组，若无歌词则返回空数组
 */
const currentLyricLines = computed(() => {
  return currentTrack.value.lyrics?.lines || []
})

/**
 * 监听歌词索引变化，自动滚动到当前演唱的歌词行
 *
 * 当 currentLyricIndex 更新时，触发滚动逻辑使当前歌词居中显示
 */
watch(currentLyricIndex, (newIndex) => {
  scrollToActiveLyric(newIndex)
})

/**
 * 滚动歌词容器使当前歌词行居中显示
 *
 * 计算逻辑：
 * 1. 获取当前歌词行相对于容器顶部的位置
 * 2. 计算使该行居中所需的滚动距离（容器高度的一半减去行高的一半）
 * 3. 使用平滑滚动动画更新容器滚动位置
 *
 * @param index - 当前需要显示的歌词行索引
 */
const scrollToActiveLyric = (index: number) => {
  if (!lyricContainerRef.value) return
  
  const lyricLines = lyricContainerRef.value.querySelectorAll('.lyric-line')
  if (!lyricLines[index]) return
  
  const containerHeight = lyricContainerRef.value.clientHeight
  const lineElement = lyricLines[index] as HTMLElement
  const lineTop = lineElement.offsetTop
  const lineHeight = lineElement.clientHeight
  
  const scrollTop = lineTop - containerHeight / 2 + lineHeight / 2
  
  lyricContainerRef.value.scrollTo({
    top: Math.max(0, scrollTop),
    behavior: 'smooth'
  })
}

/**
 * 点击歌词行跳转到对应播放进度
 *
 * @param time - 歌词行的时间戳（毫秒）
 */
const handleLyricClick = (time: number) => {
  seek(time / 1000)
}

/**
 * 返回上一页
 */
const handleBack = () => {
  router.back()
}
</script>

<template>
  <!-- 歌词页面主容器 -->
  <div class="lyric-page h-screen w-screen bg-background relative overflow-hidden">
    <!-- 背景模糊效果，使用歌曲封面作为背景 -->
    <div 
      class="absolute inset-0 bg-cover bg-center blur-3xl opacity-30"
      :style="{ backgroundImage: `url(${getImageUrl(currentTrack.cover)})` }"
    ></div>
    
    <!-- 内容区域 -->
    <div class="relative z-10 h-full flex flex-col">
      <!-- 顶部导航栏：返回按钮、歌曲信息 -->
      <div class="flex items-center justify-between p-6">
        <button 
          @click="handleBack"
          class="p-2 rounded-full hover:bg-hoverMenuBg transition-colors"
        >
          <icon-mdi:arrow-left class="text-2xl text-primary-foreground" />
        </button>
        <div class="text-center">
          <h2 class="text-lg font-semibold text-primary-foreground">{{ currentTrack.title }}</h2>
          <p class="text-sm text-muted-foreground">{{ currentTrack.artist }}</p>
        </div>
        <div class="w-10"></div>
      </div>

      <!-- 主要内容区域：左侧唱片 + 右侧歌词 -->
      <div class="flex-1 flex gap-8 px-8 pb-8 overflow-hidden">
        <!-- 左侧：旋转唱片封面 -->
        <div class="w-1/3 flex-shrink-0 flex items-center justify-center">
          <div class="relative">
            <!-- 唱片图片，播放时旋转 -->
            <div
              class="w-80 h-80 rounded-full overflow-hidden shadow-2xl"
              :class="{ 'animate-spin': isPlaying }"
              :style="{ animationDuration: '10s' }"
            >
              <img 
                :src="getImageUrl(currentTrack.cover) || vinylImg" 
                alt="cover"
                class="w-full h-full object-cover"
              />
            </div>
            <!-- 唱片中心装饰 -->
            <div class="absolute inset-0 flex items-center justify-center">
              <div class="w-16 h-16 rounded-full bg-black/50 backdrop-blur-sm"></div>
            </div>
          </div>
        </div>

        <!-- 右侧：歌词显示区域 -->
        <div class="flex-1 relative min-w-0">
          <!-- 无歌词提示 -->
          <div v-if="!hasLyrics" class="h-full flex items-center justify-center">
            <div class="text-center text-muted-foreground">
              <icon-material-symbols:music-note class="text-6xl mb-4 opacity-50" />
              <p class="text-lg">暂无歌词</p>
              <p class="text-sm mt-2 opacity-60">纯音乐也动听</p>
            </div>
          </div>

          <!-- 歌词滚动容器 -->
          <div 
            v-else
            ref="lyricContainerRef"
            class="h-full overflow-y-auto scrollbar-hide px-8 py-20"
          >
            <div class="flex flex-col items-center justify-center gap-4 min-h-full">
              <!-- 歌词行列表 -->
              <div
                v-for="(line, index) in currentLyricLines"
                :key="index"
                :class="[
                  'lyric-line transition-all duration-300 cursor-pointer',
                  index === currentLyricIndex ? 'active text-primary-foreground scale-110' : 'text-muted-foreground hover:text-primary-foreground/80'
                ]"
                :style="{
                  fontSize: index === currentLyricIndex ? '20px' : '16px',
                  fontWeight: index === currentLyricIndex ? '600' : '400'
                }"
                @click="handleLyricClick(line.time)"
              >
                {{ line.text }}
              </div>
            </div>
          </div>

          <!-- 上下渐变遮罩，营造淡入淡出效果 -->
          <div class="absolute inset-0 pointer-events-none">
            <div class="h-32 bg-gradient-to-b from-background to-transparent absolute top-0 left-0 right-0"></div>
            <div class="h-32 bg-gradient-to-t from-background to-transparent absolute bottom-0 left-0 right-0"></div>
          </div>
        </div>
      </div>

      <!-- 底部播放进度控制 -->
      <div class="p-6 border-t border-border/50">
        <div class="flex items-center justify-center gap-8">
          <!-- 当前播放时间 -->
          <span class="text-xs text-muted-foreground w-12 text-right">
            {{ new Date(currentTime * 1000).toISOString().substr(14, 5) }}
          </span>
          <!-- 进度拖动条 -->
          <el-slider
            v-model="currentTime" 
            :show-tooltip="false" 
            @change="seek" 
            :max="duration" 
            class="flex-1 max-w-xl"
            size="small"
          />
          <!-- 歌曲总时长 -->
          <span class="text-xs text-muted-foreground w-12">
            {{ new Date(duration * 1000).toISOString().substr(14, 5) }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.lyric-page {
  .scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
    
    &::-webkit-scrollbar {
      display: none;
    }
  }

  .lyric-line {
    padding: 10px 0;
    text-align: center;
    line-height: 1.6;
    word-break: break-all;
    transition: all 0.3s ease;
    
    &.active {
      text-shadow: 0 0 15px rgba(42, 104, 250, 0.5);
    }
  }
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin linear infinite;
}
</style>
