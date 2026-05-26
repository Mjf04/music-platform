/**
 * 通用键值对记录类型
 */
declare type Recordable<T = any> = Record<string, T>

/**
 * Vite 环境变量配置接口
 * 
 * 定义了项目中使用的各类环境变量及其类型约束
 */
declare interface ViteEnv {
  VITE_USER_NODE_ENV: 'development' | 'production' | 'test'
  VITE_PUBLIC_PATH: string
  VITE_ROUTER_MODE: 'hash' | 'history'
  VITE_APP_BASE_API: string
  VITE_PROXY: [string, string][]
}

interface ImportMetaEnv extends ViteEnv {
  __: unknown
}
