<script setup lang="ts">
import { MenuData } from './data'
import { Icon } from '@iconify/vue'
import { getImageUrl, replaceUrlParams } from '@/utils'
import { useRoute, useRouter } from 'vue-router'
import { ref, watch } from 'vue'
import { UserStore } from '@/stores/modules/user'
import { ElMessage } from 'element-plus'
import AuthTabs from '@/components/Auth/AuthTabs.vue'
import { useFavoriteStore } from '@/stores/modules/favorite'
import { useAudioStore } from '@/stores/modules/audio'
import { syncTrackListLikeStatus } from '@/utils/songFavorite'

const route = useRoute()
const router = useRouter()
const user = UserStore()
const favoriteStore = useFavoriteStore()
const authVisible = ref(false)

/**
 * 处理需要登录权限的路由跳转
 *
 * 检查目标路由是否需要登录（/like 和 /user），
 * 如果用户未登录则显示提示并弹出登录窗口
 *
 * @param path - 目标路由路径
 * @returns true 表示可以跳转，false 表示阻止跳转
 */
const handleProtectedRoute = (path: string) => {
  if (!user.isLoggedIn && (path === '/like' || path === '/user')) {
    ElMessage.warning('请先登录')
    authVisible.value = true
    return false
  }
  return true
}

/**
 * 监听用户登录状态变化，同步收藏歌单数据
 *
 * - 登录时：从服务器获取用户收藏的歌单列表
 * - 退出时：清空本地存储的歌单数据
 */
watch(
  () => user.isLoggedIn,
  async (newVal) => {
    if (newVal) {
      await Promise.all([
        favoriteStore.getFavoritePlaylists(),
        favoriteStore.loadFavoriteSongIds(),
      ])
      syncTrackListLikeStatus(useAudioStore().trackList)
    } else {
      favoriteStore.clearAll()
    }
  },
  { immediate: true }
)
</script>

<template>
  <!-- 侧边栏容器 -->
  <aside class="w-64 hidden h-full overflow-hidden md:block border-r shadow-2xl shadow-blue-500/50">
    <nav class="flex flex-col p-4 space-y-4 flex-1 h-full box-border overflow-hidden">
      <!-- 主菜单列表 -->
      <div v-for="(item, index) in MenuData" :key="index" class="w-full flex flex-col gap-1">
        <h3 class="ml-4 text-sm font-semibold text-inactive">
          {{ item.title }}
        </h3>
        <div v-for="(item2, index2) in item.children" :key="index2"
          class="mx-2 rounded-lg transition text-lg duration-300 py-2 px-2 flex items-center gap-2 text-primary-foreground cursor-pointer"
          :class="{
            'bg-activeMenuBg': route.path === item2.router,
            'hover:bg-hoverMenuBg': route.path !== item2.router,
          }" @click="handleProtectedRoute(item2.router) && router.push(item2.router)">
          <Icon :icon="item2.icon" />
          <span>{{ item2.title }}</span>
          <span class="!ml-auto text-xs text-primary-foreground bg-emphasis border-border p-1 rounded-lg"></span>
        </div>
      </div>

      <!-- 收藏的歌单列表（仅登录用户可见） -->
      <div class="w-full flex flex-col gap-1" v-if="user.isLoggedIn">
        <h3 class="ml-4 text-sm font-semibold text-inactive">收藏的歌单（{{ favoriteStore.favoritePlaylists.length }}）</h3>
        <el-scrollbar>
          <!-- 加载状态骨架屏 -->
          <el-skeleton :loading="favoriteStore.loading" animated :count="3" v-if="favoriteStore.loading">
            <template #template>
              <div class="flex items-center space-x-2 p-2 mx-2">
                <el-skeleton-item variant="image" style="width: 28px; height: 28px" />
                <el-skeleton-item variant="text" style="width: 130px" />
              </div>
            </template>
          </el-skeleton>

          <!-- 歌单列表 -->
          <template v-else>
            <div v-for="item in favoriteStore.favoritePlaylists" :key="item.id"
              class="mx-2 my-1 rounded-lg transition text-sm duration-300 py-2 px-2 flex items-center gap-2 text-primary-foreground cursor-pointer"
              :class="{
                'bg-activeMenuBg': route.path === `/playlist/${item.id}`,
                'hover:bg-hoverMenuBg': route.path !== `/playlist/${item.id}`,
              }" @click="router.push(`/playlist/${item.id}`)">
              <el-image lazy :src="replaceUrlParams(getImageUrl(item.coverImgUrl) || item.coverImgUrl, 'param=50y50')" class="w-10 h-10 rounded-md flex-shrink-0"
                :alt="item.name" />
              <div class="flex-1 min-w-0">
                <span class="line-clamp-2 text-sm leading-normal">{{ item.name }}</span>
              </div>
            </div>
          </template>
        </el-scrollbar>
      </div>
    </nav>

    <!-- 登录对话框 -->
    <AuthTabs v-model="authVisible" />
  </aside>
</template>
