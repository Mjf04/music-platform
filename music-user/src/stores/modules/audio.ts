import { defineStore } from 'pinia'
import piniaPersistConfig from '@/stores/helper/persist'
import { trackListData } from '@/mock'
import { AudioState, trackModel } from '@/stores/interface'
import { Song } from '@/api/interface'
/**
 * 音频播放器状态管理 Store
 *
 * 负责管理播放列表、当前播放索引、音量等全局音频状态，
 * 并支持数据持久化存储
 */
export const useAudioStore = defineStore({
  id: 'AudioStore',
  state: (): AudioState => ({
    // 歌曲缓存
    trackList: trackListData,
    // 当前播放歌曲索引
    currentSongIndex: 0,
    // 音量
    volume: 50,
    // 音质
    quality: 'exhigh',
    currentPageSongs: [], // 当前页面的歌曲列表
  }),
  actions: {
    /**
     * 更新音频 Store 中的指定状态字段
     *
     * @param key - 需要更新的状态字段名
     * @param value - 新的状态值
     */
    setAudioStore<T extends keyof AudioState>(key: T, value: AudioState[T]) {
      this[key] = value
    },
    /**
     * 向播放列表中添加一首或多首歌曲
     *
     * 逻辑说明：
     * - 如果歌曲已存在，则直接跳转到该歌曲
     * - 如果歌曲不存在，则添加到列表末尾并设为当前播放
     *
     * @param newTracks - 要添加的歌曲对象或歌曲数组
     */
    addTracks(newTracks: trackModel | trackModel[]) {
      // 收集现有歌曲的ID
      const existingIds = new Set(
        this.trackList.map((track: { id: any }) => track.id)
      )
      // 将参数归一化为数组
      const tracksToAdd = Array.isArray(newTracks) ? newTracks : [newTracks]
      for (const track of tracksToAdd) {
        if (existingIds.has(track.id)) {
          const index = this.trackList.findIndex(
            (existingTrack: { id: string }) => existingTrack.id === track.id
          )
          this.currentSongIndex = index
          if (index >= 0 && track.likeStatus === 1) {
            this.trackList[index].likeStatus = 1
          }
          break
        } else {
          this.trackList.push(track)
          this.currentSongIndex = this.trackList.length - 1
        }
      }
    },
    /**
     * 从播放列表中删除指定歌曲
     *
     * @param id - 要删除的歌曲 ID
     */
    deleteTrack(id: number | string) {
      this.trackList = this.trackList.filter(
        (track: { id: string | number }) => track.id !== id
      )
    },
    /**
     * 设置当前页面展示的歌曲列表
     *
     * 用于同步不同页面（如曲库、歌单详情页）的歌曲数据
     *
     * @param songs - 当前页面的歌曲数组
     */
    setCurrentPageSongs(songs: Song[]) {
      this.currentPageSongs = songs
    }
  },
  persist: piniaPersistConfig('AudioStore'),
})