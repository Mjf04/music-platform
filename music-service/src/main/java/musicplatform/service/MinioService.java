package musicplatform.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;

public interface MinioService {
    /**
     * 上传文件到 MinIO
     * @param file   要上传的文件
     * @param folder 存储文件的目录
     * @return 文件访问 URL
     */
    String uploadFile(MultipartFile file, String folder);

    /**
     * 删除 MinIO 文件
     * @param fileUrl 文件 URL
     */
    void deleteFile(String fileUrl);

    /**
     * 根据 MinIO 完整 URL 获取文件流（用于代理转发给前端，解决跨域）
     * @param fileUrl 由 uploadFile 返回的完整 URL，格式为 endpoint/bucketName/objectKey
     * @return 文件输入流，调用方负责关闭
     */
    InputStream getObjectStream(String fileUrl) throws Exception;

    /**
     * 判断是否为当前 MinIO 服务下的资源 URL
     */
    boolean isMinioUrl(String fileUrl);
}
