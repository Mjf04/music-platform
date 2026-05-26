package musicplatform.service;

import musicplatform.model.entity.PlaylistBinding;
import musicplatform.result.Result;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 */
public interface IPlaylistBindingService extends IService<PlaylistBinding> {

    Result addSongsToPlaylist(Long playlistId, List<Long> songIds);

    Result removeSongFromPlaylist(Long playlistId, Long songId);

    Result getSongsInPlaylist(Long playlistId);

    Result clearPlaylistSongs(Long playlistId);

}
