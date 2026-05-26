package musicplatform.service.impl;

import musicplatform.model.entity.Genre;
import musicplatform.mapper.GenreMapper;
import musicplatform.service.IGenreService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *

 */
@Service
public class GenreServiceImpl extends ServiceImpl<GenreMapper, Genre> implements IGenreService {

}
