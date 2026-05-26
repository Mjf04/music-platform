import { http } from "@/utils/http";
/*动态权限路由接口】
作用：根据当前登录用户的身份（管理员 / 普通用户），
动态获取他能访问的页面菜单*/
/**
 * 异步路由响应数据结构
 */
type Result = {
  success: boolean;
  data: Array<any>;
};

/**
 * 获取当前用户有权限访问的异步路由列表
 * 
 * 用于实现动态路由和菜单生成：
 * 1. 用户登录成功后调用此接口
 * 2. 后端根据用户角色（管理员/普通用户）返回对应的路由配置
 * 3. 前端将路由动态添加到 Vue Router 实例中
 * 4. 根据路由生成侧边栏菜单
 * 5. 确保用户只能访问有权限的页面
 * 
 * @returns 包含路由配置数组的响应对象
 */
export const getAsyncRoutes = () => {
  return http.request<Result>("get", "/get-async-routes");
};
