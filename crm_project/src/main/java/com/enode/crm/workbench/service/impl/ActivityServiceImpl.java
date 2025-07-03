package com.enode.crm.workbench.service.impl;

import com.enode.crm.workbench.domain.Activity;
import com.enode.crm.workbench.mapper.ActivityMapper;
import com.enode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * ClassName: ActivityServiceImpl
 * Package: com.enode.crm.workbench.service.impl
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 3. 오전 10:44
 * @Version 1.0
 */
@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreatedActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }
}
