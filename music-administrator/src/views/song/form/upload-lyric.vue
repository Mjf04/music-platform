<script setup lang="ts">
import { ref, watch } from "vue";
import { updateSongLyric } from "@/api/system";
import { message } from "@/utils/message";

const props = defineProps({
  songId: Number,
  visible: Boolean,
  currentLyric: String
});
const emit = defineEmits(["update:visible", "success"]);

const isVisible = ref(props.visible);
const lyricText = ref("");

watch(
  () => props.visible,
  newVal => {
    isVisible.value = newVal;
    if (newVal && props.currentLyric) {
      lyricText.value = props.currentLyric;
    } else {
      lyricText.value = "";
    }
  }
);

const submitForm = async () => {
  if (!lyricText.value.trim()) {
    message("请输入歌词内容", { type: "warning" });
    return;
  }

  try {
    const res = await updateSongLyric(props.songId, { lyric: lyricText.value });
    if (res.code === 0) {
      message("上传成功", { type: "success" });
      emit("update:visible", false);
      emit("success");
    } else {
      message("歌词更新失败", { type: "error" });
    }
  } catch (error) {
    console.error("更新失败:", error);
    message("更新失败，请重试", { type: "error" });
  }
};
</script>

<template>
  <el-dialog
    v-model="isVisible"
    title="编辑歌词"
    width="60%"
    @close="emit('update:visible', false)"
  >
    <div class="lyric-editor">
      <el-input
        v-model="lyricText"
        type="textarea"
        :rows="15"
        placeholder="请输入 LRC 格式歌词，例如：&#10;[00:00.00] 歌曲名 - 歌手&#10;[00:12.50] 第一句歌词&#10;[00:16.80] 第二句歌词"
        class="lyric-textarea"
      />
      <div class="help-text">
        <el-alert title="歌词格式说明" type="info" :closable="false" show-icon>
          <p>请使用标准 LRC 格式：</p>
          <ul>
            <li><code>[mm:ss.xx]</code> 时间标签 + 歌词文本</li>
            <li>示例：<code>[00:12.50] 这是歌词内容</code></li>
            <li>时间标签必须放在每行开头</li>
          </ul>
        </el-alert>
      </div>
    </div>
    <template #footer>
      <el-button @click="emit('update:visible', false)">取消</el-button>
      <el-button type="primary" @click="submitForm">保存歌词</el-button>
    </template>
  </el-dialog>
</template>

<style scoped lang="scss">
.lyric-editor {
  .lyric-textarea {
    font-family: "Courier New", monospace;
    font-size: 14px;
    line-height: 1.6;
  }

  .help-text {
    margin-top: 12px;

    :deep(.el-alert__content) {
      p {
        margin: 4px 0;
      }

      ul {
        margin: 8px 0;
        padding-left: 20px;

        li {
          margin: 4px 0;

          code {
            background-color: var(--el-fill-color-light);
            padding: 2px 6px;
            border-radius: 4px;
            font-family: "Courier New", monospace;
          }
        }
      }
    }
  }
}
</style>
