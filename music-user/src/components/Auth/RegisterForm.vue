<script setup lang="ts">
import { ref, reactive } from 'vue'
import { User, Message, Lock, Key } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { sendEmailCode, register } from '@/api/system'

/**
 * 定义组件事件：
 * - success: 注册成功时触发（本组件未使用，预留）
 * - switch-tab: 切换标签页，告诉父组件要显示哪个页面
 */
const emit = defineEmits(['success', 'switch-tab'])

/**
 * loading: 控制注册按钮的加载状态
 * countdown: 验证码倒计时秒数，0 表示可以重新发送
 * registerFormRef: 表单引用，用于手动触发表单验证
 */
const loading = ref(false)
const countdown = ref(0)
const registerFormRef = ref<FormInstance>()

/**
 * 注册表单数据：用户名、邮箱、密码、验证码
 */
const registerForm = reactive({
  username: '',
  email: '',
  password: '',
  verificationCode: '',
})

/**
 * 表单验证规则：
 * - 用户名：必填，4-16位字母/数字/下划线/连字符
 * - 邮箱：必填，必须是合法的邮箱格式
 * - 密码：必填，8-18位，必须是数字、字母、符号中任意两种组合
 * - 验证码：必填，6位字母或数字
 */
const registerRules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    {
      pattern: /^[a-zA-Z0-9_-]{4,16}$/,
      message: '用户名格式：4-16位字符（字母、数字、下划线、连字符）',
      trigger: 'blur',
    },
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\W]{8,18}$/,
      message: '密码格式：8-18位数字、字母、符号的任意两种组合',
      trigger: 'blur',
    },
  ],
  verificationCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    {
      pattern: /^[0-9a-zA-Z]{6}$/,
      message: '验证码格式：6位字符（大小写字母、数字）',
      trigger: 'blur',
    },
  ],
})

/**
 * 发送邮箱验证码
 *
 * 执行流程：
 * 1. 检查是否已输入邮箱
 * 2. 调用后端接口发送验证码
 * 3. 发送成功后开始 60 秒倒计时，期间按钮禁用
 * 4. 倒计时结束后可以重新发送
 */
const handleSendCode = async () => {
  try {
    // 1. 检查是否已输入邮箱
    if (!registerForm.email) {
      ElMessage.warning('请先输入邮箱')
      return
    }
    // 2. 调用后端接口发送验证码
    const response = await sendEmailCode(registerForm.email)
    if (response.code === 0) {
      // 3. 发送成功
      ElMessage.success('验证码已发送')
      // 4. 开始60秒倒计时
      countdown.value = 60
      const timer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) {
          clearInterval(timer)
        }
      }, 1000)
    } else {
      // 5. 发送失败，显示错误消息
      ElMessage.error(response.message)
    }
  } catch (error: any) {
    ElMessage.error(error.message || '发送验证码失败')
  }
}

/**
 * 处理注册提交
 *
 * 执行流程：
 * 1. 先验证表单是否符合所有规则
 * 2. 验证通过后，调用后端注册接口
 * 3. 注册成功：提示用户，自动切换到登录标签页
 * 4. 注册失败：显示错误消息
 * 5. 无论成功失败，都关闭加载状态
 */
const handleRegister = async () => {
  if (!registerFormRef.value) return
  // 1. 先验证表单规则（包括验证码格式）
  await registerFormRef.value.validate(async (valid, fields) => {
    if (valid) {
      loading.value = true
      try {
        // 2. 调用注册接口（后端会验证验证码是否正确）
        const response = await register(registerForm)
        if (response.code === 0) {
          ElMessage.success('注册成功，请登录')
          emit('switch-tab', 'login')
        } else {
          ElMessage.error(response.message)
        }
      } catch (error: any) {
        ElMessage.error(error.message || '注册失败')
      } finally {
        loading.value = false
      }
    } else {
      console.log('验证失败:', fields)
    }
  })
}

/**
 * 切换到登录页面
 * 通知父组件将标签页切换到 login
 */
function switchToLogin() {
  emit('switch-tab', 'login')
}
</script>

<template>
  <!-- 注册表单容器 -->
  <div class="register-container">
    <p class="form-subtitle">创建一个新账户</p>

    <!--
      注册表单：
      - ref: 绑定表单引用，用于手动验证
      - model: 绑定表单数据
      - rules: 绑定验证规则
      - @keyup.enter: 按回车键也能提交表单
    -->
    <el-form ref="registerFormRef" :model="registerForm" :rules="registerRules" label-width="0" size="large"
      @keyup.enter="handleRegister">
      <!-- 用户名输入框 -->
      <el-form-item prop="username">
        <el-input v-model="registerForm.username" placeholder="用户名" :prefix-icon="User" />
      </el-form-item>

      <!-- 邮箱输入框 + 获取验证码按钮 -->
      <el-form-item prop="email" class="mt-6">
        <el-input v-model="registerForm.email" placeholder="邮箱" :prefix-icon="Message">
          <template #append>
            <!-- 倒计时期间按钮禁用，显示剩余秒数 -->
            <el-button :disabled="!!countdown || loading" @click="handleSendCode">
              {{ countdown ? `${countdown}s后重试` : '获取验证码' }}
            </el-button>
          </template>
        </el-input>
      </el-form-item>

      <!-- 验证码输入框 -->
      <el-form-item prop="verificationCode" class="mt-6">
        <el-input v-model="registerForm.verificationCode" placeholder="验证码" :prefix-icon="Key" />
      </el-form-item>

      <!-- 密码输入框 -->
      <el-form-item prop="password" class="mt-6">
        <el-input v-model="registerForm.password" type="password" placeholder="密码" :prefix-icon="Lock" show-password />
      </el-form-item>

      <!-- 注册按钮 -->
      <el-form-item class="mt-6">
        <el-button class="submit-btn" type="primary" :loading="loading" @click="handleRegister">
          注册
        </el-button>
      </el-form-item>
    </el-form>

    <!-- 登录引导文字 -->
    <p class="login-text">
      已有账户？
      <a href="#" @click.prevent="switchToLogin">登录</a>
    </p>
  </div>
</template>


<style scoped>
/* 注册容器样式：居中显示，最大宽度400px */
.register-container {
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

/* 注册按钮样式：全宽、圆角、固定高度 */
.submit-btn {
  width: 100%;
  border-radius: 8px;
  height: 40px;
  font-size: 16px;
}

/* 登录引导文字样式 */
.login-text {
  text-align: center;
  margin-top: 16px;
  color: #666;
}

.login-text a {
  color: #2a68fa;
  font-weight: 600;
  text-decoration: none;
}

.login-text a:hover {
  text-decoration: underline;
}
</style>
