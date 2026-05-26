package musicplatform.service.impl;

import musicplatform.constant.JwtClaimsConstant;
import musicplatform.constant.MessageConstant;
import musicplatform.enumeration.RoleEnum;
import musicplatform.mapper.AdminMapper;
import musicplatform.model.dto.AdminDTO;
import musicplatform.model.dto.AdminUpdateDTO;
import musicplatform.model.dto.UserPasswordDTO;
import musicplatform.model.entity.Admin;
import musicplatform.model.vo.AdminVO;
import musicplatform.result.Result;
import musicplatform.service.IAdminService;
import musicplatform.service.MinioService;
import musicplatform.util.JwtUtil;
import musicplatform.util.ThreadLocalUtil;
import musicplatform.util.TypeConversionUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * <p>
 * 服务实现类
 * </p>
 */
@Service
public class AdminServiceImpl extends ServiceImpl<AdminMapper, Admin> implements IAdminService {

    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;
    @Autowired
    private MinioService minioService;

    /**
     * 管理员注册
     *
     * @param adminDTO 管理员信息
     * @return 结果
     */
    @Override
    public Result register(AdminDTO adminDTO) {
        Admin admin = adminMapper.selectOne(new QueryWrapper<Admin>().eq("username", adminDTO.getUsername()));
        if (admin != null) {
            return Result.error(MessageConstant.USERNAME + MessageConstant.ALREADY_EXISTS);
        }

        String passwordMD5 = DigestUtils.md5DigestAsHex(adminDTO.getPassword().getBytes());
        Admin adminRegister = new Admin();
        adminRegister.setUsername(adminDTO.getUsername()).setPassword(passwordMD5);

        if (adminMapper.insert(adminRegister) == 0) {
            return Result.error(MessageConstant.REGISTER + MessageConstant.FAILED);
        }
        return Result.success(MessageConstant.REGISTER + MessageConstant.SUCCESS);
    }

    /**
     * 管理员登录
     *登录核心逻辑
     * @param adminDTO 管理员信息
     * 作用： 核心业务逻辑 - 查询用户、
     * 验证密码、生成 Token、缓存到 Redis
     */
    @Override
    public Result login(AdminDTO adminDTO) {
        // 1. 根据用户名查询管理员
        Admin admin = adminMapper.selectOne(new QueryWrapper<Admin>().eq("username", adminDTO.getUsername()));
        if (admin == null) {
            return Result.error(MessageConstant.USERNAME + MessageConstant.ERROR);
        }
        // 2. 验证密码（MD5加密后比对）
        if (DigestUtils.md5DigestAsHex(adminDTO.getPassword().getBytes()).equals(admin.getPassword())) {
            // 登录成功
            Map<String, Object> claims = new HashMap<>();
            // 3. 构建 JWT Claims（用户信息）
            claims.put(JwtClaimsConstant.ROLE, RoleEnum.ADMIN.getRole());
            claims.put(JwtClaimsConstant.ADMIN_ID, admin.getAdminId());
            claims.put(JwtClaimsConstant.USERNAME, admin.getUsername());
            // 4. 生成 JWT Token
            String token = JwtUtil.generateToken(claims);

            // 将token存入redis
            stringRedisTemplate.opsForValue().set(token, token, 6, TimeUnit.HOURS);

            // 返回结果
            return Result.success(MessageConstant.LOGIN + MessageConstant.SUCCESS, token);
        }

        return Result.error(MessageConstant.PASSWORD + MessageConstant.ERROR);
    }

    /**
     * 登出
     *
     * @param token 认证token
     * @return 结果
     */
    @Override
    public Result logout(String token) {
        String rawToken = stripBearerPrefix(token);
        if (rawToken != null && !rawToken.isEmpty()) {
            stringRedisTemplate.delete(rawToken);
        }
        return Result.success(MessageConstant.LOGOUT + MessageConstant.SUCCESS);
    }

    @Override
    public Result<AdminVO> adminInfo() {
        Long adminId = currentAdminId();
        Admin admin = adminMapper.selectById(adminId);
        if (admin == null) {
            return Result.error(MessageConstant.USERNAME + MessageConstant.ERROR);
        }
        AdminVO adminVO = new AdminVO();
        BeanUtils.copyProperties(admin, adminVO);
        return Result.success(adminVO);
    }

