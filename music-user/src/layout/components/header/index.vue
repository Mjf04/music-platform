<script setup lang="ts">
import { Icon } from '@iconify/vue'
import Avatar from './components/avatar.vue'
import { themeStore } from '@/stores/modules/theme'
const route = useRoute()
const router = useRouter()
const currentIcon = ref('material-symbols:wb-sunny-outline-rounded')
const theme = themeStore()
import { useDark, useToggle } from '@vueuse/core'

const searchText = ref('')

const isDark = useDark({
  selector: 'html',
  attribute: 'class',
  valueDark: 'dark',
  valueLight: 'light',
})
const toggleDark = useToggle(isDark)

/**
 * 切换深色/浅色主题模式
 *
 * 同时更新主题 store 和 HTML 类名，实现全局主题切换
 */
const toggleMode = () => {
  theme.setDark(!isDark.value)
  toggleDark()
}

/**
 * 监听主题状态变化，动态更新主题切换图标
 *
 * - 深色模式：显示月亮图标 (mdi:weather-night)
 * - 浅色模式：显示太阳图标 (material-symbols:wb-sunny-outline-rounded)
 */
watch(
  () => theme.isDark,
  (newValue) => {
    currentIcon.value = newValue
      ? 'mdi:weather-night'
      : 'material-symbols:wb-sunny-outline-rounded'
  },
  { immediate: true }
)

/**
 * 监听路由查询参数，同步搜索框内容
 *
 * 当 URL 中包含 query 参数时，自动填充到搜索框，
 * 支持从其他页面跳转时保持搜索状态
 */
watch(
  () => route.query,
  (newValue) => {
    if (newValue.query) {
      searchText.value = newValue.query as string
    }
  },
  { immediate: true }
)
</script>

<template>
  <!-- 顶部导航栏容器 -->
  <header class="px-4 py-2 border-b flex items-center">
    <!-- Logo 和平台名称，点击返回首页 -->
    <button class="flex relative w-60" @click="router.push('/')">
      <img src="/logo.jpg" alt="logo" class="w-10 h-10 ml-2" />
      <span class="ml-3 text-2xl font-bold flex justify-center items-center"
        >音乐流媒体平台</span
      >
    </button>

    <!-- 搜索框和主题切换按钮 -->
    <div class="flex items-center gap-3">
      <!-- 搜索输入框 -->
      <div class="relative mr-6">
        <Icon
          icon="mdi:magnify"
          class="absolute left-2 top-1/2 transform -translate-y-1/2 text-gray-500 text-xl"
        />
        <input
          v-model="searchText"
          type="text"
          class="mt-0.5 w-64 text-sm pl-8 pr-2 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition-all duration-300 focus:w-80 search-bg"
          placeholder="搜索..."
          @keyup.enter="router.push('/library?query=' + searchText)"
        />
      </div>

      <!-- 主题切换按钮（深色/浅色） -->
      <button @click="toggleMode">
        <Icon class="text-xl" :icon="currentIcon" />
      </button>
    </div>

    <!-- 右侧用户头像区域 头像组件复用-->
    <div class="ml-auto flex items-center gap-3"><Avatar /></div>
  </header>
</template>

<style scoped>
.search-bg {
  background-color: #e3e3e3;
}
</style>
