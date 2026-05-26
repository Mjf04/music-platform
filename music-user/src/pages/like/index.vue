<script setup lang="ts">
import { getFavoriteSongs } from '@/api/system'
import type { Song } from '@/api/interface'
import coverImg from '@/assets/like_bg.jpg'
import { getImageUrl, replaceUrlParams } from '@/utils'
import { useAudioStore } from '@/stores/modules/audio'
import { UserStore } from '@/stores/modules/user'
import { useRoute } from 'vue-router'

const route = useRoute()
const userStore = UserStore()
const audui = useAudioStore()
const { loadTrack, play } = useAudioPlayer()

const songs = ref<Song[]>([])
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(10)

// 歌单基本信息
const playlist = ref({
    name: '我喜欢的音乐',
    coverImgUrl: coverImg,
    trackCount: 0,
    tags: []
})

interface PageResult {
    items: Song[]
    total: number
}

/**
 * 获取用户收藏的歌曲列表
 *
 * 根据分页参数和搜索关键词从后端获取收藏歌曲，
 * 更新歌单封面为第一首歌的封面（若有）
 */
const getSongs = async () => {
    if (!userStore.isLoggedIn || !userStore.userInfo?.token) {
        songs.value = []
        playlist.value.trackCount = 0
        return
    }

    try {
        const res = await getFavoriteSongs({
            pageNum: currentPage.value,
            pageSize: pageSize.value,
            songName: searchKeyword.value,
            artistName: '',
            album: ''
        })
        if (res.code === 0 && res.data) {
            const pageData = res.data as PageResult
            songs.value = pageData.items
            playlist.value.trackCount = pageData.total

            if (pageData.items.length > 0) {
                playlist.value.coverImgUrl = pageData.items[0].coverUrl || coverImg
            }
        }
    } catch {
        // 401 等由 http 拦截器统一处理
    }
}

/**
 * 处理搜索操作
 *
 * 重置到第一页并重新获取搜索结果
 */
const handleSearch = () => {
    currentPage.value = 1
    getSongs()
}

/**
 * 播放所有收藏歌曲
 *
 * 将当前页面的收藏歌曲转换为播放器格式，
 * 加载到播放列表并从第一首开始播放
 */
const handlePlayAll = async () => {
    audui.setAudioStore('trackList', [])

    if (!songs.value.length) return

    const result = songs.value.map(song => ({
        id: song.songId.toString(),
        title: song.songName,
        artist: song.artistName,
        album: song.album,
        cover: song.coverUrl || coverImg,
        url: song.audioUrl,
        duration: parseFloat(song.duration) * 1000,
        likeStatus: song.likeStatus
    }))

    audui.setAudioStore('trackList', result)
    audui.setAudioStore('currentSongIndex', 0)
    await loadTrack()
    play()
}

/**
 * 监听播放列表中歌曲收藏状态的变化
 *
 * 当检测到有歌曲的喜欢状态变为 0（取消收藏）时，
 * 自动刷新页面以移除已取消收藏的歌曲
 */
watch(() => audui.currentPageSongs, (newSongs) => {
    if (newSongs && newSongs.length > 0) {
        const hasUnlikedSong = newSongs.some((song) => song.likeStatus === 0)
        if (hasUnlikedSong) {
            getSongs()
        }
    }
}, { deep: true })

/**
 * 监听路由变化
 *
 * 每次进入"/like"页面时重新获取收藏列表，确保数据最新
 */
watch(() => route.path, (newPath) => {
    if (newPath === '/like') {
        getSongs()
    }
})

/** 登录成功后若停留在「喜欢」页（keep-alive），补拉收藏列表 */
watch(
    () => userStore.isLoggedIn,
    loggedIn => {
        if (loggedIn && route.path === '/like') {
            getSongs()
        }
    }
)

onMounted(() => {
    getSongs()
})

onActivated(() => {
    if (route.path === '/like') {
        getSongs()
    }
})
</script>

<template>
  <!-- 主容器 -->
  <div class="flex flex-col h-full bg-background flex-1 md:overflow-hidden">
    <!-- 顶部歌单信息区域 -->
    <div class="flex flex-col md:flex-row p-6 gap-6">
      <!-- 歌单封面 -->
      <div class="flex-shrink-0 w-60 h-60">
        <img :alt="playlist.name" class="w-full h-full object-cover rounded-lg shadow-lg"
          :src="replaceUrlParams(getImageUrl(playlist.coverImgUrl) || coverImg, 'param=500y500')" />
      </div>

      <!-- 歌单文字信息和操作按钮 -->
      <div class="flex flex-col justify-between flex-1">
        <!-- 歌单标题、歌曲数量、标签 -->
        <div>
          <h1 class="text-3xl font-bold mb-2">{{ playlist.name }}</h1>
          <div class="flex items-center gap-2 text-sm text-muted-foreground mb-4 ml-1">
            <span>{{ playlist.trackCount }} 首歌曲</span>
          </div>
          <div class="flex items-center gap-2 text-sm text-muted-foreground" v-if="playlist.tags">
            <el-tag v-for="tag in playlist.tags" class="text-sm" effect="dark" :key="tag">{{ tag }}
            </el-tag>
          </div>
        </div>

        <!-- 播放全部按钮和搜索框 -->
        <div class="flex items-center justify-between mt-4">
          <button @click="handlePlayAll"
            class="text-white inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 rounded-lg px-8">
            <icon-solar:play-line-duotone />
            播放全部
          </button>

          <!-- 搜索框 -->
          <div class="relative">
            <icon-akar-icons:search
              class="lucide lucide-search absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground" />
            <input v-model="searchKeyword" @keyup.enter="handleSearch"
              class="flex h-10 rounded-lg border border-input transform duration-300 bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-0 pl-10 w-56"
              placeholder="搜索" />
          </div>
        </div>
      </div>
    </div>

    <!-- 歌曲列表表格 -->
    <Table :data="songs" class="flex-1 md:overflow-x-hidden" />

    <!-- 底部分页控件 -->
    <nav class="mx-auto flex w-full justify-center mt-3">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="playlist.trackCount"
        :page-sizes="[10, 20, 30, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="getSongs"
        @current-change="getSongs"
        class="mb-3"
      />
    </nav>
  </div>
</template>