package musicplatform.model.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class AdminVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long adminId;
    private String username;
    private String email;
    private String phone;
    private String avatar;
}
