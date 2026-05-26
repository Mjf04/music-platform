<script setup lang="ts">
import { ref, reactive } from 'vue'
import { User, Lock } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { UserStore } from '@/stores/modules/user'
/*
ref/reactive：Vue 用来存数据
User/Lock：小图标（用户名、密码）
ElMessage：成功 / 失败提示消息
UserStore：真正去调用登录 API 的地方
*/

/**
 * 定义组件事件：
 * - success: 登录成功时触发，通知父组件关闭弹窗
 * - switch-tab: 切换标签页时触发，告诉父组件要显示哪个页面（注册/重置密码）
 */
const emit = defineEmits(['success', 'switch-tab'])
const userStore = UserStore()

/**
 * loading: 控制登录按钮的加载状态，防止重复点击
 * loginFormRef: 表单引用，用于手动触发表单验证
 */
const loading = ref(false)
const loginFormRef = ref<FormInstance>()

/**
 * 登录表单数据：存你输入的用户名和密码
 */
const loginForm = reactive({
  username: '',
  password: '',
})

/**
 * 表单验证规则：
 * - 用户名：必填，4-16位字母/数字/下划线/连字符
 * - 密码：必填，8-18位，必须是数字、字母、符号中任意两种组合
 */
const loginRules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    {
      pattern: /^[a-zA-Z0-9_-]{4,16}$/,
      message: '用户名格式：4-16 位字母、数字、下划线、连字符的任意组合',
      trigger: 'blur',
    },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\W]{8,18}$/,
      message: '密码格式：8-18 位数字、字母、符号的任意两种组合',
      trigger: 'blur',
    },
  ],
})

/**
 * 处理登录提交
 *
 * 执行流程：
 * 1. 先验证表单是否符合规则
 * 2. 验证通过后，调用 userStore.userLogin 发起登录请求
 * 3. 登录成功：显示成功消息，通知父组件关闭弹窗
 * 4. 登录失败：显示错误消息
 * 5. 无论成功失败，都关闭加载状态
 */
const handleLogin = async () => {
  if (!loginFormRef.value) return
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        // 调用 store 里的登录方法（发请求到后端）
        const result = await userStore.userLogin(loginForm)
        if (result.success) {
          ElMessage.success(result.message)
          // 通知父组件关闭弹窗
          emit('success')
        } else {
          ElMessage.error(result.message)
        }
      } catch (error: any) {
        ElMessage.error(error.message || '登录失败')
      } finally {
        loading.value = false
      }
    }
  })
}

/**
 * 切换到注册页面
 * 通知父组件将标签页切换到 register
 * 用 emit 通知父组件（弹窗）切换标签
 */
function switchToRegister() {
  emit('switch-tab', 'register')
}

/**
 * 切换到重置密码页面
 * 通知父组件将标签页切换到 reset
 * 用 emit 通知父组件（弹窗）切换标签
 */
function switchToReset() {
  emit('switch-tab', 'reset')
}
</script>

<template>
  <!-- 登录表单容器 -->
  <div class="login-container">
    <p class="form-subtitle">输入您的用户名以登录您的账户</p>

    <!--
    平时看到的标准登录页
      登录表单：
      - ref: 绑定表单引用，用于手动验证
      - model: 绑定表单数据
      - rules: 绑定验证规则
      - @keyup.enter: 按回车键也能提交表单
    -->
    <el-form ref="loginFormRef" :model="loginForm" :rules="loginRules" label-width="0" size="large"
      @keyup.enter="handleLogin">
      <!-- 用户名输入框 -->
      <el-form-item prop="username">
        <el-input v-model="loginForm.username" placeholder="用户名" :prefix-icon="User" />
      </el-form-item>

      <!-- 密码输入框 -->
      <el-form-item prop="password" class="mt-6">
        <el-input v-model="loginForm.password" type="password" placeholder="密码" :prefix-icon="Lock" show-password />
      </el-form-item>

      <!-- 忘记密码链接 -->
      <div class="forgot-password">
        <a href="#" @click.prevent="switchToReset">忘记密码？</a>
      </div>

      <!-- 登录按钮 -->
      <el-form-item class="mt-6">
        <el-button class="submit-btn" type="primary" :loading="loading" @click="handleLogin">
          登录
        </el-button>
      </el-form-item>
    </el-form>

    <!-- 注册引导文字 -->
    <p class="signup-text">
      没有账户？
      <a href="#" @click.prevent="switchToRegister">注册</a>
    </p>
  </div>
</template>

<style scoped>
/* 登录容器样式：居中显示，最大宽度400px */
.login-container {
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
}

/* 副标题样式 */
.form-subtitle {
  color: #666;
  margin-bottom: 24px;
  font-size: 14px;
}

/* 表单项间距 */
:deep(.el-form-item) {
  margin-bottom: 20px;
}

/* 输入框圆角 */
:deep(.el-input__wrapper) {
  border-radius: 8px;
}

/* 登录按钮样式：全宽、圆角、固定高度 */
.submit-btn {
  width: 100%;
  border-radius: 8px;
  height: 40px;
  font-size: 16px;
}

/* 注册引导文字样式 */
.signup-text {
  text-align: center;
  margin-top: 16px;
  color: #666;
}

.signup-text a {
  color: #2a68fa;
  font-weight: 600;
  text-decoration: none;
}

.signup-text a:hover {
  text-decoration: underline;
}

/* 忘记密码链接样式 */
.forgot-password {
  text-align: right;
  margin: -10px 0 10px;
}

.forgot-password a {
  color: #666;
  font-size: 14px;
  text-decoration: none;
}

.forgot-password a:hover {
  color: #2a68fa;
  text-decoration: underline;
}
</style>
