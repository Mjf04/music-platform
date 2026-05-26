import { defineStore } from 'pinia'
import piniaPersistConfig from '@/stores/helper/persist'
import { MenuState } from '@/stores/interface'

/**
 * 菜单导航状态管理 Store
 * 
 * 用于记录当前选中的菜单项索引，支持数据持久化，
 * 确保页面刷新后仍能保持菜单选中状态
 */
export const MenuStore = defineStore({
  id: 'MenuStore',
  state: (): MenuState => ({
    menuIndex: '1-0',
  }),
  actions: {
    /**
     * 设置当前选中的菜单索引
     * 
     * @param menuIndex - 菜单项的唯一标识字符串
     */
    setMenuIndex(menuIndex: string) {
      this.menuIndex = menuIndex
    },
  },
  persist: piniaPersistConfig('MenuStore'),
})
