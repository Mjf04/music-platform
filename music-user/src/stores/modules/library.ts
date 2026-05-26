import { defineStore } from 'pinia'
import type { ResultTable } from '@/api/system'

/**
 * 曲库数据状态管理 Store
 * 
 * 用于存储和管理曲库页面的表格数据（歌曲列表、分页信息等）
 */
export const useLibraryStore = defineStore('LibraryStore', {
  state: () => ({
    tableData: null as ResultTable['data'] | null,
  }),
  actions: {
    /**
     * 设置曲库表格数据
     * 
     * @param data - 从后端获取的曲库分页数据对象
     */
    setTableData(data: ResultTable['data']) {
      this.tableData = data
    },
  },
}) 