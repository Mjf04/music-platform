import {
  isArray,
  throttle,
  debounce,
  isObject,
  isFunction
} from "@pureadmin/utils";
import { useEventListener } from "@vueuse/core";
import type { Directive, DirectiveBinding } from "vue";

/*
防止按钮重复点击、防止高频事件卡顿，提升页面性能！是前端性能优化核心技术
防抖（debounce）：连续触发时，只在最后执行一次（防重复点击）
节流（throttle）：固定时间内只执行一次（防高频触发）
*/

/**
 * 性能优化指令配置选项
 */
export interface OptimizeOptions {
  /** 事件名 */
  event: string;
  /** 事件触发的方法 */
  fn: (...params: any) => any;
  /** 是否立即执行 */
  immediate?: boolean;
  /** 防抖或节流的延迟时间（防抖默认：`200`毫秒、节流默认：`1000`毫秒） */
  timeout?: number;
  /** 传递的参数 */
  params?: any;
}

/**
 * 性能优化指令 - 提供防抖和节流功能
 * 
 * 通过 v-optimize 指令优化高频事件的执行频率，避免频繁触发导致的性能问题。
 * 支持防抖（debounce）和节流（throttle）两种模式。
 * 
 * @example
 * 
 * <button v-optimize:debounce="{ event: 'click', fn: handleClick, timeout: 300 }">防抖按钮</button>
 * <button v-optimize:throttle="{ event: 'click', fn: handleClick, timeout: 500 }">节流按钮</button>
 * 
 */
export const optimize: Directive = {
  mounted(el: HTMLElement, binding: DirectiveBinding<OptimizeOptions>) {
    const { value } = binding;
    const optimizeType = binding.arg ?? "debounce";
    const type = ["debounce", "throttle"].find(t => t === optimizeType);
    if (type) {
      if (value && value.event && isFunction(value.fn)) {
        let params = value?.params;
        if (params) {
          if (isArray(params) || isObject(params)) {
            params = isObject(params) ? Array.of(params) : params;
          } else {
            throw new Error(
              "[Directive: optimize]: `params` must be an array or object"
            );
          }
        }
        // Register using addEventListener on mounted, and removeEventListener automatically on unmounted
        useEventListener(
          el,
          value.event,
          type === "debounce"
            ? debounce(
                params ? () => value.fn(...params) : value.fn,
                value?.timeout ?? 200,
                value?.immediate ?? false
              )
            : throttle(
                params ? () => value.fn(...params) : value.fn,
                value?.timeout ?? 1000
              )
        );
      } else {
        throw new Error(
          "[Directive: optimize]: `event` and `fn` are required, and `fn` must be a function"
        );
      }
    } else {
      throw new Error(
        "[Directive: optimize]: only `debounce` and `throttle` are supported"
      );
    }
  }
};
