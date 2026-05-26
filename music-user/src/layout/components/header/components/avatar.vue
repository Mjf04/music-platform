<script setup lang="ts">
import { ref } from 'vue'
import { UserStore } from '@/stores/modules/user'
import AuthTabs from '@/components/Auth/AuthTabs.vue'
import FeedbackDialog from '@/components/Common/FeedbackDialog.vue'
import defaultAvatar from '@/assets/user.jpg'
import { getImageUrl } from '@/utils'
import { ElMessage } from 'element-plus'
import { logout } from '@/api/system'
import { useRouter } from 'vue-router'

const showLogin = ref(false)
const user = UserStore()
const router = useRouter()
const feedbackDialogRef = ref<InstanceType<typeof FeedbackDialog> | null>(null)

/**
 * 处理用户退出登录操作
 *
 * 执行流程：
 * 1. 调用后端退出登录 API
 * 2. 成功后清除本地用户信息
 * 3. 显示成功提示
 * 4. 失败时也会清除本地信息，确保状态一致
 */
const handleLogout = async () => {
  try {
    const response = await logout()
    user.clearUserInfo()
    if (response.code === 0) {
      ElMessage.success('退出登录成功')
    } else {
      ElMessage.warning(response.message || '服务端登出异常，已清除本地登录状态')
    }
  } catch (error: any) {
    console.error('退出登录错误:', error)
    user.clearUserInfo()
    ElMessage.warning('网络异常，已清除本地登录状态')
  }
}

/**
 * 打开意见反馈对话框
 *
 * 通过模板引用获取 FeedbackDialog 组件实例，
 * 调用其 openDialog 方法显示反馈表单
 */
const openFeedbackDialog = () => {
  feedbackDialogRef.value?.openDialog()
}
</script>

<template>
  <!-- 已登录：显示用户信息和下拉菜单 -->
  <el-dropdown v-if="user.userInfo && user.userInfo.userId" class="cursor-pointer">
    <span class="flex items-center">
      <!-- 用户头像 -->
      <el-avatar :src="getImageUrl(user.userInfo.avatarUrl) || defaultAvatar" class="mr-1" shape="circle" :size="32" />
      <!-- 用户名 -->
      <span class="text-sm font-medium mr-2 ml-1">{{ user.userInfo.username }}</span>
      <icon-uiw:down />
    </span>

    <!-- 下拉菜单选项 -->
    <template #dropdown>
      <el-dropdown-menu>
        <!-- 个人中心 -->
        <el-dropdown-item @click="router.push('/user')">
          <icon-mi:user />&ensp;个人中心
        </el-dropdown-item>

        <!-- 意见反馈 -->
        <el-dropdown-item @click="openFeedbackDialog">
          <icon-feather:edit />&ensp;意见反馈
        </el-dropdown-item>

        <!-- 退出登录 -->
        <el-dropdown-item @click="handleLogout">
          <icon-pajamas:power />&ensp;退出
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>

  <!-- 未登录：显示登录按钮 -->
  <el-button class="mr-3 rounded-full" v-else type="primary" @click="showLogin = true">
    <div class="flex items-center gap-1">
      <icon-ic:baseline-person-pin />
      登录
    </div>
  </el-button>

  <!-- 登录弹窗 -->
  <AuthTabs v-if="showLogin" v-model="showLogin" />

  <!-- 意见反馈对话框 -->
  <FeedbackDialog ref="feedbackDialogRef" />
</template>
