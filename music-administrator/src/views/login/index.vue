<script setup lang="ts">
import Motion from "./utils/motion";
import { useRouter } from "vue-router";
import { message } from "@/utils/message";
import { loginRules } from "./utils/rule";
import { useNav } from "@/layout/hooks/useNav";
import type { FormInstance } from "element-plus";
import { useLayout } from "@/layout/hooks/useLayout";
import { useUserStoreHook } from "@/store/modules/user";
import { bg, avatar, illustration } from "./utils/static";
import { useRenderIcon } from "@/components/ReIcon/src/hooks";
import { ref, reactive, toRaw, onMounted, onBeforeUnmount } from "vue";
import { useDataThemeChange } from "@/layout/hooks/useDataThemeChange";
import { addPathMatch, getTopMenu } from "@/router/utils";
import { usePermissionStoreHook } from "@/store/modules/permission";
import { getRegister } from "@/api/user";

import Lock from "@iconify-icons/ri/lock-fill";
import User from "@iconify-icons/ri/user-3-fill";
import Music from "@iconify-icons/ri/music-2-fill";
import Headphone from "@iconify-icons/ri/headphone-fill";

defineOptions({
  name: "Login"
});
const router = useRouter();
const loading = ref(false);
const rememberMe = ref(false);
const ruleFormRef = ref<FormInstance>();
const isLogin = ref(true);

const { initStorage } = useLayout();
initStorage();

const { title } = useNav();

const ruleForm = reactive({
  username: "",
  password: "",
  confirmPassword: ""
});

const registerRules = reactive({
  username: [
    {
      required: true,
      message: "请输入用户名",
      trigger: "blur"
    },
    {
      pattern: /^[a-zA-Z0-9_-]{4,16}$/,
      message: "4-16位字母、数字、下划线、连字符的任意组合",
      trigger: "blur"
    }
  ],
  password: [
    {
      required: true,
      message: "请输入密码",
      trigger: "blur"
    },
    {
      pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\W]{8,18}$/,
      message: "8-18位数字、字母、符号的任意两种组合",
      trigger: "blur"
    }
  ],
  confirmPassword: [
    {
      required: true,
      message: "请确认密码",
      trigger: "blur"
    },
    {
      validator: (rule, value, callback) => {
        if (value !== ruleForm.password) {
          callback(new Error("两次输入的密码不一致"));
        } else {
          callback();
        }
      },
      trigger: "blur"
    }
  ]
});
//收集用户输入、表单验证、触发登录流程、处理登录结果
const onLogin = async (formEl: FormInstance | undefined) => {
  // 1. 表单验证
  if (!formEl) return;
  await formEl.validate((valid, fields) => {
    if (valid) {
      loading.value = true;
      // 2. 调用 Store 的登录方法
      useUserStoreHook()
        .loginByUsername({
          username: ruleForm.username,
          password: ruleForm.password
        })
        .then(res => {
          if (res.code === 0) {
            // 3. 初始化路由和菜单
            usePermissionStoreHook().handleWholeMenus([]);
            addPathMatch();
            // 4. 跳转到首页
            router.push(getTopMenu(true).path).then(() => {
              message("登录成功", { type: "success" });
            });
          } else {
            message("登录失败，" + res.message, { type: "error" });
          }
        })
        .catch(error => {
          message("登录失败，请检查网络连接或稍后重试。", { type: "error" });
          console.error("登录错误：", error);
        })
        .finally(() => (loading.value = false));
    }
  });
};

const onRegister = async (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  await formEl.validate((valid, fields) => {
    if (valid) {
      loading.value = true;
      getRegister({
        username: ruleForm.username,
        password: ruleForm.password
      })
        .then(res => {
          if (res.code === 0) {
            message("注册成功，请登录", { type: "success" });
            isLogin.value = true;
            ruleForm.password = "";
            ruleForm.confirmPassword = "";
          } else {
            message("注册失败，" + res.message, { type: "error" });
          }
        })
        .catch(error => {
          message("注册失败，请检查网络连接或稍后重试。", { type: "error" });
          console.error("注册错误：", error);
        })
        .finally(() => (loading.value = false));
    }
  });
};

