<script setup lang="ts">
import { getArtistDetail } from '@/api/system'
import Table from '@/components/Table.vue'
import { getImageUrl } from '@/utils'
import { useArtistStore } from '@/stores/modules/artist'
import { ElMessage } from 'element-plus'
import { useRoute } from 'vue-router'

interface ArtistDetailResponse {
    artistId: number
    artistName: string
    avatar: string
    birth: string
    area: string
    introduction: string
    songs: any[]
}

const route = useRoute()
const artistStore = useArtistStore()

/** 当前是否在歌手详情路由（避免 keep-alive 下误响应歌单等同 id 路由） */
const isArtistDetailRoute = () => /^\/artist\/[^/]+$/.test(route.path)

// 从 store 获取歌手信息
const artistInfo = computed(() => artistStore.artistInfo)

/**
 * 获取歌手详细信息
 *
 * 执行流程：
 * 1. 从路由参数中获取歌手 ID 并验证有效性
 * 2. 清空之前的歌手数据
 * 3. 调用 API 获取歌手详情（基本信息 + 歌曲列表）
 * 4. 将数据存储到全局 store 中
 * 5. 处理错误情况并显示提示
 */
const fetchArtistDetail = async (idParam?: string | string[]) => {
    if (!isArtistDetailRoute()) {
        return
    }

    const id = idParam ?? route.params.id

    // 返回列表等场景下 id 会变为空，属正常路由切换，无需报错
    if (!id) {
        return
    }

    const numericId = parseInt(id.toString())

    if (isNaN(numericId)) {
        console.error('无效的歌手 ID:', id)
        ElMessage.error('无效的歌手 ID')
        return
    }

    try {
        artistStore.setArtistInfo(null)
        const res = await getArtistDetail(numericId)

        if (res.code === 0 && res.data) {
            const artistData = res.data as ArtistDetailResponse
            // 将数据存储到全局 store 中
            artistStore.setArtistInfo({
                artistId: artistData.artistId,
                artistName: artistData.artistName || '未知歌手',
                avatar: artistData.avatar || '',
                birth: artistData.birth || '',
                area: artistData.area || '未知',
                introduction: artistData.introduction || '暂无简介',
                songs: artistData.songs || []
            })
        } else {
            ElMessage.error(res.message || '获取歌手信息失败')
        }
    } catch (error) {
        console.error('获取歌手详情失败:', error)
        ElMessage.error('获取歌手信息失败，请稍后重试')
    }
}

/**
 * 监听路由参数变化，自动重新获取歌手信息
 *
 * 当用户从不同歌手详情页跳转时，确保数据同步更新
 */
watch(
    () => [route.path, route.params.id] as const,
    ([path, id]) => {
        if (!/^\/artist\/[^/]+$/.test(path) || !id) return
        fetchArtistDetail(id)
    },
    { immediate: true }
)

/**
 * 格式化生日日期
 *
 * @param birth - 原始生日字符串
 * @returns 格式化后的日期字符串（本地格式），若为空则返回空字符串
 */
const formatBirth = (birth: string) => {
    if (!birth) return ''
    return new Date(birth).toLocaleDateString()
}
</script>

<template>
    <!-- 页面主容器 -->
    <div class="container mx-auto py-10 px-5 h-full flex-1 flex flex-col">
        <!-- 歌手基本信息卡片 -->
        <div class="flex flex-col lg:flex-row items-center gap-8">
            <!-- 歌手头像 -->
            <div class="w-48 h-48 rounded-full overflow-hidden bg-gray-200">
                <img :src="getImageUrl(artistInfo?.avatar)" :alt="artistInfo?.artistName" class="w-full h-full object-cover" />
            </div>

            <!-- 歌手文字信息 -->
            <div class="text-center lg:text-left flex-1">
                <!-- 歌手姓名 -->
                <h1 class="text-3xl font-semibold text-foreground">
                    {{ artistInfo?.artistName }}
                </h1>

                <!-- 详细信息（生日、地区、简介） -->
                <div class="mt-4 space-y-2 text-sm text-muted-foreground">
                    <p v-if="artistInfo?.birth">生日：{{ formatBirth(artistInfo.birth) }}</p>
                    <p v-if="artistInfo?.area">地区：{{ artistInfo.area }}</p>
                    <p v-if="artistInfo?.introduction" class="mt-2 line-clamp-4">简介：{{ artistInfo.introduction }}
                    </p>
                </div>
            </div>
        </div>

        <!-- 歌曲列表区域 -->
        <div class="mt-12 flex flex-col flex-1">
            <h2 class="text-2xl font-semibold text-foreground mb-6">所有歌曲</h2>
            <div class="w-full h-full flex">
                <Table :data="artistInfo?.songs" />
            </div>
        </div>
    </div>
</template>
