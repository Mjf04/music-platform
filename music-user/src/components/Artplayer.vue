<script setup lang="ts">
import Artplayer from 'artplayer'

/**
 * 组件属性：
 * - src: 音频播放地址（必填）
 * - poster: 封面图片地址（可选）
 * - theme: 主题颜色，默认紫色 #7E22CE
 */
const props = defineProps({
  src: {
    type: String,
    required: true,
  },
  poster: {
    type: String,
    default: '',
  },
  theme: {
    type: String,
    default: '#7E22CE',
  },
})

/**
 * 播放器容器 DOM 引用
 */
const artRef = ref()

/**
 * Artplayer 播放器配置选项
 *
 * 功能说明：
 * - container: 绑定到 class 为 artplayer-app 的 DOM 元素
 * - url: 初始播放地址（为空，后续通过 watch 动态设置）
 * - autoSize: 自动调整尺寸适应容器
 * - poster: 封面图
 * - theme: 主题色
 * - flip: 启用画面翻转功能
 * - setting: 显示设置面板
 * - playbackRate: 支持倍速播放
 * - aspectRatio: 支持调整宽高比
 * - screenshot: 支持截图功能
 * - hotkey: 启用快捷键控制
 */
const option: Artplayer['Option'] = {
  container: '.artplayer-app',
  url: '',
  autoSize: true,
  poster: props.poster,
  theme: props.theme,
  flip: true,
  setting: true,
  playbackRate: true,
  aspectRatio: true,
  screenshot: true,
  hotkey: true,
}

/**
 * 播放器实例引用
 */
const art = ref<Artplayer>()

/**
 * 组件挂载时初始化播放器
 * 创建 Artplayer 实例并保存到 art 变量中
 * 组件一显示，就自动创建播放器
 */
onMounted(() => {
  art.value = new Artplayer(option)
})

/**
 * 监听 src 属性变化，动态更新播放地址
 *
 * 执行流程：
 * 1. 当父组件传入新的 src 时触发
 * 2. 检查播放器实例是否已创建
 * 3. 更新播放器的 URL 和封面图
 * 4. 播放器会自动加载新资源
 */
watch(
  () => props.src,
  (val) => {
    if (val) {
      if (!art.value) return
      art.value.url = val
      art.value.poster = props.poster
    }
  }
)
</script>

<template>
  <!--
    播放器容器：
    - ref: 绑定 DOM 引用供 Artplayer 初始化使用
    - class: artplayer-app 是播放器挂载的目标，aspect-video 保持 16:9 宽高比
  -->
  <div ref="artRef" class="artplayer-app aspect-video" />
</template>
