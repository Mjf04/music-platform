package musicplatform.model.dto;

import musicplatform.constant.MessageConstant;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class AdminUpdateDTO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @NotBlank(message = MessageConstant.USERNAME + MessageConstant.NOT_NULL)
    @Pattern(regexp = "^[a-zA-Z0-9_-]{4,16}$", message = MessageConstant.USERNAME + MessageConstant.FORMAT_ERROR)
    private String username;

    @Pattern(regexp = "^$|^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", message = MessageConstant.EMAIL + MessageConstant.FORMAT_ERROR)
    private String email;

    @Pattern(regexp = "^$|^1[3-9]\\d{9}$", message = MessageConstant.PHONE + MessageConstant.FORMAT_ERROR)
    private String phone;
}
