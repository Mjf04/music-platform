import { hasAuth } from "@/router/utils";
import type { Directive, DirectiveBinding } from "vue";
/*权限控制自定义指令
用户权限
通过 v-auth 一键控制元素显示 / 隐藏，简洁高效！
指令获取你传入的权限值 ['admin']
调用 hasAuth() 判断当前用户是否有权限
没权限 → 直接把元素从 DOM 删掉
必须传权限，否则直接报错（防止误用）*/
export const auth: Directive = {
  mounted(el: HTMLElement, binding: DirectiveBinding<string | Array<string>>) {
    const { value } = binding;
    if (value) {
      !hasAuth(value) && el.parentNode?.removeChild(el);
    } else {
      throw new Error(
        "[Directive: auth]: need auths! Like v-auth=\"['btn.add','btn.edit']\""
      );
    }
  }
};
