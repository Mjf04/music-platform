import { defineStore } from 'pinia'
import piniaPersistConfig from '@/stores/helper/persist'
import { UserState } from '@/stores/interface'
import { login, logout, getUserInfo } from '@/api/system'
import { useAudioStore } from './audio'

/**
 * 用户详细信息接口
 */
interface UserInfo {
  userId?: number
  username?: string
  phone?: string
  email?: string
  avatarUrl?: string
  introduction?: string
  token?: string
}

/**
 * 用户认证与状态管理 Store
 * 
 * 负责处理用户登录、注销、信息更新以及全局登录状态的维护，
 * 支持数据持久化存储
 */
export const UserStore = defineStore('UserStore', {
  state: (): UserState => ({
    userInfo: {} as UserInfo,
    isLoggedIn: false,
  }),
  actions: {
    /**
     * 设置用户详细信息并标记为已登录
     * 
     * @param userInfo - 包含用户基本信息的对象
     * @param token - 可选的身份验证令牌
     */
    setUserInfo(userInfo: any, token?: string) {
      this.userInfo = {
        userId: userInfo.userId,
        username: userInfo.username,
        phone: userInfo.phone,
        email: userInfo.email,
        avatarUrl: userInfo.userAvatar,
        introduction: userInfo.introduction,
        token: token,
      }
      this.isLoggedIn = true
    },

    /**
     * 更新当前用户的头像地址
     * 
     * @param avatarUrl - 新的头像 URL
     */
    updateUserAvatar(avatarUrl: string) {
      if (this.userInfo) {
        this.userInfo.avatarUrl = avatarUrl
      }
    },

    /**
     * 清除用户信息并重置登录状态
     * 
     * 同时会同步清空音频 Store 中所有歌曲的喜欢状态，
     * 确保退出登录后界面显示正确
     */
    clearUserInfo() {
      this.userInfo = {}
      this.isLoggedIn = false

      const audioStore = useAudioStore()
      audioStore.trackList.forEach((track) => {
        track.likeStatus = 0
      })
      
      if (audioStore.currentPageSongs) {
        audioStore.currentPageSongs.forEach((song) => {
          song.likeStatus = 0
        })
      }
    },

    /**
     * 执行用户登录流程
     * 
     * 先调用登录接口获取 Token，再根据 Token 拉取用户详细信息。
     * 
     * @param loginData - 登录凭证对象，包含用户名和密码
     * @returns 包含操作结果（success）和提示信息（message）的对象
     */
    async userLogin(loginData: { username: string; password: string }) {
      try {
        const response = await login(loginData)

        if (response.code === 0) {
          const token = response.data
          this.userInfo = { token }

          try {
            const userInfoResponse = await getUserInfo()
            
            if (userInfoResponse.code === 0) {
              this.setUserInfo(userInfoResponse.data, token)
              return { success: true, message: '登录成功' }
            }
            return { success: false, message: userInfoResponse.message || '获取用户信息失败' }
          } catch (error: any) {
            return { success: false, message: error.message || '获取用户信息失败' }
          }
        }
        return { success: false, message: response.message || '登录失败' }
      } catch (error: any) {
        return { success: false, message: error.message || '登录失败' }
      }
    },

    /**
     * 执行用户退出登录流程
     * 
     * 调用后端注销接口并清除本地存储的用户状态。
     * 
     * @returns 包含操作结果（success）和提示信息（message）的对象
     */
    async userLogout() {
      try {
        const response = await logout()
        this.clearUserInfo()
        if (response.code === 0) {
          return { success: true, message: '退出成功' }
        }
        return { success: true, message: response.message || '已清除本地登录状态' }
      } catch (error: any) {
        this.clearUserInfo()
        return { success: true, message: '已清除本地登录状态' }
      }
    }
  },
  persist: piniaPersistConfig('UserStore'),
})
