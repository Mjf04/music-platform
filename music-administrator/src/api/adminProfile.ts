import { http } from "@/utils/http";
import type { Result } from "@/api/system";

export type AdminInfo = {
  adminId: number;
  username: string;
  email?: string | null;
  phone?: string | null;
  avatar?: string | null;
};

/** 获取当前登录管理员信息 */
export const getAdminInfo = () => {
  return http.request<Result>("get", "/admin/getAdminInfo");
};

/** 更新管理员基本信息 */
export const updateAdminInfo = (data: {
  username: string;
  email?: string;
  phone?: string;
}) => {
  return http.request<Result>("put", "/admin/updateAdminInfo", { data });
};

/** 更新管理员头像 */
export const updateAdminAvatar = (formData: FormData) => {
  return http.request<Result>("patch", "/admin/updateAdminAvatar", {
    data: formData,
    transformRequest: [(data) => data]
  });
};

/** 修改管理员密码（成功后需重新登录） */
export const updateAdminPassword = (data: {
  oldPassword: string;
  newPassword: string;
  repeatPassword: string;
}) => {
  return http.request<Result>("patch", "/admin/updateAdminPassword", { data });
};
