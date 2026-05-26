import { defineComponent, Fragment } from "vue";
import { hasAuth } from "@/router/utils";

/**
 * 权限控制组件 - 用于按钮级别的权限验证
 * auth.tsx 是一个全局注册的权限控制组件，用于实现按钮级别的细粒度权限管理。
 * 根据用户拥有的权限码判断是否渲染子内容，实现细粒度的权限控制。
 * 常用于页面中需要根据权限显示/隐藏特定按钮或操作区域的场景。
 * 
 * @example
 * 
 */
export default defineComponent({
  name: "Auth",
  props: {
    value: {
      /**
       * 权限码或权限码数组
       * - 字符串：单个权限码，如 "user:add"
       * - 数组：多个权限码，需要全部拥有才显示
       * - 默认值为空数组，表示无权限限制
       */
      type: undefined,
      default: []
    }
  },
  setup(props, { slots }) {
    return () => {
      if (!slots) return null;
      return hasAuth(props.value) ? (
        <Fragment>{slots.default?.()}</Fragment>
      ) : null;
    };
  }
});
