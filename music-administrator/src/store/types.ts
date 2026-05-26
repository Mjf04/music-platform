import type { RouteRecordName } from "vue-router";

/**
 * 页面缓存配置类型
 */
export type cacheType = {
  mode: string;
  name?: RouteRecordName;
};

/**
 * 位置索引类型，用于记录起始位置和长度
 */
export type positionType = {
  startIndex?: number;
  length?: number;
};

/**
 * 应用全局状态类型
 * 包含侧边栏状态、布局模式、设备类型和视口尺寸等信息
 */
export type appType = {
  sidebar: {
    opened: boolean;
    withoutAnimation: boolean;
    // 判断是否手动点击Collapse
    isClickCollapse: boolean;
  };
  layout: string;
  device: string;
  viewportSize: { width: number; height: number };
};

/**
 * 多标签页路由信息类型
 * 用于存储和管理已打开页面的路由数据
 */
export type multiType = {
  path: string;
  name: string;
  meta: any;
  query?: object;
  params?: object;
};

/**
 * 系统设置配置类型
 * 包含标题、头部固定和侧边栏显示等基础配置
 */
export type setType = {
  title: string;
  fixedHeader: boolean;
  hiddenSideBar: boolean;
};

/**
 * 用户信息类型
 * 包含用户基本资料、角色权限和登录状态等信息
 */
export type userType = {
  avatar?: string;
  username?: string;
  nickname?: string;
  roles?: Array<string>;
  permissions?: Array<string>;
  isRemembered?: boolean;
  loginDay?: number;
};
