import { http } from "@/utils/http";
import type { Result } from "@/api/system";
import { getToken } from "@/utils/auth";


/*作用：把后端的统计接口，封装成前端能直接调用的函数*/
/**
 * 获取平台用户总数
 * 
 * @returns 包含用户数量的统计结果
 */
export const getAllUsersCount = () => {
  const userData = getToken();
  return http.request<Result>("get", "/admin/getAllUsersCount", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    }
  });
};

/**
 * 获取歌手总数（支持按性别和地区筛选）
 * 
 * @param gender - 可选，歌手性别筛选条件
 * @param area - 可选，歌手所属地区筛选条件
 * @returns 包含歌手数量的统计结果
 */
export const getAllArtistsCount = (gender?: number, area?: string) => {
  const userData = getToken();
  return http.request<Result>("get", "/admin/getAllArtistsCount", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    params: { gender, area }
  });
};

/**
 * 获取歌曲总数（支持按风格筛选）
 * 
 * @param style - 可选，歌曲风格筛选条件
 * @returns 包含歌曲数量的统计结果
 */
export const getAllSongsCount = (style?: string) => {
  const userData = getToken();
  return http.request<Result>("get", "/admin/getAllSongsCount", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    params: { style }
  });
};

/**
 * 获取歌单总数（支持按风格筛选）
 * 
 * @param style - 可选，歌单风格筛选条件
 * @returns 包含歌单数量的统计结果
 */
export const getAllPlaylistsCount = (style?: string) => {
  const userData = getToken();
  return http.request<Result>("get", "/admin/getAllPlaylistsCount", {
    headers: {
      "Content-Type": "application/json",
      Authorization: userData.accessToken
    },
    params: { style }
  });
};
