package com.enode.crm.settings.web.controller;

import com.enode.crm.commons.constants.Constants;
import com.enode.crm.commons.domain.ReturnObject;
import com.enode.crm.commons.utils.DateUtils;
import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * ClassName: UserController
 * Package: com.enode.crm.settings.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 26. 오전 10:52
 * @Version 1.0
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * URL要和Controller方法处理完请求之后，响应信息返回到页面的资源目录保持一致
     *
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        // 请求转发到登录页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        // 调用Service层方法，查询用户
        User user = userService.queryUserByLoginActAndPwd(map);
        // 根据查询结果生成响应信息
        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            // 登录失败: 用户名或密码错误
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("계정/비밀번호가 틀렸습니다");
        } else {
            // 进一步判断账号是否合法
            String nowStr = DateUtils.formateDateTime(new Date());
            if (nowStr.compareTo(user.getExpireTime()) > 0) {
                // 登录失败，账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("계정의 유효기간이 지났습니다");
            } else if ("0".equals(user.getLockState())) {
                // 登录失败，状态被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("해당 계정이 비활성화되었습니다");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                // 登录失败，IP受限
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("해당 IP는 허용되지 않습니다");
            } else {
                // 登录成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                // 把user保存到session中
                session.setAttribute(Constants.SESSION_USER, user);
                // 如果需要记住密码，则往外写cookie
                if ("true".equals(isRemPwd)) {
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    c1.setMaxAge(10 * 24 * 60 * 60);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(10 * 24 * 60 * 60);
                    response.addCookie(c2);
                } else {
                    // 把没有过期的cookie删除
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response, HttpSession session) {

        // 清空cookie
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);

        // 销毁session
        session.invalidate();

        // 跳转到首页
        return "redirect:/"; // 借助SpringMVC来重定向，response.sendRedirect("/crm/");
    }
}
