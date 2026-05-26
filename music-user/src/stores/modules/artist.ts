import { defineStore } from 'pinia'
import type { Song } from '@/api/interface'

/**
 * 歌手详细信息接口
 */
interface ArtistInfo {
  artistId: number
  artistName: string
  avatar: string
  birth: string
  area: string
  introduction: string
  songs: Song[]
}

/**
 * 歌手信息状态管理 Store
 * 
 * 用于存储和管理当前查看的歌手详情及其作品列表
 */
export const useArtistStore = defineStore('ArtistStore', {
  state: () => ({
    artistInfo: null as ArtistInfo | null,
  }),
  actions: {
    /**
     * 设置歌手详细信息
     * 
     * @param info - 包含歌手基本信息和歌曲列表的对象
     */
    setArtistInfo(info: ArtistInfo) {
      this.artistInfo = info
    },
  },
}) 