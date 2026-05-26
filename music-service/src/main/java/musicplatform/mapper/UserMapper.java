package musicplatform.mapper;

import musicplatform.model.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface UserMapper extends BaseMapper<User> {

    @Update("ALTER TABLE tb_user AUTO_INCREMENT = 1")
    void resetAutoIncrement();

}
