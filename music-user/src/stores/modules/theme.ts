import { defineStore } from 'pinia'
import piniaPersistConfig from '@/stores/helper/persist'
import { ThemeState } from '@/stores/interface'

/**
 * 应用主题状态管理 Store
 * 
 * 负责管理全局视觉主题配置（暗黑模式、主色调），
 * 并支持数据持久化存储
 */
export const themeStore = defineStore({
  id: 'themeStore',
  state: (): ThemeState => ({
    isDark: false,
    primary: '#7E22CE',
  }),
  actions: {
    /**
     * 设置暗黑模式状态
     * 
     * @param isDark - 是否开启暗黑模式（布尔值或可转换为布尔的值）
     */
    setDark(isDark: string | number | boolean) {
      this.isDark = isDark
    },

    /**
     * 设置应用主色调
     * 
     * @param primary - 十六进制颜色字符串
     */
    setPrimary(primary: string) {
      this.primary = primary
    },
  },
  persist: piniaPersistConfig('ThemeStore'),
})
