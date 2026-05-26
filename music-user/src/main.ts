import { createApp } from 'vue'
import App from './App.vue'
import router from './routers/index'
import Store from '@/stores'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import './style/index.scss'

/**
 * 创建并配置 Vue 应用实例
 * 
 * 按顺序注册路由、状态管理（Pinia）、Element Plus UI 库等核心插件，
 * 最后将应用挂载到 #app 容器
 */
const app = createApp(App)

app.use(router)
app.use(Store)
app.use(ElementPlus, {
  locale: zhCn,
})
app.mount('#app')
