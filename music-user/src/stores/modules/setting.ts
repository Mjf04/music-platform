import { defineStore } from 'pinia'
import piniaPersistConfig from '@/stores/helper/persist'
import { SettingState } from '@/stores/interface'

/**
 * 系统设置状态管理 Store
 * 
 * 负责管理应用的个性化配置（如歌词解析选项、语言设置等），
 * 并支持数据持久化存储
 */
export const settingStore = defineStore({
  id: 'settingStore',
  state: (): SettingState => ({
    isDrawerCover: true,
    isOriginalParsed: true,
    isTranslatedParsed: true,
    isRomaParsed: true,
    language: null,
  }),
  actions: {
    /**
     * 批量或单项更新设置状态
     * 
     * 利用 Pinia 的 $patch 方法高效更新状态
     * 
     * @param args - 包含键名和对应值的元组数组
     */
    setSettingState(...args: ObjToKeyValArray<SettingState>) {
      this.$patch({ [args[0]]: args[1] } as Record<string, any>)
    },
  },
  persist: piniaPersistConfig('settingStore'),
})
