package com.enode.crm.settings.service;

import com.enode.crm.settings.domain.User;

import java.util.Map;

/**
 * ClassName: UserService
 * Package: com.enode.crm.settings.service
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 26. 오후 6:01
 * @Version 1.0
 */
public interface UserService {

    User queryUserByLoginActAndPwd(Map<String, Object> map);
}
