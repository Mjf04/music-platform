/**
 * 权限控制组件导出模块
 * 权限组件的「统一出口」
 * 它本身不实现功能，
 * 只做一件事：把权限组件 Auth 统一导出，方便全局 / 局部引入使用！
 * 提供 Auth 组件的全局注册和导出
 */
import auth from "./src/auth";

const Auth = auth;

export { Auth };
