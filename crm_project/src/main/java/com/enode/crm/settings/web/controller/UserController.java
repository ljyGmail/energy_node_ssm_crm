package com.enode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
}
