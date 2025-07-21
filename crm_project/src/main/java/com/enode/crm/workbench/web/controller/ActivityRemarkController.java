package com.enode.crm.workbench.web.controller;

import com.enode.crm.commons.constants.Constants;
import com.enode.crm.commons.domain.ReturnObject;
import com.enode.crm.commons.utils.DateUtils;
import com.enode.crm.commons.utils.UUIDUtils;
import com.enode.crm.settings.domain.User;
import com.enode.crm.workbench.domain.ActivityRemark;
import com.enode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreatedActivityRemark.do")
    @ResponseBody
    public Object saveCreatedActivityRemark(ActivityRemark activityRemark, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        // 封装参数
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_UNMODIFIED);

        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用Service层方法，保存被创建的市场活动备注
            int ret = activityRemarkService.saveCreatedActivityRemark(activityRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    @ResponseBody
    public Object deleteActivityRemarkById(String id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用Service层方法，删除备注
            int ret = activityRemarkService.deleteActivityRemarkById(id);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditedActivityRemark.do")
    @ResponseBody
    public Object saveEditedActivityRemark(ActivityRemark activityRemark, HttpSession session) {

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        // 封装参数
        activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag(Constants.REMARK_EDIT_FLAG_MODIFIED);

        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用Service层方法，保存修改的市场活动备注
            int ret = activityRemarkService.saveEditedActivityRemark(activityRemark);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
                returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAILURE);
            returnObject.setMessage("시스템이 혼잡하니 잠시 후 다시 시도해 주세요.");
        }
        return returnObject;
    }
}
