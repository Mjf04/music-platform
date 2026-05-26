package musicplatform.constant;

public class PathConstant {
/**
 集中管理那些不需要登录就能访问的接口路径。
 */
    public static final String PLAYLIST_DETAIL_PATH = "/playlist/getPlaylistDetail/**";
    public static final String ARTIST_DETAIL_PATH = "/artist/getArtistDetail/**";
    public static final String SONG_LIST_PATH = "/song/getAllSongs";
    public static final String SONG_DETAIL_PATH = "/song/getSongDetail/**";
    public static final String RECOMMENDED_SONGS_PATH = "/song/getRecommendedSongs";

}
