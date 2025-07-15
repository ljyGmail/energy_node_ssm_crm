package com.enode.crm.workbench.service.impl;

import com.enode.crm.workbench.domain.Activity;
import com.enode.crm.workbench.mapper.ActivityMapper;
import com.enode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

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

    @Override
    public List<Activity> queryActivityByConditionForPaging(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPaging(map);
    }

    @Override
    public int queryCountOfActivitiesByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivitiesByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditedActivity(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    @Override
    public List<Activity> querySelectedActivities(String[] ids) {
        return activityMapper.selectActivitiesByIds(ids);
    }

    @Override
    public int saveUploadedActivitiesByList(List<Activity> activityList) {
        return activityMapper.insertActivitiesByList(activityList);
    }
}
