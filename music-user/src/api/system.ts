import { http } from '@/utils/http'


/** 请求后端接口的函数*/
export type Result = {
  code: number
  message: string
  data?: Array<any> | number | string | object
}

export type ResultTable = {
  code: number
  message: string
  data?: {
    /** 列表数据 */
    items: Array<any>
    /** 总条目数 */
    total?: number
    /** 每页显示条目个数 */
    pageSize?: number
    /** 当前页数 */
    currentPage?: number
  }
}

/** 用户登录 */
export const login = (data: object) => {
  return http<Result>('post', '/user/login', { data })
}

/** 用户登出 */
export const logout = () => {
  return http<Result>('post', '/user/logout')
}

/** 发送邮箱验证码 */
export const sendEmailCode = (email: string) => {
  return http<Result>('get', '/user/sendVerificationCode', {
    params: { email },
  })
}

/** 用户注册 */
export const register = (data: object) => {
  return http<Result>('post', '/user/register', { data })
}

/** 重置密码 */
export const resetPassword = (data: object) => {
  return http<Result>('patch', '/user/resetUserPassword', { data })
}

/** 获取用户信息 */
export const getUserInfo = () => {
  return http<Result>('get', '/user/getUserInfo')
}

/**
 * 更新用户基本信息
 * @param data - 要更新的用户信息（昵称、性别等）
 */
export const updateUserInfo = (data: object) => {
  return http<Result>('put', '/user/updateUserInfo', { data })
}

/**
 * 更新用户头像
 * @param formData - 包含头像文件的表单数据
 */
export const updateUserAvatar = (formData: FormData) => {
  return http<Result>('patch', '/user/updateUserAvatar', {
    data: formData,
    transformRequest: [(data) => data],
  })
}

/**
 * 注销账号（删除当前用户）
 */
export const deleteUser = () => {
  return http<Result>('delete', '/user/deleteAccount')
}

/**
 * 获取首页轮播图列表
 */
export const getBanner = () => {
  return http<Result>('get', '/banner/getBannerList')
}

/**
 * 获取推荐歌单列表
 */
export const getRecommendedPlaylists = () => {
  return http<Result>('get', '/playlist/getRecommendedPlaylists')
}

/**
 * 获取推荐歌曲列表
 */
export const getRecommendedSongs = () => {
  return http<Result>('get', '/song/getRecommendedSongs')
}

/**
 * 获取所有歌曲列表（支持分页和搜索）
 * @param data - 查询参数（页码、每页数量、搜索关键词等）
 */
export const getAllSongs = (data: object) => {
  return http<ResultTable>('post', '/song/getAllSongs', { data })
}

/**
 * 获取指定歌曲的详细信息
 * @param id - 歌曲ID
 */
export const getSongDetail = (id: number) => {
  return http<ResultTable>('get', `/song/getSongDetail/${id}`)
}

/**
 * 获取所有歌手列表（支持分页和搜索）
 * @param data - 查询参数（页码、每页数量、搜索关键词等）
 */
export const getAllArtists = (data: object) => {
  return http<ResultTable>('post', '/artist/getAllArtists', { data })
}

/**
 * 获取指定歌手的详细信息
 * @param id - 歌手ID
 */
export const getArtistDetail = (id: number) => {
  return http<Result>('get', `/artist/getArtistDetail/${id}`)
}

/**
 * 获取所有歌单列表（支持分页和搜索）
 * @param data - 查询参数（页码、每页数量、搜索关键词等）
 */
export const getAllPlaylists = (data: object) => {
  return http<ResultTable>('post', '/playlist/getAllPlaylists', { data })
}

/**
 * 获取指定歌单的详细信息
 * @param id - 歌单ID
 */
export const getPlaylistDetail = (id: number) => {
  return http<Result>('get', `/playlist/getPlaylistDetail/${id}`)
}

/**
 * 获取当前用户收藏的歌曲列表
 * @param data - 查询参数（页码、每页数量等）
 */
export const getFavoriteSongs = (data: object) => {
  return http<Result>('post', '/favorite/getFavoriteSongs', { data })
}

/**
 * 收藏歌曲
 * @param songId - 要收藏的歌曲ID
 */
export const collectSong = (songId: number) => {
  return http<Result>('post', '/favorite/collectSong', { params: { songId } })
}

/**
 * 取消收藏歌曲
 * @param songId - 要取消收藏的歌曲ID
 */
export const cancelCollectSong = (songId: number) => {
  return http<Result>('delete', '/favorite/cancelCollectSong', {
    params: { songId },
  })
}

/**
 * 获取当前用户收藏的歌单列表
 * @param data - 查询参数（页码、每页数量等）
 */
export const getFavoritePlaylists = (data: object) => {
  return http<Result>('post', '/favorite/getFavoritePlaylists', { data })
}

/**
 * 收藏歌单
 * @param playlistId - 要收藏的歌单ID
 */
export const collectPlaylist = (playlistId: number) => {
  return http<Result>('post', '/favorite/collectPlaylist', {
    params: { playlistId },
  })
}

/**
 * 取消收藏歌单
 * @param playlistId - 要取消收藏的歌单ID
 */
export const cancelCollectPlaylist = (playlistId: number) => {
  return http<Result>('delete', '/favorite/cancelCollectPlaylist', {
    params: { playlistId },
  })
}

/**
 * 为歌曲添加评论
 * @param data - 评论内容和歌曲ID
 */
export const addSongComment = (data: object) => {
  return http<Result>('post', '/comment/addSongComment', { data })
}

/**
 * 为歌单添加评论
 * @param data - 评论内容和歌单ID
 */
export const addPlaylistComment = (data: object) => {
  return http<Result>('post', '/comment/addPlaylistComment', { data })
}

/**
 * 点赞评论
 * @param commentId - 要点赞的评论ID
 */
export const likeComment = (commentId: number) => {
  return http<Result>('patch', `/comment/likeComment/${commentId}`)
}

/**
 * 取消点赞评论
 * @param commentId - 要取消点赞的评论ID
 */
export const cancelLikeComment = (commentId: number) => {
  return http<Result>('patch', `/comment/cancelLikeComment/${commentId}`)
}

/**
 * 删除评论
 * @param commentId - 要删除的评论ID
 */
export const deleteComment = (commentId: number) => {
  return http<Result>('delete', `/comment/deleteComment/${commentId}`)
}

/**
 * 提交用户反馈
 * @param data - 反馈内容
 */
export const addFeedback = (data: { content: string }) => {
  return http<Result>('post', '/feedback/addFeedback', { params: data })
}
