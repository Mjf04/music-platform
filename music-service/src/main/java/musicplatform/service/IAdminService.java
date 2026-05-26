package musicplatform.service;

import musicplatform.model.dto.AdminDTO;
import musicplatform.model.dto.AdminUpdateDTO;
import musicplatform.model.dto.UserPasswordDTO;
import musicplatform.model.entity.Admin;
import musicplatform.model.vo.AdminVO;
import musicplatform.result.Result;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 * 服务类
 * </p>

 */
public interface IAdminService extends IService<Admin> {

    // 接口，只声明方法管理员注册
    Result register(AdminDTO adminDTO);

    // 管理员登录
    Result login(AdminDTO adminDTO);

    // 退出登录
    Result logout(String token);

    Result<AdminVO> adminInfo();

    Result updateAdminInfo(AdminUpdateDTO adminUpdateDTO);

    Result updateAdminAvatar(String avatarUrl);

    Result updateAdminPassword(UserPasswordDTO adminPasswordDTO, String token);
}
