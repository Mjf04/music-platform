package musicplatform.service.impl;

import musicplatform.constant.MessageConstant;
import musicplatform.service.EmailService;
import musicplatform.util.RandomCodeUtil;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 服务实现类
 * </p>

 */
@Slf4j
@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSenderImpl mailSender;

    @Value("${spring.mail.username}")
    private String from;

    /**
     * 发送邮件
     *Spring Mail 实际发
     * @param to      收件人地址
     * @param subject 邮件主题
     * @param content 邮件内容
     * @return 发送结果，包含是否成功
     */
    public boolean sendEmail(String to, String subject, String content) {
        // 1. 创建 MIME 邮件对象
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            // 2. 创建邮件助手（简化操作
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
            // 3. 设置发件人（从配置文件读取）
            helper.setFrom(from);
            // 4. 设置收件人
            helper.setTo(to);
            // 5. 设置主题
            helper.setSubject(subject);
            // 6. 设置内容
            helper.setText(content);
            // 7. 真正发送邮件（通过 SMTP 协议）
            mailSender.send(mimeMessage);
            return true; // 发送成功
        } catch (MessagingException e) {
            log.error(MessageConstant.EMAIL_SEND_FAILED, e);
            return false; // 发送失败
        }
    }

    /**
     * 发送验证码邮件
     *EmailService 构建邮件内容
     * @param email 收件人地址
     * @return 发送结果，包含是否成功和验证码
     */
    public String sendVerificationCodeEmail(String email) {
        // 1. 生成6位随机验证码（字母+数字）
        String verificationCode = RandomCodeUtil.generateRandomCode();
        // 2. 设置邮件主题
        String subject = "【音乐流媒体平台】验证码";
        // 3. 设置邮件内容
        String content = "您的验证码为：" + verificationCode;
        // 4. 调用底层发送邮件方法
        boolean success = sendEmail(email, subject, content);
        // 5. 发送成功返回验证码，失败返回null
        if (success) {
            return verificationCode;
        } else {
            return null;
        }
    }
}
