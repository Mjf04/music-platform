import { hasPerms } from "@/utils/auth";
import type { Directive, DirectiveBinding } from "vue";

/*按钮级权限控制指令
实现细粒度权限管理，确保用户只能看到自己有权操作的按钮！*/
export const perms: Directive = {
  mounted(el: HTMLElement, binding: DirectiveBinding<string | Array<string>>) {
    const { value } = binding;
    if (value) {
      !hasPerms(value) && el.parentNode?.removeChild(el);
    } else {
      throw new Error(
        "[Directive: perms]: need perms! Like v-perms=\"['btn.add','btn.edit']\""
      );
    }
  }
};