function switchMode() {
  isLogin.value = !isLogin.value;
  ruleForm.username = "";
  ruleForm.password = "";
  ruleForm.confirmPassword = "";
}

function onkeypress({ code }: KeyboardEvent) {
  if (["Enter", "NumpadEnter"].includes(code)) {
    if (isLogin.value) {
      onLogin(ruleFormRef.value);
    } else {
      onRegister(ruleFormRef.value);
    }
  }
}

onMounted(() => {
  window.document.addEventListener("keypress", onkeypress);
});

onBeforeUnmount(() => {
  window.document.removeEventListener("keypress", onkeypress);
});
</script>

<template>
  <div class="select-none login-page">
    <div class="animated-bg">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
      <div class="circle circle-4"></div>
    </div>

    <div class="floating-icons">
      <IconifyIconOffline :icon="Music" class="float-icon icon-1" />
      <IconifyIconOffline :icon="Headphone" class="float-icon icon-2" />
      <IconifyIconOffline :icon="Music" class="float-icon icon-3" />
      <IconifyIconOffline :icon="Headphone" class="float-icon icon-4" />
    </div>


    <div class="login-container">
      <div class="login-box">
        <div class="login-header">
          <Motion>
            <div class="logo-wrapper">
              <IconifyIconOffline :icon="Music" class="logo-icon" />
            </div>
          </Motion>
          <Motion :delay="50">
            <h2 class="outline-none login-title">{{ title }}</h2>
          </Motion>
          <Motion :delay="80">
            <p class="login-subtitle">{{ isLogin ? '管理员登录系统' : '管理员注册账号' }}</p>
          </Motion>
        </div>

        <el-form
          ref="ruleFormRef"
          :model="ruleForm"
          :rules="isLogin ? loginRules : registerRules"
          size="large"
          class="login-form"
        >
          <Motion :delay="100">
            <el-form-item prop="username">
              <el-input
                v-model="ruleForm.username"
                clearable
                placeholder="请输入用户名"
                :prefix-icon="useRenderIcon(User)"
                class="custom-input"
              />
            </el-form-item>
          </Motion>

          <Motion :delay="150">
            <el-form-item prop="password">
              <el-input
                v-model="ruleForm.password"
                clearable
                show-password
                placeholder="请输入密码"
                :prefix-icon="useRenderIcon(Lock)"
                class="custom-input"
              />
            </el-form-item>
          </Motion>

          <Motion v-if="!isLogin" :delay="180">
            <el-form-item prop="confirmPassword">
              <el-input
                v-model="ruleForm.confirmPassword"
                clearable
                show-password
                placeholder="请确认密码"
                :prefix-icon="useRenderIcon(Lock)"
                class="custom-input"
              />
            </el-form-item>
          </Motion>

          <Motion :delay="200">
            <div v-if="isLogin" class="login-options">
              <el-checkbox v-model="rememberMe" class="custom-checkbox">
                记住我
              </el-checkbox>
            </div>
          </Motion>

          <Motion :delay="250">
            <el-button
              class="login-btn"
              size="default"
              type="primary"
              :loading="loading"
              @click="isLogin ? onLogin(ruleFormRef) : onRegister(ruleFormRef)"
            >
              <span v-if="!loading">{{ isLogin ? '登 录' : '注 册' }}</span>
              <span v-else>{{ isLogin ? '登录中...' : '注册中...' }}</span>
            </el-button>
          </Motion>

          <Motion :delay="280">
            <div class="switch-mode">
              <span class="switch-text">
                {{ isLogin ? '还没有账号？' : '已有账号？' }}
              </span>
              <el-link
                type="primary"
                :underline="false"
                class="switch-link"
                @click="switchMode"
              >
                {{ isLogin ? '立即注册' : '去登录' }}
              </el-link>
            </div>
          </Motion>
        </el-form>

      </div>
    </div>
  </div>
</template>

<style scoped>
@import url("@/style/login.css");
</style>

<style lang="scss" scoped>
.login-page {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

.animated-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  z-index: 0;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(45deg,
      rgba(102, 126, 234, 0.8) 0%,
      rgba(118, 75, 162, 0.8) 50%,
      rgba(255, 107, 107, 0.6) 100%);
    animation: gradientShift 15s ease infinite;
  }
}

