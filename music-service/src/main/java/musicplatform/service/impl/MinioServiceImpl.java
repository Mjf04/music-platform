package musicplatform.service.impl;

import musicplatform.constant.MessageConstant;
import musicplatform.service.MinioService;
import io.minio.BucketExistsArgs;
import io.minio.GetObjectArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.RemoveObjectArgs;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;

@Service
public class MinioServiceImpl implements MinioService {

    private final MinioClient minioClient;

    @Value("${minio.bucket}")
    private String bucketName;

    @Value("${minio.endpoint}")
    private String endpoint;

    public MinioServiceImpl(MinioClient minioClient) {
        this.minioClient = minioClient;
    }

    @PostConstruct
    public void init() {
        ensureBucketExists();
    }

    private void ensureBucketExists() {
        try {
            boolean found = minioClient.bucketExists(
                    BucketExistsArgs.builder().bucket(bucketName).build()
            );
            if (!found) {
                minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
                System.out.println("Bucket '" + bucketName + "' 创建成功");
            } else {
                System.out.println("Bucket '" + bucketName + "' 已存在");
            }
        } catch (Exception e) {
            throw new RuntimeException("检查或创建Bucket失败：" + e.getMessage());
        }
    }

    @Override
    public String uploadFile(MultipartFile file, String folder) {
        try {
            String fileName = folder + "/" + UUID.randomUUID() + "-" + file.getOriginalFilename();
            InputStream inputStream = file.getInputStream();
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket(bucketName)
                            .object(fileName)
                            .stream(inputStream, file.getSize(), -1)
                            .contentType(file.getContentType())
                            .build()
            );
            return endpoint + "/" + bucketName + "/" + fileName;
        } catch (Exception e) {
            throw new RuntimeException(MessageConstant.FILE_UPLOAD + MessageConstant.FAILED + "：" + e.getMessage());
        }
    }

    @Override
    public void deleteFile(String fileUrl) {
        try {
            ParsedMinioUrl parsed = parseMinioUrl(fileUrl);
            minioClient.removeObject(
                    RemoveObjectArgs.builder()
                            .bucket(parsed.bucket())
                            .object(parsed.objectKey())
                            .build()
            );
        } catch (Exception e) {
            throw new RuntimeException("文件删除失败：" + e.getMessage());
        }
    }

    @Override
    public InputStream getObjectStream(String fileUrl) throws Exception {
        ParsedMinioUrl parsed = parseMinioUrl(fileUrl);
        return minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(parsed.bucket())
                        .object(parsed.objectKey())
                        .build()
        );
    }

    /**
     * 从 MinIO 完整 URL 解析 bucket 与对象路径（兼容 music-data / vibe-music-data 等历史 bucket）
     */
    ParsedMinioUrl parseMinioUrl(String fileUrl) {
        String normalizedEndpoint = normalizeHost(endpoint).replaceAll("/$", "");
        String normalizedUrl = normalizeHost(fileUrl);

        String prefix = normalizedEndpoint + "/";
        if (!normalizedUrl.startsWith(prefix)) {
            throw new RuntimeException("无效的文件 URL 格式：" + fileUrl);
        }

        String remainder = normalizedUrl.substring(prefix.length());
        int slash = remainder.indexOf('/');
        if (slash <= 0) {
            throw new RuntimeException("无效的文件 URL 格式：" + fileUrl);
        }

        String bucket = remainder.substring(0, slash);
        String objectKey = remainder.substring(slash + 1).replace("\\", "/");
        return new ParsedMinioUrl(bucket, objectKey);
    }

    @Override
    public boolean isMinioUrl(String fileUrl) {
        if (fileUrl == null || fileUrl.isBlank()) {
            return false;
        }
        try {
            parseMinioUrl(fileUrl);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private static String normalizeHost(String url) {
        return url.replace("127.0.0.1", "localhost");
    }

    record ParsedMinioUrl(String bucket, String objectKey) {
    }
}
