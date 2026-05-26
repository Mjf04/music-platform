package musicplatform.controller;


import musicplatform.result.Result;
import musicplatform.service.IPlaylistBindingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 */
@RestController
@RequestMapping("/playlist-binding")
public class PlaylistBindingController {

    @Autowired
    private IPlaylistBindingService playlistBindingService;

    @PostMapping("/addSongsToPlaylist")
    public Result addSongsToPlaylist(@RequestParam Long playlistId, @RequestBody List<Long> songIds) {
        return playlistBindingService.addSongsToPlaylist(playlistId, songIds);
    }

    @DeleteMapping("/removeSongFromPlaylist")
    public Result removeSongFromPlaylist(@RequestParam Long playlistId, @RequestParam Long songId) {
        return playlistBindingService.removeSongFromPlaylist(playlistId, songId);
    }

    @GetMapping("/getSongsInPlaylist")
    public Result getSongsInPlaylist(@RequestParam Long playlistId) {
        return playlistBindingService.getSongsInPlaylist(playlistId);
    }

    @DeleteMapping("/clearPlaylistSongs")
    public Result clearPlaylistSongs(@RequestParam Long playlistId) {
        return playlistBindingService.clearPlaylistSongs(playlistId);
    }

}
