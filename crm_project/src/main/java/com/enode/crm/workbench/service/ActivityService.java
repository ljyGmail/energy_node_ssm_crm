package com.enode.crm.workbench.service;

import com.enode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityService
 * Package: com.enode.crm.workbench.service
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 3. 오전 10:42
 * @Version 1.0
 */
public interface ActivityService {

    int saveCreatedActivity(Activity activity);

    List<Activity> queryActivityByConditionForPaging(Map<String, Object> map);

    int queryCountOfActivitiesByCondition(Map<String, Object> map);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int saveEditedActivity(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> querySelectedActivities(String[] ids);
}
