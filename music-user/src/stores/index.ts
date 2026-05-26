import { createPinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

/**** 这个文件 = Pinia 入口
   创建全局状态管理实例，并开启持久化功能（让所有 store 都能用 persist 持久化）
 * 创建并配置 Pinia 实例
 * 
 * 集成 pinia-plugin-persistedstate 插件，
 * 为 Store 提供自动持久化功能（如存入 localStorage）
 */
const pinia = createPinia();
pinia.use(piniaPluginPersistedstate);

export default pinia;