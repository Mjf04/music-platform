import axios from "axios";
import type { App } from "vue";

let config: object = {};
const { VITE_PUBLIC_PATH } = import.meta.env;

/**
 * 合并配置对象
 * 负责管理和提供整个后台系统的所有配置信息。
 * @param cfg - 要合并的配置对象（可选）
 */
const setConfig = (cfg?: unknown) => {
  config = Object.assign(config, cfg);
};

/**
 * 根据键名获取配置值，支持点号分隔的嵌套路径
 * 
 * @param key - 配置键名，可以是点号分隔的路径字符串（如 "app.name"）
 * @returns 返回配置值，如果未找到则返回 null 或整个配置对象
 */
const getConfig = (key?: string): PlatformConfigs => {
  if (typeof key === "string") {
    const arr = key.split(".");
    if (arr && arr.length) {
      let data = config;
      arr.forEach(v => {
        if (data && typeof data[v] !== "undefined") {
          data = data[v];
        } else {
          data = null;
        }
      });
      return data;
    }
  }
  return config;
};

/**
 * 获取项目动态全局配置并注入到 Vue 应用中
 * 
 * 执行流程：
 * 1. 将当前配置设置到 Vue 全局属性上
 * 2. 从 public/platform-config.json 文件异步加载配置
 * 3. 自动合并远程配置到全局配置中
 * 4. 更新 Vue 全局属性和本地配置缓存
 * 
 * @param app - Vue 应用实例
 * @returns 返回合并后的全局配置对象，如果加载失败则抛出错误
 */
export const getPlatformConfig = async (app: App): Promise<undefined> => {
  app.config.globalProperties.$config = getConfig();
  return axios({
    method: "get",
    url: `${VITE_PUBLIC_PATH}platform-config.json`
  })
    .then(({ data: config }) => {
      let $config = app.config.globalProperties.$config;
      // 自动注入系统配置
      if (app && $config && typeof config === "object") {
        $config = Object.assign($config, config);
        app.config.globalProperties.$config = $config;
        // 设置全局配置
        setConfig($config);
      }
      return $config;
    })
    .catch(() => {
      throw "请在public文件夹下添加platform-config.json配置文件";
    });
};

/**
 * 获取本地响应式存储的命名空间前缀
 * 
 * @returns 返回配置中定义的存储命名空间字符串
 */
const responsiveStorageNameSpace = () => getConfig().ResponsiveStorageNameSpace;

export { getConfig, setConfig, responsiveStorageNameSpace };
