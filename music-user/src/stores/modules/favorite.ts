import { defineStore } from 'pinia'
import {
  getFavoritePlaylists,
  getFavoriteSongs,
  collectPlaylist,
  cancelCollectPlaylist,
} from '@/api/system'
import type { ResultTable } from '@/api/system'
import type { Song } from '@/api/interface'
import { ElMessage } from 'element-plus'
import coverImg from '@/assets/cover.png'

/**
 * 收藏歌单数据模型
 */
interface FavoritePlaylist {
  id: number
  name: string
  coverImgUrl: string
}

/**
 * 用户收藏歌单状态管理 Store
 * 
 * 负责管理用户收藏的歌单列表，提供获取、收藏、取消收藏等操作
 */
export const useFavoriteStore = defineStore('favorite', {
  state: () => ({
    favoritePlaylists: [] as FavoritePlaylist[],
    /** 已收藏歌曲 ID，用于播放器/列表与后端状态对齐 */
    favoriteSongIds: [] as number[],
    loading: false,
    songsLoading: false,
  }),

  getters: {
    isSongFavorite: (state) => (songId: number) =>
      state.favoriteSongIds.includes(songId),
  },

  actions: {
    addFavoriteSong(songId: number) {
      if (!this.favoriteSongIds.includes(songId)) {
        this.favoriteSongIds.push(songId)
      }
    },

    removeFavoriteSong(songId: number) {
      this.favoriteSongIds = this.favoriteSongIds.filter(id => id !== songId)
    },

    clearFavoriteSongs() {
      this.favoriteSongIds = []
    },

    /**
     * 分页拉取全部收藏歌曲 ID（登录后调用）
     */
    async loadFavoriteSongIds() {
      try {
        this.songsLoading = true
        const ids: number[] = []
        let pageNum = 1
        const pageSize = 200
        let total = 0

        do {
          const res = await getFavoriteSongs({
            pageNum,
            pageSize,
            songName: '',
            artistName: '',
            album: '',
          })
          if (res.code !== 0 || !res.data) break

          const pageData = res.data as { items: Song[]; total: number }
          total = pageData.total ?? 0
          const items = pageData.items ?? []
          items.forEach(song => {
            if (!ids.includes(song.songId)) {
              ids.push(song.songId)
            }
          })
          if (items.length < pageSize) break
          pageNum += 1
        } while (ids.length < total)

        this.favoriteSongIds = ids
      } catch {
        // 401 等由 http 拦截器处理
      } finally {
        this.songsLoading = false
      }
    },
    /**
     * 获取用户收藏的歌单列表
     * 
     * 从后端拉取前 50 个收藏歌单并更新本地状态
     */
    async getFavoritePlaylists() {
      try {
        this.loading = true
        const res = await getFavoritePlaylists({
          pageNum: 1,
          pageSize: 50,
          title: '',
          style: ''
        })
        if (res.code === 0 && res.data) {
          const data = res.data as ResultTable['data']
          if (data?.items) {
            this.favoritePlaylists = data.items.map(item => ({
              id: item.playlistId,
              name: item.title,
              coverImgUrl: item.coverUrl ?? coverImg
            }))
          }
        }
      } catch (error) {
        ElMessage.error('获取收藏歌单失败')
      } finally {
        this.loading = false
      }
    },

    /**
     * 收藏指定歌单
     * 
     * @param playlistId - 要收藏的歌单 ID
     * @returns true 表示收藏成功，false 表示失败
     */
    async collectPlaylist(playlistId: number) {
      try {
        const res = await collectPlaylist(playlistId)
        if (res.code === 0) {
          ElMessage.success('收藏成功')
          this.getFavoritePlaylists()
          return true
        }
        return false
      } catch (error) {
        ElMessage.error('收藏失败')
        return false
      }
    },

    /**
     * 取消收藏指定歌单
     * 
     * @param playlistId - 要取消收藏的歌单 ID
     * @returns true 表示取消成功，false 表示失败
     */
    async cancelCollectPlaylist(playlistId: number) {
      try {
        const res = await cancelCollectPlaylist(playlistId)
        if (res.code === 0) {
          ElMessage.success('取消收藏成功')
          this.favoritePlaylists = this.favoritePlaylists.filter(item => item.id !== playlistId)
          return true
        }
        return false
      } catch (error) {
        ElMessage.error('取消收藏失败')
        return false
      }
    },

    /**
     * 清空本地收藏列表
     * 
     * 通常在用户退出登录时调用
     */
    clearFavoritePlaylists() {
      this.favoritePlaylists = []
    },

    clearAll() {
      this.clearFavoritePlaylists()
      this.clearFavoriteSongs()
    },
  },
}) 