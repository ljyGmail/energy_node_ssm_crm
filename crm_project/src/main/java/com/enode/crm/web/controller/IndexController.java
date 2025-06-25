package com.enode.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName: IndexController
 * Package: com.enode.crm.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 26. 오전 12:01
 * @Version 1.0
 */
@Controller
public class IndexController {

    /*
    理论上，给Controller方法分配URL，应该是http://127.0.0.1:8080/crm/
    为了简便，协议://ip:port/应用名称必须省去，用/代表应用根目录下的/
     */
    @RequestMapping("/")
    public String index() {
        // 请求转发
        return "index";
    }
}
