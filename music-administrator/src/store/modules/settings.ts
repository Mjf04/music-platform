import { defineStore } from "pinia";
import { type setType, store, getConfig } from "../utils";

/**
 * 系统设置状态管理
 * 
 * 管理应用的全局配置项，如标题、头部固定、侧边栏显示等。
 * 配置值从 platform-config.json 中初始化，支持运行时动态修改。
 */
export const useSettingStore = defineStore({
  id: "pure-setting",
  state: (): setType => ({
    title: getConfig().Title,
    fixedHeader: getConfig().FixedHeader,
    hiddenSideBar: getConfig().HiddenSideBar
  }),
  getters: {
    /**
     * 获取系统标题
     */
    getTitle(state) {
      return state.title;
    },
    /**
     * 获取头部是否固定配置
     */
    getFixedHeader(state) {
      return state.fixedHeader;
    },
    /**
     * 获取侧边栏是否隐藏配置
     */
    getHiddenSideBar(state) {
      return state.hiddenSideBar;
    }
  },
  actions: {
    /**
     * 修改系统配置项
     * 
     * @param key - 配置项键名
     * @param value - 新的配置值
     */
    CHANGE_SETTING({ key, value }) {
      if (Reflect.has(this, key)) {
        this[key] = value;
      }
    },
    /**
     * 修改系统配置项（对外暴露的方法）
     * 
     * @param data - 包含 key 和 value 的配置对象
     */
    changeSetting(data) {
      this.CHANGE_SETTING(data);
    }
  }
});

/**
 * 获取系统设置 Store 实例的钩子函数
 * 
 * 用于在组件中方便地访问系统设置状态，避免重复创建实例。
 * 
 * @returns 返回系统设置 Store 实例
 */
export function useSettingStoreHook() {
  return useSettingStore(store);
}
