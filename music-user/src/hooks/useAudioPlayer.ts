import { ref, computed, watch, onMounted, onUnmounted, inject } from 'vue'
import { trackModel } from '@/stores/interface'
import { defaultSong } from '@/mock'
import { ElNotification } from 'element-plus'
import { PlayMode } from './interface'
import { urlV1 } from '@/api'
import { getSongDetail } from '@/api/system'
import { parseLrc, findLyricIndex } from '@/utils/lyric'
import { useAudioStore } from '@/stores/modules/audio'

/**
 * 音频播放器接口定义
 */
interface AudioPlayer {
  isPlaying: Ref<boolean>
  currentTrack: ComputedRef<trackModel>
  currentTime: Ref<number>
  duration: Ref<number>
  volume: Ref<number>
  currentLyricIndex: Ref<number>
  audioElement: Ref<HTMLAudioElement | null>
  play: () => void
  pause: () => void
  nextTrack: () => void
  prevTrack: () => void
  seek: (time: number) => void
  togglePlayPause: () => void
  setVolume: (volume: number) => void
  setPlayMode: (mode: PlayMode) => void
  loadTrack: () => Promise<void>
}

/**
 * 创建音频播放器实例
 * 
 * @description 提供完整的音频播放控制功能，包括播放、暂停、切换歌曲、歌词同步等
 * @returns {AudioPlayer} 音频播放器对象，包含所有播放控制方法和状态
 * 
 * @example
 * // 在 layout/index.vue 中创建并提供给子组件
 * provide('audioPlayer', createAudioPlayer())
 */