    @Override
    public Result updateAdminInfo(AdminUpdateDTO adminUpdateDTO) {
        Long adminId = currentAdminId();

        Admin byUsername = adminMapper.selectOne(new QueryWrapper<Admin>().eq("username", adminUpdateDTO.getUsername()));
        if (byUsername != null && !byUsername.getAdminId().equals(adminId)) {
            return Result.error(MessageConstant.USERNAME + MessageConstant.ALREADY_EXISTS);
        }

        if (StringUtils.hasText(adminUpdateDTO.getPhone())) {
            Admin byPhone = adminMapper.selectOne(new QueryWrapper<Admin>().eq("phone", adminUpdateDTO.getPhone()));
            if (byPhone != null && !byPhone.getAdminId().equals(adminId)) {
                return Result.error(MessageConstant.PHONE + MessageConstant.ALREADY_EXISTS);
            }
        }

        if (StringUtils.hasText(adminUpdateDTO.getEmail())) {
            Admin byEmail = adminMapper.selectOne(new QueryWrapper<Admin>().eq("email", adminUpdateDTO.getEmail()));
            if (byEmail != null && !byEmail.getAdminId().equals(adminId)) {
                return Result.error(MessageConstant.EMAIL + MessageConstant.ALREADY_EXISTS);
            }
        }

        String phone = StringUtils.hasText(adminUpdateDTO.getPhone()) ? adminUpdateDTO.getPhone() : null;
        String email = StringUtils.hasText(adminUpdateDTO.getEmail()) ? adminUpdateDTO.getEmail() : null;

        // updateById 默认忽略 null 字段，需用 UpdateWrapper 才能清空邮箱/手机号
        LambdaUpdateWrapper<Admin> updateWrapper = new LambdaUpdateWrapper<Admin>()
                .eq(Admin::getAdminId, adminId)
                .set(Admin::getUsername, adminUpdateDTO.getUsername())
                .set(Admin::getPhone, phone)
                .set(Admin::getEmail, email);

        if (adminMapper.update(null, updateWrapper) == 0) {
            return Result.error(MessageConstant.UPDATE + MessageConstant.FAILED);
        }
        return Result.success(MessageConstant.UPDATE + MessageConstant.SUCCESS);
    }

    @Override
    public Result updateAdminAvatar(String avatarUrl) {
        Long adminId = currentAdminId();
        Admin admin = adminMapper.selectById(adminId);
        String oldAvatar = admin.getAvatar();
        if (oldAvatar != null && !oldAvatar.isEmpty()) {
            try {
                minioService.deleteFile(oldAvatar);
            } catch (Exception ignored) {
            }
        }
        if (adminMapper.updateById(new Admin().setAdminId(adminId).setAvatar(avatarUrl)) == 0) {
            return Result.error(MessageConstant.UPDATE + MessageConstant.FAILED);
        }
        return Result.success(MessageConstant.UPDATE + MessageConstant.SUCCESS, avatarUrl);
    }

    @Override
    public Result updateAdminPassword(UserPasswordDTO adminPasswordDTO, String token) {
        String rawToken = stripBearerPrefix(token);
        Long adminId = currentAdminId();
        Admin admin = adminMapper.selectById(adminId);

        if (!admin.getPassword().equals(DigestUtils.md5DigestAsHex(adminPasswordDTO.getOldPassword().getBytes()))) {
            return Result.error(MessageConstant.OLD_PASSWORD_ERROR);
        }
        if (admin.getPassword().equals(DigestUtils.md5DigestAsHex(adminPasswordDTO.getNewPassword().getBytes()))) {
            return Result.error(MessageConstant.NEW_PASSWORD_ERROR);
        }
        if (!adminPasswordDTO.getRepeatPassword().equals(adminPasswordDTO.getNewPassword())) {
            return Result.error(MessageConstant.PASSWORD_NOT_MATCH);
        }

        Admin update = new Admin();
        update.setAdminId(adminId);
        update.setPassword(DigestUtils.md5DigestAsHex(adminPasswordDTO.getNewPassword().getBytes()));
        if (adminMapper.updateById(update) == 0) {
            return Result.error(MessageConstant.UPDATE + MessageConstant.FAILED);
        }
        if (rawToken != null && !rawToken.isEmpty()) {
            stringRedisTemplate.delete(rawToken);
        }
        return Result.success(MessageConstant.UPDATE + MessageConstant.SUCCESS);
    }

    private Long currentAdminId() {
        Map<String, Object> map = ThreadLocalUtil.get();
        return TypeConversionUtil.toLong(map.get(JwtClaimsConstant.ADMIN_ID));
    }

    private static String stripBearerPrefix(String token) {
        if (token == null) {
            return null;
        }
        return token.startsWith("Bearer ") ? token.substring(7) : token;
    }
}
