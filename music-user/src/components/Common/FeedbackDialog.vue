<script setup lang="ts">
import { ref, reactive } from 'vue'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { addFeedback } from '@/api/system'
//把用户写的反馈内容，发送给后端，存进数据库
/**
 * dialogVisible: 控制对话框的显示/隐藏状态
 * loading: 控制提交按钮的加载状态，防止重复点击
 * formRef: 表单引用，用于手动触发表单验证和重置
 */
const dialogVisible = ref(false)
const loading = ref(false)
const formRef = ref<FormInstance>()

/**
 * 反馈表单数据：只包含反馈内容字段
 */
const formData = reactive({
  content: ''
})

/**
 * 表单验证规则：
 * - 必填：不能为空
 * - 最小长度：至少 10 个字符
 * - 最大长度：不超过 200 个字符
 */
const rules = reactive<FormRules>({
  content: [
    { required: true, message: '请输入反馈内容', trigger: 'blur' },
    { min: 10, message: '反馈内容不能少于 10 个字符', trigger: 'blur' },
    { max: 200, message: '反馈内容不能超过 200 个字符', trigger: 'blur' },
  ]
})

/**
 * 打开反馈对话框
 *
 * 执行流程：
 * 1. 清空上次的反馈内容
 * 2. 重置表单验证状态（清除错误提示）
 * 3. 显示对话框
 */
const openDialog = () => {
  formData.content = ''
  formRef.value?.resetFields()
  dialogVisible.value = true
}

/**
 * 关闭反馈对话框
 */
const closeDialog = () => {
  dialogVisible.value = false
}

/**
 * 提交用户反馈前端逻辑
 *
 * 执行流程：
 * 1. 先验证表单内容是否符合规则（10-200字）
 * 2. 验证通过后，调用后端接口提交反馈
 * 3. 提交成功：显示成功消息，关闭对话框
 * 4. 提交失败：显示错误消息，保持对话框打开让用户修改
 * 5. 无论成功失败，都关闭加载状态
 */
const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await addFeedback({ content: formData.content })
        if (res.code === 0) {
          ElMessage.success('反馈提交成功，感谢您的意见！')
          closeDialog()
        } else {
          ElMessage.error(res.message || '提交失败，请稍后再试')
        }
      } catch (error: any) {
        console.error('Feedback submission error:', error)
        ElMessage.error(error.message || '提交反馈时发生错误')
      } finally {
        loading.value = false
      }
    }
  })
}

/**
 * 将 openDialog 方法暴露给父组件
 * 父组件可以通过 ref 调用此方法打开对话框
 *
 * 使用示例：
 * <FeedbackDialog ref="feedbackRef" />
 * feedbackRef.value.openDialog()
 */
defineExpose({ openDialog })

</script>

<template>
  <!--
    意见反馈对话框：
    - v-model: 双向绑定显示状态
    - close-on-click-modal: 禁止点击遮罩层关闭，防止误操作
    - @close: 关闭时触发清理逻辑
  -->
  <el-dialog v-model="dialogVisible" title="意见反馈" width="500px" :close-on-click-modal="false" @close="closeDialog">
    <!-- 反馈内容表单 -->
    <el-form ref="formRef" :model="formData" :rules="rules" label-width="0px">
      <el-form-item prop="content">
        <!--
          多行文本输入框：
          - rows: 显示 7 行高度
          - maxlength: 限制最多 200 字
          - show-word-limit: 显示字数统计
        -->
        <el-input v-model="formData.content" type="textarea" :rows="7" placeholder="请输入您的宝贵意见或建议（10-200字）"
          maxlength="200" show-word-limit />
      </el-form-item>
    </el-form>

    <!-- 对话框底部按钮区域 -->
    <template #footer>
      <span class="dialog-footer">
        <el-button class="cancel-btn mr-3" @click="closeDialog">取消</el-button>
        <el-button class="submit-btn" type="primary" :loading="loading" @click="handleSubmit">
          提交反馈
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>

<style scoped>
/* 底部按钮区域右对齐 */
.dialog-footer {
  text-align: right;
}

/* 取消按钮样式 */
.cancel-btn {
  width: 15%;
  border-radius: 8px;
  height: 33px;
  font-size: 14px;
}

/* 提交按钮样式 */
.submit-btn {
  width: 20%;
  border-radius: 8px;
  height: 33px;
  font-size: 14px;
}

/* 文本域内部样式：圆角、禁止拖动调整大小 */
:deep(.el-textarea__inner) {
  margin-top: 6px;
  border-radius: 8px;
  resize: none;
}
</style>