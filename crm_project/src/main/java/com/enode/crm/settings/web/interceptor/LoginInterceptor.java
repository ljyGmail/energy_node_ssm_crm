package com.enode.crm.settings.web.interceptor;

import com.enode.crm.commons.constants.Constants;
import com.enode.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * ClassName: LoginInterceptor
 * Package: com.enode.crm.settings.web.interceptor
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 2. 오후 12:43
 * @Version 1.0
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 登录验证
        // 如果用户没有登录成功，则跳转到登录页面
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath()); // 手动重定向时，URL必须加项目的名称，例如: /crm
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
