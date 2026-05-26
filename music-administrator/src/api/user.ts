import { http } from "@/utils/http";
import { jwtDecode } from "jwt-decode";
import { setToken, type DataInfo, getToken } from "@/utils/auth";

/*用户登录、注册、退出的接口封装
专门处理用户身份验证！整个项目的登录系统、
权限、Token 存储全靠它*/
/**
 * 登录响应数据结构
 */
export type LoginResult = {
  code: number;
  message: string;
  data: string | null;
};

/**
 * 刷新 Token 响应数据结构
 */
export type RefreshTokenResult = {
  success: boolean;
  data: {
    accessToken: string;
    refreshToken: string;
    expires: Date;
  };
};

/**
 * 用户登录并处理 Token 自动存储
 * 
 * 执行流程：
 * 1. 调用后端登录接口获取 JWT Token
 * 2. 解码 Token 提取用户角色、用户名和过期时间
 * 3. 构建用户数据对象并存入本地存储
 * 4. 返回登录结果供前端跳转使用
 * 
 * @param data - 包含用户名和密码的登录凭证对象
 * @returns 登录响应结果
 */
export const getLogin = async (data?: object) => {
  // 1. 调用后端登录接口
  const response = await http.request<LoginResult>("post", "/admin/login", {
    data
  });

  if (response.data) {
    // 2. 解码 JWT Token
    const decodedToken: any = jwtDecode(response.data);
    const { role, username } = decodedToken.claims;
    const expires = new Date(decodedToken.exp * 1000);

    // 3. 构建用户数据对象
    const userData: DataInfo<Date> = {
      accessToken: response.data,
      expires,
      refreshToken: "",
      roles: [role],
      username
    };
    // 4. 存储到本地（Cookie + localStorage）
    setToken(userData);
  }

  return response;
};

/**
 * 用户注册
 * 
 * @param data - 包含注册信息的对象（用户名、密码等）
 * @returns 注册响应结果
 */
export const getRegister = (data?: object) => {
  return http.request<LoginResult>("post", "/admin/register", { data });
};

/**
 * 用户退出登录
 * 
 * 通知后端注销当前 Token，前端随后会清除本地存储
 * 
 * @returns 登出响应结果
 */
export const getLogout = () => {
  const userData = getToken();
  return http.request("post", "/admin/logout", {
    headers: { Authorization: userData.accessToken }
  });
};
