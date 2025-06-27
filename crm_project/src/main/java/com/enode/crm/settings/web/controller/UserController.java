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

import javax.servlet.http.HttpServletRequest;
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
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request) {
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
            returnObject.setMessage("用户名或者密码错误");
        } else {
            // 进一步判断账号是否合法
            String nowStr = DateUtils.formateDateTime(new Date());
            if (nowStr.compareTo(user.getExpireTime()) > 0) {
                // 登录失败，账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())) {
                // 登录失败，状态被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("状态被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                // 登录失败，IP受限
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("IP受限");
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
        }
        return returnObject;
    }
}
