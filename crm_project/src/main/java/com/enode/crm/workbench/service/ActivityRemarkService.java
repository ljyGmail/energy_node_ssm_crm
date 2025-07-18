package com.enode.crm.workbench.service;

import com.enode.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * ClassName: ActivityRemarkService
 * Package: com.enode.crm.workbench.service
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 17. 오후 1:46
 * @Version 1.0
 */
public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarksForDetailByActivityId(String activityId);

    int saveCreatedActivityRemark(ActivityRemark activityRemark);
}
