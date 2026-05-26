package musicplatform.service.impl;

import musicplatform.constant.MessageConstant;
import musicplatform.mapper.PlaylistBindingMapper;
import musicplatform.model.entity.PlaylistBinding;
import musicplatform.model.entity.Song;
import musicplatform.mapper.SongMapper;
import musicplatform.result.Result;
import musicplatform.service.IPlaylistBindingService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 *  服务实现类
 * </p>
 *

 */
@Service
public class PlaylistBindingServiceImpl extends ServiceImpl<PlaylistBindingMapper, PlaylistBinding> implements IPlaylistBindingService {

    @Autowired
    private PlaylistBindingMapper playlistBindingMapper;

    @Autowired
    private SongMapper songMapper;

    @Override
    @CacheEvict(cacheNames = "playlistCache", allEntries = true)
    public Result addSongsToPlaylist(Long playlistId, List<Long> songIds) {
        if (songIds == null || songIds.isEmpty()) {
            return Result.error("歌曲ID列表不能为空");
        }

        for (Long songId : songIds) {
            QueryWrapper<PlaylistBinding> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("playlist_id", playlistId).eq("song_id", songId);
            
            if (playlistBindingMapper.selectCount(queryWrapper) == 0) {
                PlaylistBinding binding = new PlaylistBinding();
                binding.setPlaylistId(playlistId).setSongId(songId);
                playlistBindingMapper.insert(binding);
            }
        }

        return Result.success(MessageConstant.ADD + MessageConstant.SUCCESS);
    }

    @Override
    @CacheEvict(cacheNames = "playlistCache", allEntries = true)
    public Result removeSongFromPlaylist(Long playlistId, Long songId) {
        QueryWrapper<PlaylistBinding> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("playlist_id", playlistId).eq("song_id", songId);
        
        if (playlistBindingMapper.delete(queryWrapper) == 0) {
            return Result.error(MessageConstant.DELETE + MessageConstant.FAILED);
        }
        
        return Result.success(MessageConstant.DELETE + MessageConstant.SUCCESS);
    }

    @Override
    public Result getSongsInPlaylist(Long playlistId) {
        QueryWrapper<PlaylistBinding> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("playlist_id", playlistId);
        
        List<PlaylistBinding> bindings = playlistBindingMapper.selectList(queryWrapper);
        List<Long> songIds = bindings.stream()
                .map(PlaylistBinding::getSongId)
                .collect(Collectors.toList());
        
        if (songIds.isEmpty()) {
            return Result.success(List.of());
        }
        
        List<Song> songs = songMapper.selectBatchIds(songIds);
        
        return Result.success(songs);
    }

    @Override
    @CacheEvict(cacheNames = "playlistCache", allEntries = true)
    public Result clearPlaylistSongs(Long playlistId) {
        QueryWrapper<PlaylistBinding> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("playlist_id", playlistId);
        
        playlistBindingMapper.delete(queryWrapper);
        
        return Result.success(MessageConstant.DELETE + MessageConstant.SUCCESS);
    }

}
