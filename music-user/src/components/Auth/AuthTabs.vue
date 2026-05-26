<script setup lang="ts">
import { ref, computed } from 'vue'
import LoginForm from './LoginForm.vue'
import RegisterForm from './RegisterForm.vue'
import ResetPasswordForm from './ResetPasswordForm.vue'

/**
 * 接收父组件传来的对话框显示状态
 */
const props = defineProps<{
  modelValue: boolean
}>()

/**
 * 向父组件发送更新事件，实现双向绑定
 */
const emit = defineEmits(['update:modelValue'])

/**
 * 计算属性：让对话框的显示/隐藏与父组件同步
 */
const dialogVisible = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})

/**
 * 当前激活的标签页：login(登录)、register(注册)、reset(重置密码)
 */
const activeTab = ref('login')

/**
 * 标签页标题映射表
 */
const tabTitles = {
  login: '登录',
  register: '注册',
  reset: '重置密码',
}

/**
 * 登录/注册成功后关闭对话框
 */
const handleSuccess = () => {
  dialogVisible.value = false
}

/**
 * 关闭对话框时重置回登录标签页
 */
const handleClose = () => {
  activeTab.value = 'login'
}

/**
 * 切换标签页（从登录表单点击"注册"或"忘记密码"时触发）
 *
 * @param tab - 要切换到的标签页名称
 */
const handleSwitchTab = (tab: string) => {
  activeTab.value = tab
}
</script>

<template>
  <!-- 认证对话框：包含登录、注册、重置密码三个标签页 -->
  <el-dialog
    v-model="dialogVisible"
    :title="tabTitles[activeTab]"
    width="500px"
    destroy-on-close
    @close="handleClose"
  >
<!--   关闭时重置标签页为login-->
    <div>
      <!-- 标签页切换区域 -->
      <el-tabs v-model="activeTab" class="auth-tabs">
        <!-- 登录标签页 -->
        <el-tab-pane name="login" :label="tabTitles.login">
          <LoginForm 
            @success="handleSuccess" 
            @switch-tab="handleSwitchTab"
          />
        </el-tab-pane>
        <!-- 注册标签页 -->
        <el-tab-pane name="register" :label="tabTitles.register">
          <RegisterForm 
            @success="handleSuccess" 
            @switch-tab="handleSwitchTab"
          />
        </el-tab-pane>
        <!-- 重置密码标签页 -->
        <el-tab-pane name="reset" :label="tabTitles.reset">
          <ResetPasswordForm 
            @success="handleSuccess" 
            @switch-tab="handleSwitchTab"
          />
        </el-tab-pane>
      </el-tabs>
    </div>
  </el-dialog>
</template>

<style scoped>
/* 让标签页导航居中显示 */
.auth-tabs ::v-deep(.el-tabs__nav) {
  width: 100%;
  display: flex;
  justify-content: center;
}

/* 每个标签项平均分配宽度 */
.auth-tabs ::v-deep(.el-tabs__item) {
  flex: 1;
  text-align: center;
}
</style>
