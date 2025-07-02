package com.enode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName: MainController
 * Package: com.enode.crm.workbench.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 2. 오후 3:43
 * @Version 1.0
 */
@Controller
public class MainController {

    @RequestMapping("/workbench/main/index.do")
    public String index() {
        // 跳转到main/index.jsp
        return "workbench/main/index";
    }
}
