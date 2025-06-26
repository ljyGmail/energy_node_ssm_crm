package com.enode.crm.settings.service.impl;

import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.mapper.UserMapper;
import com.enode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * ClassName: UserServiceImpl
 * Package: com.enode.crm.settings.service.impl
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 26. 오후 6:02
 * @Version 1.0
 */
@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }
}
