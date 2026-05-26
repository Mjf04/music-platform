<script setup lang="ts">
import { getRecommendedPlaylists, getRecommendedSongs, getBanner } from '@/api/system'
import coverImg from '@/assets/cover.png'
import { formatTime, getImageUrl, replaceUrlParams } from '@/utils'
import { ElNotification } from 'element-plus'
import { UserStore } from '@/stores/modules/user'
import { useAudioStore } from '@/stores/modules/audio'

const router = useRouter()
const audio = useAudioStore()
const user = UserStore()

const { loadTrack, play } = useAudioPlayer()

// 轮播图数据
const bannerList = ref<{ bannerId: number; bannerUrl: string }[]>([])

// 推荐歌单和歌曲数据
const recommendedPlaylist = ref([])
const recommendedSongList = ref([])

/**
 * 监听用户登录状态变化
 *
 * 当用户登录后，自动重新获取个性化推荐数据
 */
watch(
  () => user.isLoggedIn,
  (newVal) => {
    if (newVal) {
      getRecommendedData()
    }
  }
)

/**
 * 获取轮播图数据
 *
 * 从后端获取首页 Banner 图片列表，失败时显示错误提示
 */
const fetchBannerData = async () => {
  try {
    const result = await getBanner()
    if (result.code === 0 && Array.isArray(result.data)) {
      bannerList.value = result.data
    } else {
      ElNotification({
        type: 'error',
        message: '获取轮播图失败',
        duration: 2000,
      })
    }
  } catch (error) {
    console.error('Error fetching banner data:', error)
    ElNotification({
      type: 'error',
      message: '获取轮播图时发生错误',
      duration: 2000,
    })
  }
}

/**
 * 处理轮播图图片加载失败
 *
 * 使用默认占位图替换加载失败的图片
 *
 * @param e - 图片加载错误事件
 */
const onBannerImgError = (e: Event) => {
  const target = e.target as HTMLImageElement
  if (target) target.src = coverImg
}

/**
 * 获取首页推荐数据
 *
 * 包括推荐歌单和推荐歌曲两部分：
 * 1. 获取推荐歌单列表并过滤无效数据
 * 2. 获取推荐歌曲列表
 */
const getRecommendedData = async () => {
  const result = await getRecommendedPlaylists()
  if (result.code === 0 && Array.isArray(result.data)) {
    recommendedPlaylist.value = result.data.map((item) => {
      console.log('推荐歌单数据:', item)
      return {
        playlistId: item.playlistId,
        title: item.title,
        coverUrl: item.coverUrl ?? coverImg,
      }
    }).filter(item => {
      if (!item.playlistId) {
        console.warn('过滤掉没有 playlistId 的数据:', item)
        return false
      }
      return true
    })
  } else {
    ElNotification({
      type: 'error',
      message: '获取推荐歌单失败',
      duration: 2000,
    })
  }

  handleRefreshSongs()
}

onMounted(async () => {
  fetchBannerData()
  getRecommendedData()
})

/**
 * 刷新推荐歌曲列表
 *
 * 从后端获取相似推荐歌曲，转换数据格式后更新到页面
 */
const handleRefreshSongs = async () => {
  const result = await getRecommendedSongs()
  if (result.code === 0 && Array.isArray(result.data)) {
    recommendedSongList.value = result.data.map((item) => ({
      id: item.songId,
      name: item.songName,
      artists: [
        {
          name: item.artistName,
        },
      ],
      album: {
        name: item.album,
        picUrl: item.coverUrl,
      },
      duration: item.duration,
      audioUrl: item.audioUrl,
      likeStatus: item.likeStatus || 0
    }))
  } else {
    ElNotification({
      type: 'error',
      message: '获取推荐歌曲失败',
      duration: 2000,
    })
  }
}

/**
 * 将推荐歌曲数据转换为播放器所需的 trackModel 格式
 *
 * @param song - 原始歌曲数据对象
 * @returns 转换后的播放轨道对象
 */
const convertToTrackModel = (song: any) => {
  return {
    id: song.id.toString(),
    title: song.name,
    artist: song.artists.map((artist: any) => artist.name).join(', '),
    album: song.album.name,
    cover: song.album.picUrl || '',
    url: song.audioUrl,
    duration: song.duration,
    likeStatus: song.likeStatus || 0
  }
}

/**
 * 播放推荐的歌曲
 *
 * 执行流程：
 * 1. 将所有推荐歌曲转换为播放器格式
 * 2. 找到当前点击歌曲的索引
 * 3. 加载到播放列表并从选中歌曲开始播放
 *
 * @param row - 用户点击的歌曲数据对象
 */
const handlePlaylclick = async (row: any) => {
  const allTracks = recommendedSongList.value
    .map(song => convertToTrackModel(song))
    .filter(track => track !== null)

  const selectedIndex = recommendedSongList.value.findIndex(song => song.id === row.id)

  audio.setAudioStore('trackList', allTracks)
  audio.setAudioStore('currentSongIndex', selectedIndex)

  await loadTrack()
  play()
}

/**
 * 判断指定歌曲是否是当前正在播放的歌曲
 *
 * @param songId - 需要判断的歌曲 ID
 * @returns true 表示正在播放，false 表示未播放
 */
