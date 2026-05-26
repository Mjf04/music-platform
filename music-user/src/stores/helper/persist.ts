import { PersistenceOptions } from "pinia-plugin-persistedstate";

/**
 * 正常情况下
 * 全局状态（比如你登录的用户信息），刷新页面就没了，变回未登录
 * 用了这个工具：
 * 状态会自动存到 localStorage
 * 刷新 / 关闭重开页面，数据还在
 *
 * 生成 Pinia Store 的持久化配置对象
 * 
 * 使用 localStorage 作为存储介质，确保数据在浏览器关闭后依然保留
 * 
 * @param key - 持久化存储的唯一标识键名，通常与 Store 的名称保持一致
 * @returns 符合 pinia-plugin-persistedstate 规范的配置对象
 */
const piniaPersistConfig = (key: string) => {
    const persist: PersistenceOptions = {
        key,
        storage: localStorage,
    };
    return persist;
};

export default piniaPersistConfig;