package musicplatform.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 角色权限管理器
 */
@Component
public class RolePermissionManager {

    private final RolePathPermissionsConfig rolePathPermissionsConfig;

    @Autowired
    public RolePermissionManager(RolePathPermissionsConfig rolePathPermissionsConfig) {
        this.rolePathPermissionsConfig = rolePathPermissionsConfig;
    }

    // 判断当前角色是否有权限访问请求的路径
    public boolean hasPermission(String role, String requestURI) {
        if (role == null || requestURI == null) {
            return false;
        }

        Map<String, List<String>> permissions = rolePathPermissionsConfig.getPermissions();
        if (permissions != null) {
            List<String> allowedPaths = permissions.get(role);
            if (allowedPaths != null) {
                for (String path : allowedPaths) {
                    if (requestURI.equals(path) || requestURI.startsWith(path + "/") || requestURI.startsWith(path)) {
                        return true;
                    }
                }
            }
        }

        // 配置未加载时的兜底
        if ("ROLE_USER".equals(role) && requestURI.startsWith("/user")) {
            return true;
        }
        if ("ROLE_ADMIN".equals(role) && requestURI.startsWith("/admin")) {
            return true;
        }
        return false;
    }
}

