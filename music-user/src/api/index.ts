import { httpGet } from '@/utils/http'
import { useAudioStore } from '@/stores/modules/audio'

/**
 * 获取歌曲的真实播放地址
 * @param id - 歌曲ID，可以是数字或字符串类型
 * @returns 返回包含歌曲URL数组的响应数据
 */
export const urlV1 = (id: number | string) => {
  const audio = useAudioStore()
  return httpGet<{ data: { url: string }[] }>(
    `song/url/v1?id=${id}&level=${audio.quality}`
  )
}

// 获取歌词
// export const lyric = (id: number | string) =>
//   httpGet<LyricsResponse>(`/lyric?id=${id}`) 作用：目前主要存放获取音乐真实播放地址的逻辑。

// 获取歌词
// export const lyricNew = (id: number | string) =>
//   httpGet<LyricsResponse>(`/lyric/new?id=${id}`)
