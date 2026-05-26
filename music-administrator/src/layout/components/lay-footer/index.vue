<script lang="ts" setup>
import { getConfig } from "@/config";

/**
 * 获取系统标题配置，用于页脚版权信息显示
 */
const TITLE = getConfig("Title");
</script>

<template>
  <footer
    class="layout-footer text-[rgba(0,0,0,0.6)] dark:text-[rgba(220,220,242,0.8)]"
  >
    Copyright © 2024-2025
    <a class="hover:text-primary" href="#" target="_blank">
      &emsp;{{ TITLE }}
    </a>
  </footer>
</template>

<style lang="scss" scoped>
.layout-footer {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 0 0 8px;
  font-size: 14px;
}
</style>
