package com.enode.crm.workbench.service.impl;

import com.enode.crm.workbench.domain.ActivityRemark;
import com.enode.crm.workbench.mapper.ActivityRemarkMapper;
import com.enode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: ActivityRemarkServiceImpl
 * Package: com.enode.crm.workbench.service.impl
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 17. 오후 1:47
 * @Version 1.0
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarksForDetailByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarksForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreatedActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }
}