const isCurrentPlaying = (songId: number) => {
  const currentTrack = audio.trackList[audio.currentSongIndex]
  return currentTrack && Number(currentTrack.id) === songId
}
</script>

<template>
  <!-- 主容器 -->
  <div class="flex gap-6 p-4 w-full">
    <div class="flex-1">
      <div class="w-full flex flex-col overflow-hidden mb-8">
        <!-- 轮播图区域 -->
        <el-carousel v-if="bannerList.length > 0" :interval="4000" type="card" height="260px">
          <el-carousel-item v-for="item in bannerList" :key="item.bannerId">
            <img :src="getImageUrl(item.bannerUrl)" class="w-full h-full object-cover rounded-lg" alt="banner" @error="onBannerImgError" />
          </el-carousel-item>
        </el-carousel>

        <!-- 无轮播图提示 -->
        <div v-else class="h-[260px] rounded-2xl flex items-center justify-center bg-muted/30 text-muted-foreground">
          暂无轮播图，请在管理后台添加
        </div>

        <!-- 推荐歌单区域 -->
        <button class="mt-6">
          <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-semibold">今日为你推荐</h2>
            <!-- 查看更多按钮 -->
            <button @click="router.push('/playlist')"
              class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 text-primary underline-offset-4 hover:underline h-10 px-4 py-2">
              <icon-hugeicons:more class="text-lg" />
              更多
            </button>
          </div>

          <!-- 歌单卡片网格（最多显示7个） -->
          <div class="grid grid-cols-4 md:grid-cols-7 gap-4">
            <div
              class="rounded-2xl transition duration-300 hover:bg-hoverMenuBg bg-card text-card-foreground border-0 shadow-nonec cursor-pointer"
              v-for="i in recommendedPlaylist.slice(0, 7)" :key="i.playlistId"
              @click="i.playlistId && router.push(`/playlist/${i.playlistId}`)">
              <div class="p-0">
                <!-- 歌单封面 -->
                <div class="aspect-square rounded-t-2xl overflow-hidden">
                  <img :alt="i.title" loading="lazy" width="200" height="200" class="w-full h-full object-cover" :src="replaceUrlParams(getImageUrl(i.coverUrl) || coverImg, 'param=350y350')" />
                </div>

                <!-- 歌单标题 -->
                <div class="flex flex-col p-2">
                  <h3 class="line-clamp-2 font-medium mb-1 playlist-title">
                    {{ i.title }}
                  </h3>
                </div>
              </div>
            </div>
          </div>
        </button>
      </div>

      <!-- 相似推荐歌曲区域 -->
      <div class="w-full">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-semibold mb-4">相似推荐</h2>
          <!-- 刷新按钮 -->
          <button @click="handleRefreshSongs()"
            class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 text-primary underline-offset-4 hover:underline h-10 px-4 py-2">
            <icon-tabler:refresh class="text-lg" />
            刷新
          </button>
        </div>

        <!-- 歌曲列表滚动容器 -->
        <el-scrollbar class="h-full" overflow-auto>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 gap-x-16">
            <!-- 歌曲卡片 -->
            <button v-for="item in recommendedSongList" :key="item.id"
              class="grid grid-cols-[auto_2fr_1fr] items-center gap-4 transition duration-300 rounded-2xl w-full group"
              :class="[
                isCurrentPlaying(item.id) ? 'bg-hoverMenuBg' : 'hover:bg-hoverMenuBg'
              ]" @click.stop="handlePlaylclick(item)">

              <!-- 专辑封面和播放按钮 -->
              <div class="w-16 h-16 rounded-2xl overflow-hidden relative">
                <el-image :alt="item.name" width="64" height="64" class="w-full h-full object-cover"
                  :src="replaceUrlParams((item.album?.picUrl && getImageUrl(item.album.picUrl)) || coverImg, 'param=90y90')" />
                <!-- 悬停显示的播放按钮 -->
                <button @click.stop="handlePlaylclick(item)"
                  class="absolute inset-0 flex items-center justify-center text-white opacity-0 transition-opacity duration-300 z-10 group-hover:opacity-100 group-hover:bg-black/50">
                  <icon-tabler:player-play-filled class="text-lg" />
                </button>
              </div>

              <!-- 歌曲信息（名称和艺术家） -->
              <div class="truncate text-left ml-1">
                <h3 class="font-medium">{{ item.name }}</h3>
                <p class="text-sm text-muted-foreground line-clamp-1">
                  {{item.artists.map((item) => item.name).join(' ')}}
                </p>
              </div>

              <!-- 歌曲时长 -->
              <div class="text-right mr-5">
                <p class="text-sm text-muted-foreground line-clamp-1">
                  {{ formatTime(item.duration) }}
                </p>
              </div>
            </button>
          </div>
        </el-scrollbar>
      </div>
    </div>
  </div>
</template>

<style scoped>
:deep(.el-carousel__item) {
  --el-carousel-item-scale: 1.2;
}

.el-carousel__item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 20px;
}

.playlist-title {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  text-align: left;
  min-height: 2.5em;
  line-height: 1.25;
  overflow: hidden;
  text-overflow: ellipsis;
  display: flex;
  align-items: center;
}
</style>
