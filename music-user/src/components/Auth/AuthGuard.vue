<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { UserStore } from '@/stores/modules/user'
import { ElMessage } from 'element-plus'
import AuthTabs from './AuthTabs.vue'
/*onMounted：页面一加载就执行
ref：定义变量（控制弹窗显示）
useRouter：路由工具，控制页面跳转
UserStore：全局用户状态，存了有没有登录
ElMessage：Element Plus 的提示框
AuthTabs：登录、注册的弹窗组件*/


const userStore = UserStore()
const router = useRouter()
const authVisible = ref(false)

/**
 * 页面加载时检查是否登录
 *
 * 如果没登录：
 * 1. 弹出提示"请先登录"
 * 2. 显示登录窗口
 * 3. 阻止访问受保护内容
 */
onMounted(() => {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    authVisible.value = true
    router.push(router.currentRoute.value.path)
  }
})

/**
 * 登录成功后关闭登录窗口
 */
const handleLoginSuccess = () => {
  authVisible.value = false
}
</script>

<template>
  <!-- 已登录：显示正常内容 ，isLoggedIn 是一个布尔值（boolean）状态变量，
  用于标识用户是否已登录。默认用户未登录，在user.ts 23-->
  <slot v-if="userStore.isLoggedIn"></slot>
  <!-- 未登录：显示登录/注册窗口 -->
  <AuthTabs v-model="authVisible" @success="handleLoginSuccess" />
</template> 