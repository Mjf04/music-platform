/**
 * 这个是一个TypeScript 类型定义文件，
 *规范了歌单、歌曲、评论、歌曲详情、歌词、评论信息、
 * 歌曲基本信息、通用评论信息、歌曲详细信息、单行歌词、
 * 解析后的完整歌词等数据结构。
 * 后端给前端返回歌曲、歌单、歌词、评论时
 * 必须严格按照这里定义的字段名、字段类型来返回
 * 前端才能正常识别、渲染、播放
 *
 * 播放列表中的歌曲信息
 * 定义了歌单里每首歌的基本属性，如歌名、歌手、时长等
 */
export interface PlaylistSong {
  songId: number
  songName: string
  artistName: string
  album: string
  duration: string
  coverUrl: string | null
  audioUrl: string
  likeStatus: number
  releaseTime: string | null
}

/**
 * 评论信息
 * 包含评论者的用户名、头像、评论内容和点赞数等
 */
export interface PlaylistComment {
  commentId: number
  username: string
  userAvatar: string | null
  content: string
  createTime: string
  likeCount: number
}

/**
 * 歌单详情
 * 包含歌单的完整信息：标题、封面、简介、歌曲列表和评论列表
 */
export interface PlaylistDetail {
  playlistId: number
  title: string
  coverUrl: string | null
  introduction: string
  songs: PlaylistSong[]
  likeStatus: number
  comments: PlaylistComment[]
  isCollected: boolean
}

/**
 * 歌曲基本信息
 * 用于歌曲列表展示，包含歌曲的核心信息
 */
export interface Song {
  songId: number
  songName: string
  artistName: string
  album: string
  duration: string
  coverUrl: string
  audioUrl: string
  likeStatus: number
  releaseTime: string
}

/**
 * 通用评论信息
 * 适用于歌曲、专辑等各种资源的评论数据结构
 */
export interface Comment {
  commentId: number
  username: string
  userAvatar: string | null
  content: string
  createTime: string
  likeCount: number
}

/**
 * 歌曲详细信息
 * 比 Song 更完整，额外包含歌词内容和评论列表
 */
export interface SongDetail {
  songId: number
  songName: string
  artistName: string
  album: string
  lyric: string | null
  duration: string
  coverUrl: string
  audioUrl: string
  releaseTime: string
  likeStatus: boolean | null
  comments: Comment[]
}

/**
 * 单行歌词
 * 包含歌词文本和对应的时间点（毫秒），用于歌词同步滚动
 */
export interface LyricLine {
  time: number
  text: string
}

/**
 * 解析后的完整歌词
 * 将所有歌词行组织成数组，并标记是否包含翻译
 */
export interface ParsedLyrics {
  lines: LyricLine[]
  hasTranslation: boolean
}
