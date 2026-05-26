import { ElCol } from "element-plus";
import { h, defineComponent } from "vue";

/**
 * 响应式栅格列组件 - 封装 Element Plus 的 el-col 组件
 * 
 * 简化响应式布局配置，将所有断点（xs/sm/md/lg/xl）统一设置为相同的栅格值，
 * 避免在每个断点上重复配置相同的数值。适用于不需要针对不同屏幕尺寸设置不同列宽的场景。
 * 
 * @example
 * 
 */
export default defineComponent({
  name: "ReCol",
  props: {
      /**
       * 栅格占位格数，所有断点统一使用此值
       * 取值范围：0-24（24 表示占满整行）
       * 默认值为 24，即默认占满一行
       */
    value: {
      type: Number,
      default: 24
    }
  },
  render() {
    const attrs = this.$attrs;
    const val = this.value;
    return h(
      ElCol,
      {
        xs: val,
        sm: val,
        md: val,
        lg: val,
        xl: val,
        ...attrs
      },
      { default: () => this.$slots.default?.() ?? [] }
    );
  }
});
