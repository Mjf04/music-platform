import {
  createRouter,
  createWebHistory,
  createWebHashHistory,
} from 'vue-router'
import { UserStore } from '@/stores/modules/user'
import { ElMessage } from 'element-plus'

/** 需要登录才能访问的路由 */
const AUTH_REQUIRED_PATHS = ['/like', '/user']
//作用：定义网址和页面的对应关系，控制页面跳转
// 从环境变量获取路由模式（hash 或 history）
const mode = import.meta.env.VITE_ROUTER_MODE

/**
 * 路由历史模式映射表
 * 
 * 根据配置动态选择使用 Hash 模式还是 History 模式
 */
const routerMode = {
  hash: () => createWebHashHistory(),
  history: () => createWebHistory(),
}

/**
 * 创建 Vue Router 实例
 * 
 * 配置项说明：
 * - history: 根据环境变量选择路由模式
 * - scrollBehavior: 每次路由切换后滚动到页面顶部
 * - routes: 定义应用的所有路由规则
 */
const router = createRouter({
  history: routerMode[mode](),
  strict: false,
  scrollBehavior: () => ({ left: 0, top: 0 }),
  routes: [
    // 首页 - 推荐页面
    {
      path: '/',
      component: () => import('@/pages/index.vue'),
    },
    // 曲库页面 - 所有歌曲列表
    {
      path: '/library',
      component: () => import('@/pages/library/index.vue'),
    },
    // 歌手列表页面
    {
      path: '/artist',
      component: () => import('@/pages/artist/index.vue'),
    },
    // 歌手详情页面（动态路由）
    {
      path: '/artist/:id',
      component: () => import('@/pages/artist/[id].vue'),
    },
    // 歌单列表页面
    {
      path: '/playlist',
      component: () => import('@/pages/playlist/index.vue'),
    },
    // 歌单详情页面（动态路由）
    {
      path: '/playlist/:id',
      component: () => import('@/pages/playlist/[id].vue'),
    },
    // 我喜欢的音乐页面
    {
      path: '/like',
      component: () => import('@/pages/like/index.vue'),
    },
    // 个人中心页面
    {
      path: '/user',
      component: () => import('@/pages/user/index.vue'),
    },
    // 歌词播放页面
    {
      path: '/lyric',
      component: () => import('@/pages/lyric/index.vue'),
    },
  ],
})

router.beforeEach(to => {
  const needAuth = AUTH_REQUIRED_PATHS.some(
    p => to.path === p || to.path.startsWith(`${p}/`)
  )
  if (!needAuth) return true

  const userStore = UserStore()
  if (userStore.isLoggedIn && userStore.userInfo?.token) {
    return true
  }

  ElMessage.warning('请先登录')
  return { path: '/' }
})

export default router
