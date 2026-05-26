<template>
  <!-- 主内容区域容器 -->
  <main class="flex-1 overflow-x-hidden bg-themeBgColor">
    <!-- 路由视图，渲染匹配的页面组件 -->
    <router-view v-slot="{ Component }">
      <!-- 缓存页面组件，避免重复渲染，提升性能 -->
      <keep-alive>
        <component :is="Component" />
      </keep-alive>
    </router-view>
  </main>
</template>
