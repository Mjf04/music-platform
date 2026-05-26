/**
 * 导航菜单分类结构接口
 */
interface Category {
    name: string
    isOpen: boolean
    subCategories: { id: string; label: string; value: string | number }[]
}

/**
 * 歌手页面导航筛选数据
 * 
 * 包含“歌手类型”和“地区类型”两个维度的筛选项，
 * 用于动态渲染侧边栏或顶部的过滤菜单
 */
export const categories = ref<Category[]>([
    {
        name: '歌手类型',
        isOpen: true,
        subCategories: [
            { id: '-1', label: '全部', value: null },
            { id: '1', label: '男歌手', value: 0 },
            { id: '2', label: '女歌手', value: 1 },
            { id: '3', label: '组合/乐队', value: 2 },
        ],
    },
    {
        name: '地区类型',
        isOpen: true,
        subCategories: [
            { id: '-1', label: '全部', value: null },
            { id: '1', label: '中国', value: "中国" },
            { id: '2', label: '美国', value: "美国" },
            { id: '3', label: '韩国', value: "韩国" },
            { id: '4', label: '日本', value: "日本" },
            { id: '5', label: '其他', value: null },
        ],
    },
])
