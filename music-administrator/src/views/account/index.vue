<script setup lang="ts">
import { h, onMounted, reactive, ref } from "vue";
import type { FormInstance, FormRules } from "element-plus";
import { message } from "@/utils/message";
import defaultAvatar from "@/assets/user.jpg";
import { getImageUrl } from "@/utils/image";
import { useUserStoreHook } from "@/store/modules/user";
import { addDialog } from "@/components/ReDialog";
import ReCropperPreview from "@/components/ReCropperPreview";
import { deviceDetection } from "@pureadmin/utils";
import {
  getAdminInfo,
  updateAdminInfo,
  updateAdminAvatar,
  updateAdminPassword,
  type AdminInfo
} from "@/api/adminProfile";

defineOptions({ name: "AccountProfile" });

const userStore = useUserStoreHook();
const loading = ref(false);
const profileFormRef = ref<FormInstance>();
const passwordFormRef = ref<FormInstance>();
const avatarInfo = ref<{ blob?: Blob }>();
const cropRef = ref();
const avatarUrl = ref("");
const adminId = ref<number | null>(null);

const profileForm = reactive({
  username: "",
  email: "",
  phone: ""
});

const passwordForm = reactive({
  oldPassword: "",
  newPassword: "",
  repeatPassword: ""
});

const profileRules = reactive<FormRules>({
  username: [
    { required: true, message: "请输入用户名", trigger: "blur" },
    {
      pattern: /^[a-zA-Z0-9_-]{4,16}$/,
      message: "4-16位字母、数字、下划线、连字符",
      trigger: "blur"
    }
  ],
  email: [{ type: "email", message: "邮箱格式不正确", trigger: "blur" }],
  phone: [
    {
      pattern: /^$|^1[3-9]\d{9}$/,
      message: "请输入正确的手机号",
      trigger: "blur"
    }
  ]
});

const passwordRules = reactive<FormRules>({
  oldPassword: [{ required: true, message: "请输入原密码", trigger: "blur" }],
  newPassword: [
    { required: true, message: "请输入新密码", trigger: "blur" },
    {
      pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\W]{8,18}$/,
      message: "8-18位，须包含数字与字母等任意两种组合",
      trigger: "blur"
    }
  ],
  repeatPassword: [
    { required: true, message: "请确认新密码", trigger: "blur" },
    {
      validator: (_rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error("两次输入的密码不一致"));
        } else {
          callback();
        }
      },
      trigger: "blur"
    }
  ]
});

const syncToStore = (info: AdminInfo) => {
  userStore.SET_USERNAME(info.username);
  userStore.SET_AVATAR(info.avatar || "");
  avatarUrl.value = info.avatar || "";
  adminId.value = info.adminId;
};

const loadAdminInfo = async () => {
  loading.value = true;
  try {
    const res = await getAdminInfo();
    if (res.code === 0 && res.data) {
      const info = res.data as AdminInfo;
      profileForm.username = info.username || "";
      profileForm.email = info.email || "";
      profileForm.phone = info.phone || "";
      syncToStore(info);
    } else {
      message(res.message || "获取个人信息失败", { type: "error" });
    }
  } catch {
    message("获取个人信息失败", { type: "error" });
  } finally {
    loading.value = false;
  }
};

const handleSaveProfile = async () => {
  if (!profileFormRef.value) return;
  await profileFormRef.value.validate(async valid => {
    if (!valid) return;
    loading.value = true;
    try {
      const res = await updateAdminInfo({
        username: profileForm.username,
        email: profileForm.email,
        phone: profileForm.phone
      });
      if (res.code === 0) {
        message("保存成功", { type: "success" });
        await loadAdminInfo();
      } else {
        message(res.message || "保存失败", { type: "error" });
      }
    } finally {
      loading.value = false;
    }
  });
};

const handleUploadAvatar = () => {
  addDialog({
    title: "裁剪并上传头像",
    width: "40%",
    closeOnClickModal: false,
    fullscreen: deviceDetection(),
    contentRenderer: () =>
      h(ReCropperPreview, {
        ref: cropRef,
        imgSrc: avatarUrl.value ? getImageUrl(avatarUrl.value) : defaultAvatar,
        onCropper: (info: { blob?: Blob }) => {
          avatarInfo.value = info;
        }
      }),
    beforeSure: async done => {
      if (!avatarInfo.value?.blob) {
        message("请先裁剪图片", { type: "warning" });
        return;
      }
      const formData = new FormData();
      formData.append("avatar", avatarInfo.value.blob, "avatar.png");
      try {
        const res = await updateAdminAvatar(formData);
        if (res.code === 0) {
          message("头像更新成功", { type: "success" });
          await loadAdminInfo();
          done();
        } else {
          message(res.message || "头像更新失败", { type: "error" });
        }
      } catch {
        message("头像更新失败", { type: "error" });
      }
    },
    closeCallBack: () => cropRef.value?.hidePopover?.()
  });
};

const handleChangePassword = async () => {
  if (!passwordFormRef.value) return;
  await passwordFormRef.value.validate(async valid => {
    if (!valid) return;
    loading.value = true;
    try {
      const res = await updateAdminPassword({ ...passwordForm });
      if (res.code === 0) {
        message("密码已修改，请重新登录", { type: "success" });
        userStore.logOut();
      } else {
        message(res.message || "修改密码失败", { type: "error" });
      }
    } finally {
      loading.value = false;
    }
  });
};

onMounted(() => {
  loadAdminInfo();
});
</script>

<template>
  <div v-loading="loading" class="account-page">
    <el-card shadow="never" class="mb-4">
      <template #header>
        <span class="font-medium">个人信息</span>
      </template>

      <div class="flex flex-col items-center mb-6">
        <el-avatar
          :key="avatarUrl || 'default'"
          :size="96"
          :src="avatarUrl ? getImageUrl(avatarUrl) : defaultAvatar"
          class="mb-3"
        />
        <el-button type="primary" plain @click="handleUploadAvatar">
          更换头像
        </el-button>
      </div>

      <el-form
        ref="profileFormRef"
        :model="profileForm"
        :rules="profileRules"
        label-width="88px"
        class="max-w-xl"
      >
        <el-form-item label="管理员ID">
          <span class="text-gray-600">{{ adminId ?? "-" }}</span>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="profileForm.username" placeholder="用户名" clearable />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="profileForm.email" placeholder="选填" clearable />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="profileForm.phone" placeholder="选填" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSaveProfile">保存资料</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card shadow="never">
      <template #header>
        <span class="font-medium">修改密码</span>
      </template>
      <el-form
        ref="passwordFormRef"
        :model="passwordForm"
        :rules="passwordRules"
        label-width="100px"
        class="max-w-xl"
      >
        <el-form-item label="原密码" prop="oldPassword">
          <el-input v-model="passwordForm.oldPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="passwordForm.newPassword" type="password" show-password />
        </el-form-item>
        <el-form-item label="确认新密码" prop="repeatPassword">
          <el-input v-model="passwordForm.repeatPassword" type="password" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="warning" @click="handleChangePassword">修改密码</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.account-page {
  padding: 12px;
}
</style>
