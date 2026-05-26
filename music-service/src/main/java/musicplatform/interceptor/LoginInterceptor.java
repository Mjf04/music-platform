package musicplatform.interceptor;


import musicplatform.config.RolePermissionManager;
import musicplatform.constant.AuthPathConstant;
import musicplatform.constant.JwtClaimsConstant;
import musicplatform.constant.MessageConstant;
import musicplatform.constant.PathConstant;
import musicplatform.util.JwtUtil;
import musicplatform.util.ThreadLocalUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;
    @Autowired
    private RolePermissionManager rolePermissionManager;

    private static final PathMatcher PATH_MATCHER = new AntPathMatcher();

    public void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(message);
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (request.getMethod().equalsIgnoreCase("OPTIONS")) {
            response.setStatus(HttpServletResponse.SC_OK);
            return true;
        }

        String path = normalizePath(request);

        // 公开接口（含 /file/proxy：img 标签不会带 Token）
        if (isPublicApi(path)) {
            return true;
        }

        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        List<String> allowedPaths = Arrays.asList(
                PathConstant.PLAYLIST_DETAIL_PATH,
                PathConstant.ARTIST_DETAIL_PATH,
                PathConstant.SONG_LIST_PATH,
                PathConstant.SONG_DETAIL_PATH,
                PathConstant.RECOMMENDED_SONGS_PATH
        );

        boolean isAllowedPath = allowedPaths.stream()
                .anyMatch(pattern -> PATH_MATCHER.match(pattern, path));

        if (token == null || token.isEmpty()) {
            if (isAllowedPath) {
                return true;
            }
            sendErrorResponse(response, 401, MessageConstant.NOT_LOGIN);
            return false;
        }

        try {
            ValueOperations<String, String> operations = stringRedisTemplate.opsForValue();
            String redisToken = operations.get(token);
            if (redisToken == null) {
                throw new RuntimeException();
            }

            Map<String, Object> claims = JwtUtil.parseToken(token);
            String role = (String) claims.get(JwtClaimsConstant.ROLE);
            String requestURI = request.getRequestURI();

            if (isAllowedPath) {
                ThreadLocalUtil.set(claims);
                return true;
            }

            if (rolePermissionManager.hasPermission(role, requestURI)) {
                ThreadLocalUtil.set(claims);
                return true;
            }
            sendErrorResponse(response, 403, MessageConstant.NO_PERMISSION);
            return false;
        } catch (Exception e) {
            if (isAllowedPath) {
                return true;
            }
            sendErrorResponse(response, 401, MessageConstant.SESSION_EXPIRED);
            return false;
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        ThreadLocalUtil.remove();
    }

    private String normalizePath(HttpServletRequest request) {
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        if (path.length() > 1 && path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }
        return path.isEmpty() ? "/" : path;
    }

    private boolean isPublicApi(String path) {
        if (AuthPathConstant.PUBLIC_PATHS.stream().anyMatch(pattern -> PATH_MATCHER.match(pattern, path))) {
            return true;
        }
        return path.startsWith("/file/");
    }
}
