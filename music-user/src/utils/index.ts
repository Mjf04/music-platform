import { useNavigatorLanguage } from '@vueuse/core'

/**
 * 获取并标准化浏览器语言代码
 * 
 * @returns 当前浏览器的语言代码（如 'zh' 或 'en'）
 */
export function getBrowserLang() {
  const { language } = useNavigatorLanguage()
  if (['zh-CN'].includes(language.value as string)) {
    language.value = 'zh'
  }
  return language.value
}

/**
 * 将秒数格式化为 "mm:ss" 格式
 * 
 * @param seconds - 总秒数
 * @returns 格式化后的时间字符串（例如 "03:45"）
 */
export function formatTime(seconds: number): string {
  const min = Math.floor(seconds / 60)
  const sec = Math.floor(seconds % 60)

  return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`
}

/**
 * 将毫秒数格式化为 "HH:mm:ss" 或 "mm:ss" 格式
 * 
 * 如果小时数为 0，则自动省略小时部分
 * 
 * @param totalMilliseconds - 总毫秒数
 * @returns 格式化后的时间字符串
 */
export function formatMillisecondsToTime(totalMilliseconds: number) {
  const totalSeconds = Math.floor(totalMilliseconds / 1000)
  const hours = Math.floor(totalSeconds / 3600)
  const minutes = Math.floor((totalSeconds - hours * 3600) / 60)
  const seconds = totalSeconds % 60

  return [hours, minutes, seconds]
    .map((n) => (n < 10 ? `0${n}` : n.toString()))
    .filter((val, index) => val !== '00' || index > 0)
    .join(':')
}

/**
 * 根据当前系统时间获取问候语
 * 
 * @returns 包含时间段提示和表情符号的字符串（如 "早上好 ⛅"）
 */
export function getTimeState() {
  let timeNow = new Date()
  let hours = timeNow.getHours()
  if (hours >= 6 && hours <= 10) return `早上好 ⛅`
  if (hours >= 10 && hours <= 14) return `中午好 🌞`
  if (hours >= 14 && hours <= 18) return `下午好 🌞`
  if (hours >= 18 && hours <= 24) return `晚上好 🌛`
  if (hours >= 0 && hours <= 6) return `凌晨好 🌛`
}

/**
 * 将大数字格式化为简写形式（万、亿）
 * 
 * @param num - 需要格式化的原始数值
 * @returns 格式化后的字符串（例如 "10W", "2亿"）
 */
export function formatNumber(num: number): string {
  if (num >= 1e8) {
    return (num / 1e8).toFixed(0) + '亿'
  } else if (num >= 1e4) {
    return (num / 1e4).toFixed(0) + 'W'
  } else {
    return num.toString()
  }
}

/**
 * 替换或追加 URL 中的查询参数
 * 
 * @param url - 原始 URL 地址
 * @param newParam - 新的参数字符串（例如 "param=500y500"）
 * @returns 处理后的完整 URL
 */
export function replaceUrlParams(url: string, newParam: string): string {
  if (!url || typeof url !== 'string') return url
  if (url.includes('/file/proxy')) return url
  const questionMarkIndex = url.indexOf('?')
  if (questionMarkIndex === -1) {
    return `${url}?${newParam}`
  }
  const baseUrl = url.substring(0, questionMarkIndex)
  return `${baseUrl}?${newParam}`
}

const getApiBase = () =>
  (typeof import.meta !== 'undefined' && (import.meta as any).env?.VITE_APP_BASE_API) ||
  'http://localhost:8080'

/**
 * 获取图片地址（经后端 /file/proxy 转发，避免 MinIO 跨域导致无法显示）
 *
 * @param url - 图片 URL（一般为 MinIO 完整地址）
 * @returns 浏览器可加载的 URL
 */
export function getImageUrl(url: string | null | undefined): string {
  if (!url || typeof url !== 'string') return ''

  if (!url.startsWith('http')) return url
  if (url.includes('/file/proxy')) return url

  const base = getApiBase().replace(/\/$/, '')
  return `${base}/file/proxy?url=${encodeURIComponent(url)}`
}

/**
 * 将时间戳字符串格式化为 "YYYY-MM-DD HH:mm:ss"
 * 
 * @param timestamp - 可被 Date 对象解析的时间戳字符串
 * @returns 格式化后的日期时间字符串
 */
export function parseTimestamp(timestamp: string): string {
  const date = new Date(timestamp)

  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}