@keyframes gradientShift {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.9;
    transform: scale(1.1);
  }
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 20s infinite ease-in-out;

  &.circle-1 {
    width: 300px;
    height: 300px;
    top: -100px;
    left: -100px;
    animation-delay: 0s;
  }

  &.circle-2 {
    width: 200px;
    height: 200px;
    bottom: -50px;
    right: -50px;
    animation-delay: 2s;
  }

  &.circle-3 {
    width: 150px;
    height: 150px;
    top: 50%;
    right: 10%;
    animation-delay: 4s;
  }

  &.circle-4 {
    width: 250px;
    height: 250px;
    bottom: 20%;
    left: 5%;
    animation-delay: 6s;
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  33% {
    transform: translateY(-30px) rotate(120deg);
  }
  66% {
    transform: translateY(30px) rotate(240deg);
  }
}

.floating-icons {
  position: absolute;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none;

  .float-icon {
    position: absolute;
    font-size: 40px;
    color: rgba(255, 255, 255, 0.15);
    animation: iconFloat 15s infinite ease-in-out;

    &.icon-1 {
      top: 15%;
      left: 10%;
      animation-delay: 0s;
    }

    &.icon-2 {
      top: 70%;
      left: 15%;
      animation-delay: 3s;
    }

    &.icon-3 {
      top: 20%;
      right: 12%;
      animation-delay: 6s;
    }

    &.icon-4 {
      bottom: 25%;
      right: 8%;
      animation-delay: 9s;
    }
  }
}

@keyframes iconFloat {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
    opacity: 0.15;
  }
  50% {
    transform: translateY(-40px) rotate(180deg);
    opacity: 0.3;
  }
}

.login-container {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100vh;
  padding: 20px;
}

.login-box {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 50px 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  max-width: 450px;
  width: 100%;
  animation: slideUp 0.6s ease-out;

  &:hover {
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 35px;

  .logo-wrapper {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 80px;
    height: 80px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 50%;
    margin-bottom: 20px;
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);

    .logo-icon {
      font-size: 40px;
      color: white;
    }
  }

  .login-title {
    font-size: 28px;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin: 0 0 8px 0;
    letter-spacing: 1px;
  }

  .login-subtitle {
    font-size: 14px;
    color: #666;
    margin: 0;
  }
}

.login-form {
  :deep(.el-form-item) {
    margin-bottom: 20px;
  }

  :deep(.el-input__wrapper) {
    border-radius: 10px;
    padding: 12px 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease;

    &:hover {
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
    }

    &.is-focus {
      box-shadow: 0 4px 15px rgba(102, 126, 234, 0.25);
    }
  }

  :deep(.el-input__inner) {
    font-size: 15px;
  }
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;

  :deep(.el-checkbox__label) {
    font-size: 14px;
    color: #666;
  }
}

.login-btn {
  width: 100%;
  height: 48px;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 2px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 25px rgba(102, 126, 234, 0.5);
  }

  &:active {
    transform: translateY(0);
  }
}

.switch-mode {
  text-align: center;
  margin-top: 20px;

  .switch-text {
    font-size: 14px;
    color: #666;
    margin-right: 8px;
  }

  .switch-link {
    font-size: 14px;
    font-weight: 600;

    &:hover {
      color: #764ba2;
    }
  }
}

@media screen and (max-width: 768px) {
  .login-box {
    padding: 40px 30px;
    max-width: 90%;
  }

  .login-header {
    .logo-wrapper {
      width: 70px;
      height: 70px;

      .logo-icon {
        font-size: 35px;
      }
    }

    .login-title {
      font-size: 24px;
    }
  }

  .floating-icons {
    display: none;
  }
}

@media screen and (max-width: 480px) {
  .login-box {
    padding: 35px 25px;
  }

  .login-header {
    .logo-wrapper {
      width: 60px;
      height: 60px;

      .logo-icon {
        font-size: 30px;
      }
    }

    .login-title {
      font-size: 22px;
    }

    .login-subtitle {
      font-size: 13px;
    }
  }

  .login-btn {
    height: 44px;
    font-size: 15px;
  }
}
</style>
