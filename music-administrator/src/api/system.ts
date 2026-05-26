import { http } from "@/utils/http";
import { getToken } from "@/utils/auth";
/*管理员后台的全部接口封装
它是整个后台管理系统的 API 集合！
管理员页面上所有增删改查，全都是调用这里的函数*/
/**
 * 通用响应结构
 */
export type Result = {
  code: number;
  message: string;
  data?: Array<any> | number | string | object;
};

/**
 * 分页列表响应结构
 */
export type ResultTable = {
  code: number;
  message: string;
  data?: {
    items: Array<any>;
    total?: number;
    pageSize?: number;
    currentPage?: number;
  };
};

// ==================== 用户管理模块 ====================

/**
 * 获取用户列表（支持分页和筛选）
 * 
 * @param data - 查询参数对象（包含页码、每页数量、搜索条件等）
 * @returns 分页的用户列表数据
 */
export const getUserList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllUsers", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 新增用户
 * 
 * @param data - 用户信息对象
 * @returns 操作结果
 */
export const addUser = (data: object) => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/addUser", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 编辑用户信息
 * 
 * @param data - 包含用户 ID 和待更新字段对象
 * @returns 操作结果
 */
export const updateUser = (data: object) => {
  const userData = getToken();
  return http.request<Result>("put", "/admin/updateUser", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 更新用户状态（启用/禁用）
 * 
 * @param id - 用户 ID
 * @param status - 新状态值
 * @returns 操作结果
 */
export const updateUserStatus = (id: number, status: number) => {
  const userData = getToken();
  return http.request<Result>(
    "patch",
    `/admin/updateUserStatus/${id}/${status}`,
    {
      headers: {
        Authorization: userData.accessToken
      }
    }
  );
};

/**
 * 删除单个用户
 * 
 * @param id - 要删除的用户 ID
 * @returns 操作结果
 */
export const deleteUser = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteUser/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除用户
 * 
 * @param ids - 要删除的用户 ID 数组
 * @returns 操作结果
 */
export const deleteUsers = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteUsers`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};

// ==================== 歌手管理模块 ====================

/**
 * 获取歌手列表（支持分页和筛选）
 * 
 * @param data - 查询参数对象
 * @returns 分页的歌手列表数据
 */
export const getArtistList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllArtists", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 新增歌手
 * 
 * @param data - 歌手信息对象
 * @returns 操作结果
 */
export const addArtist = (data: object) => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/addArtist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 编辑歌手信息
 * 
 * @param data - 包含歌手 ID 和待更新字段对象
 * @returns 操作结果
 */
export const updateArtist = (data: object) => {
  const userData = getToken();
  return http.request<Result>("put", "/admin/updateArtist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 更新歌手头像
 * 
 * @param id - 歌手 ID
 * @param data - 包含头像文件的 FormData 对象
 * @returns 操作结果
 */
export const updateArtistAvatar = (id: number, data: object) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateArtistAvatar/${id}`, {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data,
    responseType: "json"
  });
};

/**
 * 删除单个歌手
 * 
 * @param id - 要删除的歌手 ID
 * @returns 操作结果
 */
export const deleteArtist = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteArtist/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除歌手
 * 
 * @param ids - 要删除的歌手 ID 数组
 * @returns 操作结果
 */
export const deleteArtists = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteArtists`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};

// ==================== 歌曲管理模块 ====================

/**
 * 获取所有歌手名称（用于下拉选择）
 * 
 * @returns 歌手名称列表
 */
export const getAllArtists = () => {
  const userData = getToken();
  return http.request<Result>("get", "/admin/getAllArtistNames", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    }
  });
};

/**
 * 获取歌曲列表（支持按歌手筛选和分页）
 * 
 * @param data - 查询参数对象
 * @returns 分页的歌曲列表数据
 */
export const getSongList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllSongsByArtist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 新增歌曲
 * 
 * @param data - 歌曲信息对象
 * @returns 操作结果
 */
export const addSong = (data: object) => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/addSong", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 编辑歌曲信息
 * 
 * @param data - 包含歌曲 ID 和待更新字段对象
 * @returns 操作结果
 */
export const updateSong = (data: object) => {
  const userData = getToken();
  return http.request<Result>("put", "/admin/updateSong", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 更新歌曲封面
 * 
 * @param id - 歌曲 ID
 * @param data - 包含封面文件的 FormData 对象
 * @returns 操作结果
 */
export const updateSongCover = (id: number, data: object) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateSongCover/${id}`, {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data,
    responseType: "json"
  });
};

/**
 * 更新歌曲音频文件
 * 
 * @param id - 歌曲 ID
 * @param data - 包含音频文件的 FormData 对象
 * @returns 操作结果
 */
export const updateSongAudio = (id: number, data: FormData) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateSongAudio/${id}`, {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data,
    responseType: "json"
  });
};

/**
 * 更新歌曲歌词
 * 
 * @param id - 歌曲 ID
 * @param data - 包含歌词文本的对象
 * @returns 操作结果
 */
export const updateSongLyric = (id: number, data: { lyric: string }) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateSongLyric/${id}`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: data
  });
};

/**
 * 删除单个歌曲
 * 
 * @param id - 要删除的歌曲 ID
 * @returns 操作结果
 */
export const deleteSong = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteSong/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除歌曲
 * 
 * @param ids - 要删除的歌曲 ID 数组
 * @returns 操作结果
 */
