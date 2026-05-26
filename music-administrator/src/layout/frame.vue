<script setup lang="ts">
import { useRoute } from "vue-router";
import { ref, unref, watch, onMounted, nextTick } from "vue";

defineOptions({
  name: "LayFrame"
});

const props = defineProps<{
  frameInfo?: {
    frameSrc?: string;
    fullPath?: string;
  };
}>();

const loading = ref(true);
const currentRoute = useRoute();
const frameSrc = ref<string>("");
const frameRef = ref<HTMLElement | null>(null);
if (unref(currentRoute.meta)?.frameSrc) {
  frameSrc.value = unref(currentRoute.meta)?.frameSrc as string;
}
unref(currentRoute.meta)?.frameLoading === false && hideLoading();

/**
 * 隐藏加载状态提示
 */
function hideLoading() {
  loading.value = false;
}

/**
 * 初始化 iframe 加载状态监听
 *
 * 兼容不同浏览器的 onload 事件绑定方式，
 * 当 iframe 内容加载完成后自动隐藏加载动画。
 */
function init() {
  nextTick(() => {
    const iframe = unref(frameRef);
    if (!iframe) return;
    const _frame = iframe as any;
    if (_frame.attachEvent) {
      _frame.attachEvent("onload", () => {
        hideLoading();
      });
    } else {
      iframe.onload = () => {
        hideLoading();
      };
    }
  });
}

/**
 * 监听路由路径变化，处理重定向和框架页面切换
 *
 * 当路由发生重定向时临时清空 frameSrc 避免重复加载，
 * 重定向完成后恢复原始的框架页面地址。
 */
watch(
  () => currentRoute.fullPath,
  path => {
    if (
      currentRoute.name === "Redirect" &&
      path.includes(props.frameInfo?.fullPath)
    ) {
      frameSrc.value = path; // redirect时，置换成任意值，待重定向后 重新赋值
      loading.value = true;
    }
    // 重新赋值
    if (props.frameInfo?.fullPath === path) {
      frameSrc.value = props.frameInfo?.frameSrc;
    }
  }
);

onMounted(() => {
  init();
});
</script>

<template>
  <div v-loading="loading" class="frame" element-loading-text="加载中...">
    <iframe ref="frameRef" :src="frameSrc" class="frame-iframe" />
  </div>
</template>

<style lang="scss" scoped>
.frame {
  position: absolute;
  inset: 0;

  .frame-iframe {
    box-sizing: border-box;
    width: 100%;
    height: 100%;
    overflow: hidden;
    border: 0;
  }
}

.main-content {
  margin: 2px 0 0 !important;
}
</style>
