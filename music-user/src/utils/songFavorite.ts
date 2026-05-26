import { useFavoriteStore } from '@/stores/modules/favorite'
import { UserStore } from '@/stores/modules/user'
import type { trackModel } from '@/stores/interface'

/**
 * 判断歌曲是否已收藏（优先使用本地收藏 ID 缓存，兼容列表里的 likeStatus）
 */
export function isSongLiked(songId: number, likeStatus?: number): boolean {
  const userStore = UserStore()
  if (!userStore.isLoggedIn) return false
  const favoriteStore = useFavoriteStore()
  return favoriteStore.isSongFavorite(songId) || likeStatus === 1
}

/**
 * 将播放列表中已收藏歌曲的 likeStatus 与收藏缓存对齐
 */
export function syncTrackListLikeStatus(trackList: trackModel[]) {
  const userStore = UserStore()
  if (!userStore.isLoggedIn) return
  const favoriteStore = useFavoriteStore()
  trackList.forEach((track) => {
    const songId = Number(track.id)
    if (favoriteStore.isSongFavorite(songId)) {
      track.likeStatus = 1
    }
  })
}
