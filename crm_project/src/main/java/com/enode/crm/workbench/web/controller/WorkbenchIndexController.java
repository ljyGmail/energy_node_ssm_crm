package com.enode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName: WorkbenchIndexController
 * Package: com.enode.crm.workbench.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 27. 오전 9:37
 * @Version 1.0
 */
@Controller
public class WorkbenchIndexController {

    @RequestMapping("/workbench/index.do")
    public String index() {
        // 跳转到业务主页面
        return "workbench/index";
    }
}
