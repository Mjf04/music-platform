package musicplatform.service;

import musicplatform.model.dto.PlaylistDTO;
import musicplatform.model.dto.SongDTO;
import musicplatform.model.entity.UserFavorite;
import musicplatform.model.vo.PlaylistVO;
import musicplatform.model.vo.SongVO;
import musicplatform.result.PageResult;
import musicplatform.result.Result;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *

 */
public interface IUserFavoriteService extends IService<UserFavorite> {

    // 获取用户收藏的歌曲列表
    Result<PageResult<SongVO>> getUserFavoriteSongs(SongDTO songDTO);

    // 收藏歌曲
    Result collectSong(Long songId);

    // 取消收藏歌曲
    Result cancelCollectSong(Long songId);

    // 获取用户收藏的歌单列表
    Result<PageResult<PlaylistVO>> getUserFavoritePlaylists(PlaylistDTO playlistDTO);

    // 收藏歌单
    Result collectPlaylist(Long playlistId);

    // 取消收藏歌单
    Result cancelCollectPlaylist(Long playlistId);

}
