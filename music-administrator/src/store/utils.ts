/**
 * Store 工具模块统一导出
 * 
 * 集中导出项目中常用的 Store 实例、路由配置、工具函数和类型定义，
 * 方便其他模块按需引入，避免重复导入多个文件。
 */
export { store } from "@/store";
export { routerArrays } from "@/layout/types";
export { router, resetRouter, constantMenus } from "@/router";
export { getConfig, responsiveStorageNameSpace } from "@/config";
export {
  ascending,
  filterTree,
  filterNoPermissionTree,
  formatFlatteningRoutes
} from "@/router/utils";
export {
  isUrl,
  isEqual,
  isNumber,
  debounce,
  isBoolean,
  getKeyList,
  storageLocal,
  deviceDetection
} from "@pureadmin/utils";
export type {
  setType,
  appType,
  userType,
  multiType,
  cacheType,
  positionType
} from "./types";
