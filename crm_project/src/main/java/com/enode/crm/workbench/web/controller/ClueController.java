package com.enode.crm.workbench.web.controller;

import com.enode.crm.settings.domain.DicValue;
import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.service.DicValueService;
import com.enode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * ClassName: ClueController
 * Package: com.enode.crm.workbench.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 21. 오후 11:51
 * @Version 1.0
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request) {
        // 调用Service层方法，查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        // 把数据保存到request中
        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);
        // 请求转发
        return "workbench/clue/index";
    }
}
