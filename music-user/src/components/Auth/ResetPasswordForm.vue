<script setup lang="ts">
import { ref, reactive, onUnmounted } from 'vue'
import { Message, Lock, Key } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { sendEmailCode, resetPassword } from '@/api/system'

/**
 * 定义组件事件：
 * - success: 重置成功时触发（本组件未使用，预留）
 * - switch-tab: 切换标签页，告诉父组件要显示哪个页面
 */
const emit = defineEmits(['success', 'switch-tab'])

/**
 * loading: 控制重置按钮的加载状态
 * countdown: 验证码倒计时秒数，0 表示可以重新发送
 * resetFormRef: 表单引用，用于手动触发表单验证
 * timer: 定时器引用，用于清除倒计时（防止内存泄漏）
 */
const loading = ref(false)
const countdown = ref(0)
const resetFormRef = ref<FormInstance>()
let timer: NodeJS.Timeout | null = null

/**
 * 重置密码表单数据：邮箱、验证码、新密码、确认密码
 */
const resetForm = reactive({
  email: '',
  verificationCode: '',
  newPassword: '',
  repeatPassword: '',
})

/**
 * 表单验证逻辑：
 * - 邮箱：必填，必须是合法的邮箱格式
 * - 验证码：必填，6位字母或数字
 * - 新密码：必填，8-18位，必须是数字、字母、符号中任意两种组合
 * - 确认密码：必填，必须与新密码完全一致（自定义验证器）
 */
const resetRules = reactive<FormRules>({
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' },
  ],
  verificationCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    {
      pattern: /^[0-9a-zA-Z]{6}$/,
      message: '验证码格式：6位字符（大小写字母、数字）',
      trigger: 'blur',
    },
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    {
      pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\W]{8,18}$/,
      message: '密码格式：8-18位数字、字母、符号的任意两种组合',
      trigger: 'blur',
    },
  ],
  repeatPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    /**
     * 自定义验证器：检查两次输入的密码是否一致
     */
    {
      validator: (rule: any, value: string, callback: Function) => {
        if (value !== resetForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur',
    },
  ],
})

/**
 * 发送邮箱验证码逻辑
 *
 * 执行流程：
 * 1. 检查是否已输入邮箱
 * 2. 调用后端接口发送验证码到邮箱
 * 3. 发送成功后开始 60 秒倒计时，期间按钮禁用
 * 4. 倒计时结束后自动清除定时器，允许重新发送
 */
const handleSendCode = async () => {
  try {
    if (!resetForm.email) {
      ElMessage.warning('请先输入邮箱')
      return
    }
    const response = await sendEmailCode(resetForm.email)
    if (response.code === 0) {
      ElMessage.success('验证码已发送')
      countdown.value = 60
      timer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) {
          if (timer) {
            clearInterval(timer)
            timer = null
          }
        }
      }, 1000)
    } else {
      ElMessage.error(response.message)
    }
  } catch (error: any) {
    ElMessage.error(error.message || '发送验证码失败')
  }
}

/**
 * 处理重置密码提交
 *
 * 执行流程：
 * 1. 先验证表单是否符合所有规则（包括密码一致性）
 * 2. 验证通过后，调用后端重置密码接口
 * 3. 重置成功：提示用户，自动切换到登录标签页
 * 4. 重置失败：显示错误消息
 * 5. 无论成功失败，都关闭加载状态
 */
const handleReset = async () => {
  if (!resetFormRef.value) return
  await resetFormRef.value.validate(async (valid, fields) => {
    if (valid) {
      loading.value = true
      try {
        const response = await resetPassword(resetForm)
        if (response.code === 0) {
          ElMessage.success('密码重置成功，请登录')
          emit('switch-tab', 'login')
        } else {
          ElMessage.error(response.message)
        }
      } catch (error: any) {
        ElMessage.error(error.message || '密码重置失败')
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

/**
 * 组件卸载时清除定时器
 * 防止组件销毁后定时器仍在运行导致内存泄漏
 */
onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
    timer = null
  }
})
</script>

<template>
  <!-- 重置密码表单容器 -->
  <div class="reset-container">
    <p class="form-subtitle">我们将向您的邮箱发送验证码以重置密码</p>

    <!--
      重置密码表单：
      - ref: 绑定表单引用，用于手动验证
      - model: 绑定表单数据
      - rules: 绑定验证规则
      - @keyup.enter: 按回车键也能提交表单
    -->
    <el-form ref="resetFormRef" :model="resetForm" :rules="resetRules" label-width="0" size="large"
      @keyup.enter="handleReset">
      <!-- 邮箱输入框 + 获取验证码按钮 -->
      <el-form-item prop="email">
        <el-input v-model="resetForm.email" placeholder="邮箱" :prefix-icon="Message">
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
        <el-input v-model="resetForm.verificationCode" placeholder="验证码" :prefix-icon="Key" />
      </el-form-item>

      <!-- 新密码输入框 -->
      <el-form-item prop="newPassword" class="mt-6">
        <el-input v-model="resetForm.newPassword" type="password" placeholder="新密码" :prefix-icon="Lock" show-password />
      </el-form-item>

      <!-- 确认密码输入框 -->
      <el-form-item prop="repeatPassword" class="mt-6">
        <el-input v-model="resetForm.repeatPassword" type="password" placeholder="确认密码" :prefix-icon="Lock"
          show-password />
      </el-form-item>

      <!-- 重置密码按钮 -->
      <el-form-item class="mt-6">
        <el-button class="submit-btn" type="primary" :loading="loading" @click="handleReset">
          重置密码
        </el-button>
      </el-form-item>
    </el-form>

    <!-- 返回登录引导文字 -->
    <p class="login-text">
      记起密码了？
      <a href="#" @click.prevent="switchToLogin">返回登录</a>
    </p>
  </div>
</template>

<style scoped>
/* 重置密码容器样式：居中显示，最大宽度400px */
.reset-container {
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

/* 重置按钮样式：全宽、圆角、固定高度 */
.submit-btn {
  width: 100%;
  border-radius: 8px;
  height: 40px;
  font-size: 16px;
}

/* 返回登录引导文字样式 */
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