export const deleteSongs = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteSongs`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};

// ==================== 歌单管理模块 ====================

/**
 * 获取歌单列表（支持分页和筛选）
 * 
 * @param data - 查询参数对象
 * @returns 分页的歌单列表数据
 */
export const getPlaylistList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllPlaylists", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 新增歌单
 * 
 * @param data - 歌单信息对象
 * @returns 操作结果
 */
export const addPlaylist = (data: object) => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/addPlaylist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 编辑歌单信息
 * 
 * @param data - 包含歌单 ID 和待更新字段对象
 * @returns 操作结果
 */
export const updatePlaylist = (data: object) => {
  const userData = getToken();
  return http.request<Result>("put", "/admin/updatePlaylist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 更新歌单封面
 * 
 * @param id - 歌单 ID
 * @param data - 包含封面文件的 FormData 对象
 * @returns 操作结果
 */
export const updatePlaylistCover = (id: number, data: object) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updatePlaylistCover/${id}`, {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data,
    responseType: "json"
  });
};

/**
 * 添加歌曲到指定歌单
 * 
 * @param playlistId - 目标歌单 ID
 * @param songIds - 要添加的歌曲 ID 数组
 * @returns 操作结果
 */
export const addSongsToPlaylist = (playlistId: number, songIds: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("post", "/playlist-binding/addSongsToPlaylist", {
    params: { playlistId },
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: songIds
  });
};

/**
 * 从指定歌单移除单曲
 * 
 * @param playlistId - 歌单 ID
 * @param songId - 要移除的歌曲 ID
 * @returns 操作结果
 */
export const removeSongFromPlaylist = (playlistId: number, songId: number) => {
  const userData = getToken();
  return http.request<Result>("delete", "/playlist-binding/removeSongFromPlaylist", {
    params: { playlistId, songId },
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 获取指定歌单中的所有歌曲
 * 
 * @param playlistId - 歌单 ID
 * @returns 歌单内的歌曲列表
 */
export const getSongsInPlaylist = (playlistId: number) => {
  const userData = getToken();
  return http.request<Result>("get", "/playlist-binding/getSongsInPlaylist", {
    params: { playlistId },
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 清空指定歌单的所有歌曲
 * 
 * @param playlistId - 歌单 ID
 * @returns 操作结果
 */
export const clearPlaylistSongs = (playlistId: number) => {
  const userData = getToken();
  return http.request<Result>("delete", "/playlist-binding/clearPlaylistSongs", {
    params: { playlistId },
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 获取所有歌手（用于下拉选择，大数据量）
 * 
 * @returns 歌手列表
 */
export const getAllArtistsForSelect = () => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/getAllArtists", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: { pageNum: 1, pageSize: 1000 }
  });
};

/**
 * 获取所有歌曲（用于下拉选择，支持按歌手筛选）
 * 
 * @param artistId - 可选，指定歌手 ID
 * @returns 歌曲列表
 */
export const getAllSongsForSelect = (artistId?: number) => {
  const userData = getToken();
  const requestData: any = { pageNum: 1, pageSize: 1000 };
  if (artistId) {
    requestData.artistId = artistId;
  }
  return http.request<ResultTable>("post", "/admin/getAllSongsByArtist", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: requestData
  });
};

/**
 * 删除单个歌单
 * 
 * @param id - 要删除的歌单 ID
 * @returns 操作结果
 */
export const deletePlaylist = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deletePlaylist/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除歌单
 * 
 * @param ids - 要删除的歌单 ID 数组
 * @returns 操作结果
 */
export const deletePlaylists = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deletePlaylists`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};

// ==================== 反馈管理模块 ====================

/**
 * 获取用户反馈列表（支持分页）
 * 
 * @param data - 查询参数对象
 * @returns 分页的反馈列表数据
 */
export const getFeedbackList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllFeedbacks", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 删除单条反馈
 * 
 * @param id - 要删除的反馈 ID
 * @returns 操作结果
 */
export const deleteFeedback = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteFeedback/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除反馈
 * 
 * @param ids - 要删除的反馈 ID 数组
 * @returns 操作结果
 */
export const deleteFeedbacks = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteFeedbacks`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};

// ==================== 轮播图管理模块 ====================

/**
 * 获取轮播图列表（支持分页）
 * 
 * @param data - 查询参数对象
 * @returns 分页的轮播图列表数据
 */
export const getBannerList = (data: object) => {
  const userData = getToken();
  return http.request<ResultTable>("post", "/admin/getAllBanners", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 新增轮播图
 * 
 * @param data - 包含图片和配置信息的 FormData 对象
 * @returns 操作结果
 */
export const addBanner = (data: object) => {
  const userData = getToken();
  return http.request<Result>("post", "/admin/addBanner", {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 编辑轮播图信息
 * 
 * @param id - 轮播图 ID
 * @param data - 包含更新信息的 FormData 对象
 * @returns 操作结果
 */
export const updateBanner = (id: number, data: object) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateBanner/${id}`, {
    headers: {
      "Content-Type": "multipart/form-data",
      Authorization: userData.accessToken
    },
    data
  });
};

/**
 * 更新轮播图状态（启用/禁用）
 * 
 * @param id - 轮播图 ID
 * @param status - 新状态值
 * @returns 操作结果
 */
export const updateBannerStatus = (id: number, status: number) => {
  const userData = getToken();
  return http.request<Result>("patch", `/admin/updateBannerStatus/${id}`, {
    headers: {
      Authorization: userData.accessToken
    },
    params: { status }
  });
};

/**
 * 删除单个轮播图
 * 
 * @param id - 要删除的轮播图 ID
 * @returns 操作结果
 */
export const deleteBanner = (id: number) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteBanner/${id}`, {
    headers: { Authorization: userData.accessToken }
  });
};

/**
 * 批量删除轮播图
 * 
 * @param ids - 要删除的轮播图 ID 数组
 * @returns 操作结果
 */
export const deleteBanners = (ids: Array<number>) => {
  const userData = getToken();
  return http.request<Result>("delete", `/admin/deleteBanners`, {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    data: ids
  });
};
