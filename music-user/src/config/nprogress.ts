import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

/**
 * 配置页面加载进度条的行为
 * 
 * 配置项说明：
 * - easing: 动画缓动函数，控制进度条的运动曲线
 * - speed: 进度条动画的持续时间（毫秒）
 * - showSpinner: 是否显示右上角的旋转加载图标
 * - trickleSpeed: 进度条自动增长的间隔时间（毫秒）
 * - minimum: 进度条启动时的最小百分比（0-1之间）
 */
NProgress.configure({
    easing: 'ease',
    speed: 500,
    showSpinner: true,
    trickleSpeed: 200,
    minimum: 0.3,
})

export default NProgress