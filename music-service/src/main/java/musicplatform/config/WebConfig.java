package musicplatform.config;

import musicplatform.constant.AuthPathConstant;
import musicplatform.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns(
                        "/admin/**",
                        "/user/**",
                        "/playlist/**",
                        "/artist/**",
                        "/song/**",
                        "/favorite/**",
                        "/comment/**",
                        "/feedback/**",
                        "/playlist-binding/**",
                        "/banner/**",
                        "/file/**"
                )
                .excludePathPatterns(AuthPathConstant.PUBLIC_PATHS.toArray(new String[0]));
    }
}
