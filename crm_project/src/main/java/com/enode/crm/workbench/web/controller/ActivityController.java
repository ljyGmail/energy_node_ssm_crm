package com.enode.crm.workbench.web.controller;

import com.enode.crm.commons.constants.Constants;
import com.enode.crm.commons.domain.ReturnObject;
import com.enode.crm.commons.utils.DateUtils;
import com.enode.crm.commons.utils.UUIDUtils;
import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.service.UserService;
import com.enode.crm.workbench.domain.Activity;
import com.enode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityController
 * Package: com.enode.crm.workbench.web.controller
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 2. 오후 11:10
 * @Version 1.0
 */
@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        // 调用Service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        // 把数据保存到request中
        request.setAttribute("userList", userList);
        // 请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreatedActivity.do")
    @ResponseBody
    public ReturnObject saveCreatedActivity(Activity activity, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        // 封装参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用Service层方法，保存创建的市场活动
            int ret = activityService.saveCreatedActivity(activity);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPaging")
    @ResponseBody
    public Object queryActivityByConditionForPaging(String name, String owner, String startDate, String endDate, int pageNo, int pageSize) {

        // 封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        // 调用Service层方法，查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPaging(map);
        int totalRows = activityService.queryCountOfActivitiesByCondition(map);

        // 根据查询结果，生成响应信息
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("activityList", activityList);
        resultMap.put("totalRows", totalRows);
        return resultMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用Service层方法，删除市场活动
            int ret = activityService.deleteActivityByIds(id);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id) {
        // 调用Service层方法，查询市场活动
        Activity activity = activityService.queryActivityById(id);
        // 根据查询结果，返回响应信息
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditedActivity.do")
    @ResponseBody
    public Object saveEditedActivity(Activity activity, HttpSession session) {
        // 获取当前登录的用户
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        // 封装参数
        activity.setEditTime(DateUtils.formateDateTime(new Date()));
        activity.setEditBy(user.getId());

        ReturnObject returnObject = new ReturnObject();

        try {
            // 调用Service层方法，保存修改的市场活动
            int ret = activityService.saveEditedActivity(activity);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("系统忙，请稍后再试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("系统忙，请稍后再试...");
        }
        return returnObject;
    }
}
