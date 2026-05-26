package musicplatform.model.entity;

import musicplatform.constant.MessageConstant;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serial;
import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("tb_admin")
public class Admin implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 管理员 id
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long adminId;

    /**
     * 管理员用户名
     * 用户名格式：4-16 位字符（字母、数字、下划线、连字符）
     */
    @NotBlank(message = MessageConstant.USERNAME + MessageConstant.NOT_NULL)
    @Pattern(regexp = "^[a-zA-Z0-9_-]{4,16}$", message = MessageConstant.USERNAME + MessageConstant.FORMAT_ERROR)
    @TableField("username")
    private String username;

    /**
     * 管理员密码
     * 密码格式：8-18 位数字、字母、符号的任意两种组合
     */
    @NotBlank(message = MessageConstant.PASSWORD + MessageConstant.NOT_NULL)
    @Pattern(regexp = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\\W]{8,18}$", message = MessageConstant.PASSWORD + MessageConstant.FORMAT_ERROR)
    @TableField("password")
    private String password;

    /**
     * 管理员邮箱
     * 邮箱格式：符合标准邮箱格式
     */
    @Email(message = MessageConstant.EMAIL + MessageConstant.FORMAT_ERROR)
    @TableField("email")
    private String email;

    /**
     * 管理员手机号
     * 手机号格式：11 位数字，以 1 开头，第二位为 3-9
     */
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = MessageConstant.PHONE + MessageConstant.FORMAT_ERROR)
    @TableField("phone")
    private String phone;

    /**
     * 管理员头像 URL
     */
    @TableField("avatar")
    private String avatar;

}