export const createAudioPlayer = (): AudioPlayer => {
  const audioStore = useAudioStore()
  const audioElement = ref<HTMLAudioElement | null>(null)
  const isPlaying = ref(false)
  const volume = ref()
  const playMode = ref<PlayMode>('order')

  /**
   * 当前播放的歌曲（计算属性）
   * 从音频 store 的播放列表中获取当前索引对应的歌曲，若无则返回默认歌曲
   */
  const currentTrack = computed<trackModel>(
    () => audioStore.trackList[audioStore.currentSongIndex] || defaultSong
  )
  const currentTime = ref(0)
  const duration = ref(0)

  /**
   * 当前歌词索引，用于追踪正在显示的歌词行
   */
  const currentLyricIndex = ref(0)

  /**
   * 更新当前歌词索引
   * 实时计算当前应该显示哪一行歌词
   * @param newTime - 当前播放时间（秒），默认为 0
   * @description 根据播放时间在歌词数组中查找匹配的歌词行索引
   */
  const updateCurrentLyricIndex = (newTime: number = 0) => {
    if (!currentTrack.value.lyrics?.lines) return

    const newIndex = findLyricIndex(
      currentTrack.value.lyrics.lines,
      newTime * 1000
    )
    if (newIndex !== currentLyricIndex.value) {
      currentLyricIndex.value = newIndex
    }
  }

  /**
   * 监听播放时间变化，自动更新歌词显示索引
   * 根据播放时间，找到对应歌词行
   * 每当 currentTime（播放进度）改变时，自动触发歌词索引更新
   */
  watch(currentTime, (newTime) => {
    updateCurrentLyricIndex(newTime)
  })

  /**
   * 开始播放当前歌曲
   * @description 调用 HTMLAudioElement 的 play 方法并更新播放状态
   */
  const play = () => {
    if (audioElement.value) {
      audioElement.value.play()
      isPlaying.value = true
    }
  }

  /**
   * 跳转到指定时间点
   * 
   * @param time - 目标时间点（秒）
   * @description 设置音频元素的 currentTime 属性实现跳转
   */
  const seek = (time: number) => {
    if (audioElement.value) {
      audioElement.value.currentTime = time
      currentTime.value = time
    }
  }

  /**
   * 暂停当前播放
   * @description 调用 HTMLAudioElement 的 pause 方法并更新播放状态
   */
  const pause = () => {
    if (audioElement.value) {
      audioElement.value.pause()
      isPlaying.value = false
    }
  }

  /**
   * 播放下一首歌曲
   * 
   * @description 根据当前播放模式执行不同的切换逻辑：
   * - order/loop: 顺序切换到下一首，到达末尾后回到第一首
   * - shuffle: 随机选择一首歌曲
   * - single: 重新播放当前歌曲
   * 
   * 切换完成后自动加载并开始播放新歌曲
   */
  const nextTrack = async () => {
    switch (playMode.value) {
      case 'loop':
        if (audioStore.currentSongIndex < audioStore.trackList.length - 1) {
          audioStore.currentSongIndex++
        } else {
          audioStore.currentSongIndex = 0
        }
        break
      case 'shuffle':
        audioStore.currentSongIndex = Math.floor(
          Math.random() * audioStore.trackList.length
        )
        break
      case 'single':
        audioElement.value!.currentTime = 0
        break
      case 'order':
      default:
        if (audioStore.currentSongIndex < audioStore.trackList.length - 1) {
          audioStore.currentSongIndex++
        } else {
          audioStore.currentSongIndex = 0
        }
        break
    }
    await loadTrack()
    play()
  }

  /**
   * 播放上一首歌曲
   * 
   * @description 根据当前播放模式执行不同的切换逻辑：
   * - order/loop: 顺序切换到上一首，到达开头后跳到最后一首
   * - shuffle: 随机选择一首歌曲
   * - single: 重新播放当前歌曲
   * 
   * 切换完成后自动加载并开始播放新歌曲
   */
  const prevTrack = async () => {
    switch (playMode.value) {
      case 'loop':
        if (audioStore.currentSongIndex > 0) {
          audioStore.currentSongIndex--
        } else {
          audioStore.currentSongIndex = audioStore.trackList.length - 1
        }
        break
      case 'shuffle':
        audioStore.currentSongIndex = Math.floor(
          Math.random() * audioStore.trackList.length
        )
        break
      case 'single':
        audioElement.value!.currentTime = 0
        break
      case 'order':
      default:
        if (audioStore.currentSongIndex > 0) {
          audioStore.currentSongIndex--
        } else {
          audioStore.currentSongIndex = audioStore.trackList.length - 1
        }
        break
    }
    await loadTrack()
    play()
  }

  /**
   * 加载当前歌曲到音频元素
   * 
   * @description 执行以下操作：
   * 1. 检查并获取歌曲 URL（如果不存在）
   * 2. 检查并加载歌词（如果没有解析过的歌词）
   * 3. 设置音频元素的 src 并加载
   * 
   * @returns {Promise<void>} 异步加载完成
   */
  const loadTrack = async () => {
    await checkUrl()
    if (
      !currentTrack.value.lyrics?.lines ||
      currentTrack.value.lyrics.lines.length === 0
    ) {
      await checkLyrics()
    }

    if (audioElement.value) {
      audioElement.value.src = currentTrack.value.url
      audioElement.value.load()
    }
  }

  /**
   * 检查并获取歌曲播放 URL
   * 
   * @description 如果当前歌曲没有 URL，则调用 API 获取并更新到 store 中
   * @returns {Promise<void>} 异步检查完成
   */
  const checkUrl = async () => {
    if (!currentTrack.value.url || currentTrack.value.url === '') {
      try {
        const response = await urlV1(currentTrack.value.id)
        const url = response.data[0]?.url

        if (url) {
          const trackIndex = audioStore.trackList.findIndex(
            (track: { id: any }) => track.id === currentTrack.value.id
          )
          if (trackIndex !== -1) {
            audioStore.trackList[trackIndex].url = url
          }
        }
      } catch (error) {
        console.error('获取歌曲 URL 失败:', error)
      }
    }
    return Promise.resolve()
  }

  /**
   * 检查并加载歌曲歌词
   * 
   * @description 按优先级尝试三种方式获取歌词：
   * 1. 如果已有解析好的歌词，直接跳过
   * 2. 如果歌曲对象包含 lyricText 字段，直接解析
   * 3. 否则从后端接口获取歌词文本并解析
   * 
   * 解析成功后会重置歌词索引为 0
   * 
   * @returns {Promise<void>} 异步加载完成
   */
  const checkLyrics = async () => {
    console.log('=== checkLyrics 开始 ===')
    console.log('当前是否有歌词:', currentTrack.value.lyrics?.lines?.length)

    if (
      currentTrack.value.lyrics?.lines &&
      currentTrack.value.lyrics.lines.length > 0
    ) {
      console.log('已有歌词，跳过加载')
      return
    }

    if (currentTrack.value.lyricText) {
      console.log('从 lyricText 解析歌词')
      const parsedLyrics = parseLrc(currentTrack.value.lyricText)
      console.log('解析结果:', parsedLyrics.lines.length, '行')
      currentTrack.value.lyrics = parsedLyrics
      currentLyricIndex.value = 0
      return
    }

    try {
      console.log('从后端接口获取歌词')
      const response = await getSongDetail(parseInt(currentTrack.value.id))
      console.log(
        '接口返回的 lyric:',
        response.data?.lyric ? '有数据' : '无数据'
      )

      if (response.code === 0 && response.data && response.data.lyric) {
        const parsedLyrics = parseLrc(response.data.lyric)
        console.log('解析结果:', parsedLyrics.lines.length, '行')
        currentTrack.value.lyrics = parsedLyrics
        currentLyricIndex.value = 0
      }
    } catch (error) {
      console.error('获取歌词失败:', error)
    }

    console.log('=== checkLyrics 结束 ===')
  }

  /**
   * 更新当前播放时间
   * @description 从音频元素读取 currentTime 并同步到响应式变量
   */
  const updateTime = () => {
    if (audioElement.value) {
      currentTime.value = audioElement.value.currentTime
    }
  }

  /**
   * 音频元数据加载完成回调
   * @description 获取音频总时长并更新到响应式变量
   */
  const onLoadedMetadata = () => {
    if (audioElement.value) {
      duration.value = audioElement.value.duration
    }
  }

  /**
   * 切换播放/暂停状态
   * @description 根据当前播放状态执行相反操作
   */
  const togglePlayPause = () => {
    if (isPlaying.value) {
      pause()
    } else {
      play()
    }
  }

  /**
   * 设置音量
   * 
   * @param newVolume - 新音量值（0-100）
   * @description 同时更新本地状态、store 持久化状态和音频元素的音量
   */
  const setVolume = (newVolume: number) => {
    if (audioElement.value) {
      volume.value = newVolume
      audioStore.setAudioStore('volume', newVolume)
      audioElement.value.volume = newVolume / 100
    }
  }

  /**
   * 设置播放模式
   * 
   * @param mode - 播放模式：'order'(顺序) | 'shuffle'(随机) | 'loop'(列表循环) | 'single'(单曲循环)
   * @description 切换播放模式并显示通知提示用户
   */
  const setPlayMode = (mode: PlayMode) => {
    playMode.value = mode
    const modeText = {
      order: '顺序播放',
      shuffle: '随机播放',
      loop: '列表循环',
      single: '单曲循环',
    }
    ElNotification({
      title: '播放模式',
      message: `已切换为${modeText[mode]}`,
      type: 'success',
    })
  }

  /**
   * 组件挂载时初始化音频播放器
   * 
   * @description 执行以下初始化操作：
   * 1. 创建 HTMLAudioElement 实例
   * 2. 从 store 恢复音量设置
   * 3. 注册事件监听器（时间更新、播放结束、元数据加载）
   */
  onMounted(() => {
    audioElement.value = new Audio(currentTrack.value.url)
    volume.value = audioStore.volume || 50
    audioElement.value.volume = volume.value / 100
    audioElement.value.addEventListener('timeupdate', updateTime)
    audioElement.value.addEventListener('ended', nextTrack)
    audioElement.value.addEventListener('loadedmetadata', onLoadedMetadata)
  })

  /**
   * 组件卸载时清理事件监听器
   * @description 移除所有注册的事件监听器，防止内存泄漏
   */
  onUnmounted(() => {
    if (audioElement.value) {
      audioElement.value.removeEventListener('timeupdate', updateTime)
      audioElement.value.removeEventListener('ended', nextTrack)
      audioElement.value.removeEventListener('loadedmetadata', onLoadedMetadata)
    }
  })

  const audioPlayer: AudioPlayer = {
    isPlaying,
    currentTrack,
    currentTime,
    duration,
    volume,
    currentLyricIndex,
    audioElement,
    play,
    pause,
    nextTrack,
    prevTrack,
    seek,
    togglePlayPause,
    setVolume,
    setPlayMode,
    loadTrack,
  }

  return audioPlayer
}

/**
 * 使用音频播放器 Hook
 * 
 * @description 通过 Vue 的 inject 机制获取父组件提供的音频播放器实例
 * @returns {AudioPlayer} 音频播放器对象
 * @throws {Error} 如果在没有提供 audioPlayer 的上下文中调用则抛出错误
 * 
 * @example
 * // 在子组件中使用
 * const audioPlayer = useAudioPlayer()
 * audioPlayer.play()
 */
export const useAudioPlayer = (): AudioPlayer => {
  const audioPlayer = inject<AudioPlayer>('audioPlayer')
  if (!audioPlayer) {
    throw new Error('useAudioPlayer must be used within a provider')
  }
  return audioPlayer
}
