<script setup lang="ts">
import { getAllSongs } from '@/api/system'
import { useLibraryStore } from '@/stores/modules/library'

const route = useRoute()
const libraryStore = useLibraryStore()

const props = defineProps({
    selected: {
        type: String,
        default: '1',
    },
})

// 从 store 获取歌曲列表数据
const tableData = computed(() => libraryStore.tableData)
//页码 + 页大小
const currentPage = ref(1)
const pageSize = ref(20)

const state = reactive({
    size: 'default',
    disabled: false,
    background: false,
    layout: 'total, sizes, prev, pager, next, jumper',
    total: 0,
    pageSizes: [20, 30, 50],
})

/**
 * 处理分页大小变化
 *
 * 当用户改变每页显示数量时，重新获取歌曲列表
 */
const handleSizeChange = () => {
    getSongs()
}

/**
 * 处理页码变化
 *
 * 当用户切换页码时，重新获取歌曲列表
 */
const handleCurrentChange = () => {
    getSongs()
}

/**
 * 获取歌曲列表数据
 *
 * 根据当前页码、分页大小和搜索关键词从后端获取歌曲列表，
 * 并将数据存储到全局 store 中供表格组件使用
 */
const getSongs = () => {
    libraryStore.setTableData(null)
    getAllSongs({
      // 当前页码
        pageNum: currentPage.value,
      // 每页数量
        pageSize: pageSize.value,
        songName: route.query.query as string || '',
        artistName: '',
        album: '',
    }).then((res) => {
      // 处理返回结果
        if (res.code === 0 && res.data) {
            libraryStore.setTableData(res.data)
            state.total = res.data.total || 0
        }
    })
}

/**
 * 监听路由查询参数和选中状态变化
 *
 * 当 URL 中的搜索关键词变化或组件被选中时，自动刷新歌曲列表
 */
watch(
    () => [route.query.query, props.selected],
    (val) => {
        if (!val[1] || val[1] != '1') return
        getSongs() // 执行搜索
    },
    {
        immediate: true,  // 立即执行
    }
)
</script>

<template>
    <!-- 主容器：歌曲表格 + 分页控件 -->
    <div class="flex-1 h-full flex flex-col overflow-hidden">
        <!-- 歌曲列表表格 -->
        <Table :data="tableData?.items" class="flex-1 overflow-x-hidden" />

        <!-- 底部分页控件 -->
        <nav class="mx-auto flex w-full justify-center mt-3">
            <el-pagination v-model:page-size="pageSize" v-model:currentPage="currentPage" v-bind="state"
                @size-change="handleSizeChange" @current-change="handleCurrentChange" class="mb-3" />
        </nav>
    </div>
</template>