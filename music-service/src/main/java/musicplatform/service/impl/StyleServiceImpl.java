package musicplatform.service.impl;

import musicplatform.model.entity.Style;
import musicplatform.mapper.StyleMapper;
import musicplatform.service.IStyleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *

 */
@Service
public class StyleServiceImpl extends ServiceImpl<StyleMapper, Style> implements IStyleService {

}
