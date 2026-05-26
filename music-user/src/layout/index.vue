<script setup lang="ts">
import Header from './components/header/index.vue'
import Aside from './components/aside/index.vue'
import Main from './components/main/index.vue'
import Footer from './components/footer/index.vue'
import { createAudioPlayer } from '@/hooks/useAudioPlayer'

/**
 * 创建音频播放器实例并提供给所有子组件
 *
 * 通过 Vue 的 provide/inject 机制，将全局音频播放器实例注入到应用中，
 * 使得任何子组件都可以通过 useAudioPlayer() 获取播放器控制方法
 */
provide('audioPlayer', createAudioPlayer())
</script>

<template>
  <!-- 主布局容器 -->
  <div class="absolute w-full flex flex-col h-full">
    <div class="w-full flex flex-col h-full overflow-hidden bg-themeBgColor backdrop-blur-lg">
      <!-- 顶部导航栏 -->
      <Header />

      <!-- 中间内容区域（侧边栏 + 主内容） -->
      <div class="flex flex-1 overflow-hidden">
        <Aside />
        <Main />
      </div>

      <!-- 底部播放控制栏 -->
      <Footer />
    </div>
  </div>
</template>
