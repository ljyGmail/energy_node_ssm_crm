package com.enode.crm.workbench.web.controller;

import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * ClassName: ActivityController
 * Package: com.enode.crm.workbench.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 2. 오후 11:10
 * @Version 1.0
 */
@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        // 调用Service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        // 把数据保存到request中
        request.setAttribute("userList", userList);
        // 请求转发到市场活动的主页面
        return "workbench/activity/index";
    }
}
