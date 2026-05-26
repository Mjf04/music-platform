package musicplatform.controller;

import musicplatform.service.MinioService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 文件代理：将 MinIO 等外部图片通过后端转发，解决前端跨域无法加载的问题
 */
@RestController
@RequestMapping("/file")
public class FileController {

    private static final Map<String, String> CONTENT_TYPES = new ConcurrentHashMap<>(Map.of(
            ".jpg", "image/jpeg",
            ".jpeg", "image/jpeg",
            ".png", "image/png",
            ".gif", "image/gif",
            ".webp", "image/webp",
            ".svg", "image/svg+xml"
    ));

    private final MinioService minioService;

    @Value("${minio.endpoint}")
    private String minioEndpoint;

    public FileController(MinioService minioService) {
        this.minioService = minioService;
    }

    /**
     * 代理 MinIO 图片请求，供前端同源加载，避免跨域
     * 使用方式：/file/proxy?url=编码后的MinIO完整URL
     */
    @GetMapping("/proxy")
    public void proxy(
            @RequestParam("url") String encodedUrl,
            HttpServletResponse response) {
        try {
            String url = URLDecoder.decode(encodedUrl, StandardCharsets.UTF_8);

            if (!minioService.isMinioUrl(url)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid file URL");
                return;
            }

            InputStream input = minioService.getObjectStream(url);
            if (input == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                return;
            }
            
            String contentType = getContentType(url);
            response.setContentType(contentType);
            response.setHeader("Cache-Control", "public, max-age=86400");
            
            try (OutputStream out = response.getOutputStream()) {
                input.transferTo(out);
            } finally {
                input.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load file");
            } catch (Exception ignored) {
            }
        }
    }

    private String getContentType(String url) {
        int i = url.indexOf('?');
        String path = i > 0 ? url.substring(0, i) : url;
        int dot = path.lastIndexOf('.');
        if (dot > 0) {
            String ext = path.substring(dot).toLowerCase();
            return CONTENT_TYPES.getOrDefault(ext, "application/octet-stream");
        }
        return "application/octet-stream";
    }
}
