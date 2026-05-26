import axios, {
  AxiosInstance,
  AxiosRequestConfig,
  InternalAxiosRequestConfig,
  AxiosRequestHeaders,
} from 'axios'
import NProgress from '@/config/nprogress'
import 'nprogress/nprogress.css'
import { UserStore } from '@/stores/modules/user'
import { ElMessage } from 'element-plus'
/*这个文件 = 全局请求工具
统一发送请求、自动带 Token、统一处理错误、统一加载提示*/
/**
 * 创建 Axios 实例并配置基础参数
 */
const instance: AxiosInstance = axios.create({
  baseURL: (import.meta as any).env?.VITE_APP_BASE_API || 'http://localhost:8080',
  timeout: 20000,
  headers: {
    Accept: 'application/json, text/plain, */*',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  },
  withCredentials: false,
})

/**
 * 请求拦截器
 * 
 * 功能：
 * 1. 开启页面加载进度条
 * 2. 自动为除登录外的请求添加 Bearer Token 认证头
 */
instance.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    NProgress.start()

    if (config.url?.includes('/user/login')) {
      return config
    }

    // FormData 上传须由浏览器自动设置 multipart boundary
    if (config.data instanceof FormData) {
      if (config.headers) {
        delete config.headers['Content-Type']
      }
    }

    const userStore = UserStore()
    const token = userStore.userInfo?.token

    if (token) {
      if (!config.headers) {
        config.headers = {} as AxiosRequestHeaders
      }
      config.headers.Authorization = token.startsWith('Bearer ')
        ? token
        : `Bearer ${token}`
    }

    return config
  },
  (error) => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

/**
 * 响应拦截器
 * 
 * 功能：
 * 1. 关闭进度条并提取响应数据
 * 2. 统一处理 HTTP 状态码错误（401/403/404/500）并弹出提示
 */
instance.interceptors.response.use(
  (response) => {
    NProgress.done()
    const { data } = response
    return data
  },
  (error) => {
    NProgress.done()

    if (error.response) {
      switch (error.response.status) {
        case 401:
          if (error.config.url?.includes('/user/logout')) {
            break
          }
          if (error.config.url?.includes('/user/login')) {
            ElMessage.error('邮箱或密码错误')
            break
          }
          // 未带 Token 的请求（如未登录访问收藏）不当作「登录过期」
          if (error.config.headers?.Authorization) {
            const userStore = UserStore()
            userStore.clearUserInfo()
            ElMessage.error('登录已过期，请重新登录')
          }
          break
        case 403:
          ElMessage.error('您没有权限执行此操作，请联系管理员')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 500:
          ElMessage.error('服务器错误')
          break
        default:
          ElMessage.error('网络错误')
      }
    } else {
      ElMessage.error('网络连接失败')
    }

    return Promise.reject(error)
  }
)

/**
 * 通用 HTTP 请求方法
 * 
 * @param method - 请求方法类型
 * @param url - 请求地址
 * @param config - 额外的 Axios 配置项
 * @returns 泛型类型的响应数据
 */
export const http = <T>(
  method: 'get' | 'post' | 'put' | 'delete' | 'patch',
  url: string,
  config?: Omit<AxiosRequestConfig, 'method' | 'url'>
): Promise<T> => {
  return instance({ method, url, ...config })
}

/**
 * 封装 GET 请求
 * 
 * @param url - 请求地址
 * @param params - URL 查询参数
 * @returns 泛型类型的响应数据
 */
export const httpGet = <T>(url: string, params?: object): Promise<T> =>
  instance.get(url, { params })

/**
 * 封装 POST 请求
 * 
 * @param url - 请求地址
 * @param data - 请求体数据
 * @param header - 自定义请求头
 * @returns 泛型类型的响应数据
 */
export const httpPost = <T>(
  url: string,
  data?: object,
  header?: object
): Promise<T> => instance.post(url, data, { headers: header })

/**
 * 封装文件上传请求
 * 
 * @param url - 上传接口地址
 * @param formData - 包含文件的 FormData 对象
 * @param header - 自定义请求头
 * @returns 泛型类型的响应数据
 */
export const httpUpload = <T>(
  url: string,
  formData: FormData,
  header?: object
): Promise<T> => {
  return instance.post(url, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
      ...header,
    },
  })
}
