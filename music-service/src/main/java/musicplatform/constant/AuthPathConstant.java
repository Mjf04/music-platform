package musicplatform.constant;

import java.util.List;

/**
 * 无需登录即可访问的接口路径
 */
public class AuthPathConstant {

    public static final List<String> PUBLIC_PATHS = List.of(
            "/admin/login",
            "/admin/logout",
            "/admin/register",
            "/user/login",
            "/user/logout",
            "/user/register",
            "/user/sendVerificationCode",
            "/user/resetUserPassword",
            "/banner/getBannerList",
            "/playlist/getAllPlaylists",
            "/playlist/getRecommendedPlaylists",
            "/playlist/getPlaylistDetail/**",
            "/artist/getAllArtists",
            "/artist/getArtistDetail/**",
            "/song/getAllSongs",
            "/song/getRecommendedSongs",
            "/song/getSongDetail/**",
            "/file/**"
    );

    private AuthPathConstant() {
    }
}
