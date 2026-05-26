package musicplatform.service;

/**
 * <p>
 * 服务类
 * </p>
 ✅ 处理业务逻辑（验证、计算、事务）
 ✅ 调用 Mapper 操作数据库
 ✅ 管理缓存
 ❌ 不关心 HTTP 协议
 */
public interface EmailService {

    // 发送邮件
    boolean sendEmail(String to, String subject, String content);

    // 发送验证码邮件
    String sendVerificationCodeEmail(String email);
}
