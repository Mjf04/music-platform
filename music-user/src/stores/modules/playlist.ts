import { defineStore } from 'pinia'
import type { Song, PlaylistComment } from '@/api/interface'

/**
 * 歌单详细信息接口
 */
interface PlaylistInfo {
  name: string
  description: string
  coverImgUrl: string | null
  creator: {
    nickname: string
    avatarUrl: string
  }
  trackCount: number
  tracks: Song[]
  commentCount: number
  tags: string[]
  comments?: PlaylistComment[]
}

/**
 * 歌单详情状态管理 Store
 * 
 * 用于存储和管理当前查看的歌单基本信息及其包含的歌曲列表
 */
export const usePlaylistStore = defineStore('PlaylistStore', {
  state: () => ({
    playlist: null as PlaylistInfo | null,
    songs: [] as Song[],
  }),
  actions: {
    /**
     * 设置歌单基本详细信息
     * 
     * @param info - 歌单详情对象，传入 null 可清空当前状态
     */
    setPlaylistInfo(info: PlaylistInfo | null) {
      this.playlist = info
    },

    /**
     * 设置当前歌单包含的歌曲列表
     * 
     * @param songs - 歌曲数据数组
     */
    setSongs(songs: Song[]) {
      this.songs = songs
    },
  },
}) 