/**
 * 刚打开网站，还没点任何歌时，播放器不能是空的，必须有东西显示
 * 所以显示这个：未选择歌曲 + 默认封面
 * 默认播放列表数据
 * 
 * 用于初始化播放器或作为占位数据，包含一首默认的未知歌曲
 */
export const trackListData = [
  {
    id: '1',
    title: '默认歌曲',
    artist: '未知歌手',
    album: '未知专辑',
    cover: new URL(`@/assets/default_album.jpg`, import.meta.url).href,
    url: '',
    duration: 0,
    likeStatus: 0,
  }
]

/**
 * 默认单首歌曲对象
 * 
 * 当没有选择任何歌曲时使用的占位符，
 * 显示"未选择歌曲"提示，避免空值错误
 */
export const defaultSong = {
    id: '0',
    title: '未选择歌曲',
    artist: '未知歌手',
    cover: new URL(`@/assets/default_album.jpg`, import.meta.url).href,
    url: '',
    duration: 0,
    likeStatus: 0,
}