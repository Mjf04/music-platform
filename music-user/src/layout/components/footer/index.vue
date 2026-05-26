<script setup lang="ts">
import Left from './components/left.vue'
import Center from './components/center.vue'
import Right from './components/right.vue'
/*这个文件 = 底部播放器的外壳 / 容器
只负责把左、中、右三个组件拼起来，固定在页面底部
没有业务逻辑、不播放音乐、不控制状态！*/
</script>
<template>
  <footer class="border-t flex items-center justify-between shadow-2xl shadow-black">
    <!-- 左边：歌曲封面和歌曲名称 -->
    <Left />
    <!-- 中间：控制区 -->
    <Center />
    <!-- 右边：历史播放和音量 -->
    <Right />
  </footer>
</template>
