package musicplatform.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
//  DTO 定义搜索条件 歌曲查询
@Data
public class SongDTO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 页码
     */
    @NotNull
    private Integer pageNum;

    /**
     * 每页数量
     */
    @NotNull
    private Integer pageSize;

    /**
     * 歌曲名
     */
    private String songName;

    /**
     * 歌手
     */
    private String artistName;

    /**
     * 专辑
     */
    private String album;

}
