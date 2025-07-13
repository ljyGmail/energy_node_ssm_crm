package com.enode.crm.workbench.web.controller;

import com.enode.crm.commons.constants.Constants;
import com.enode.crm.commons.domain.ReturnObject;
import com.enode.crm.commons.utils.DateUtils;
import com.enode.crm.commons.utils.UUIDUtils;
import com.enode.crm.settings.domain.User;
import com.enode.crm.settings.service.UserService;
import com.enode.crm.workbench.domain.Activity;
import com.enode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
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

    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response, HttpServletRequest request) throws IOException {
        // 1. 设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        // 2. 获取输出流
        OutputStream out = response.getOutputStream();

        // 浏览器接收到响应信息之后，默认情况下，直接在显示窗口中打开响应信息，即使打不开，也会调用应用程序打开。只有实在打不开，才会激活文件下载窗口。
        // 可以设置响应头信息，使浏览器接收到响应信息之后，直接激活文件窗口，即使能打开也不直接打开。
        response.addHeader("Content-Disposition", "attachment;filename=my_student_list.xls");

        // 3. 读取excel文件(InputStream)，把文件输出到浏览器(OutputStream)
        // /Users/liangjinyong/Desktop/Playground/ssm_playground/energy_node_ssm_crm/crm_project/studentList.xls
        InputStream is = new FileInputStream("/Users/liangjinyong/Desktop/Playground/ssm_playground/energy_node_ssm_crm/crm_project/studentList.xls");
        byte[] buff = new byte[256];
        int len = 0;
        while ((len = is.read(buff)) != -1) {
            out.write(buff, 0, len);
        }

        // 4. 关闭资源
        is.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws Exception {
        // 调用Service层方法，查询所有的市场活动
        List<Activity> activityList = activityService.queryAllActivities();
        // 创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Market Activities");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("Owner");
        cell = row.createCell(2);
        cell.setCellValue("Name");
        cell = row.createCell(3);
        cell.setCellValue("Start Date");
        cell = row.createCell(4);
        cell.setCellValue("End Date");
        cell = row.createCell(5);
        cell.setCellValue("Cost");
        cell = row.createCell(6);
        cell.setCellValue("Description");
        cell = row.createCell(7);
        cell.setCellValue("Create Time");
        cell = row.createCell(8);
        cell.setCellValue("Created By");
        cell = row.createCell(9);
        cell.setCellValue("Edit Time");
        cell = row.createCell(10);
        cell.setCellValue("Edited By");

        // 遍历activityList，创建HSSFRow对象，生成所有的数据行
        for (int i = 0; activityList != null && i < activityList.size(); i++) {
            Activity activity = activityList.get(i);

            // 每遍历出一个activity，生成一行
            row = sheet.createRow(i + 1);
            // 每一行创建11列，每一列的数据从activity中获取
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditBy());
        }

        // 根据wb对象生成excel文件
        /*
        OutoputStream os = new FileOutputStream("/Users/liangjinyong/Desktop/activityList.xls");
        wb.write(os);
         */

        // 关闭资源
        // os.close();
        // wb.close();

        // 把生成的excel文件下载到客户段
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=activityList.xls");

        OutputStream out = response.getOutputStream();
        /*
        InputStream is = new FileInputStream("/Users/liangjinyong/Desktop/activityList.xls");

        byte[] buff = new byte[256];
        int len = 0;
        while ((len = is.read(buff)) != -1) {
            out.write(buff, 0, len);
        }

        // 关闭资源
        is.close();
         */

        wb.write(out);

        wb.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportSelectedActivities.do")
    public void exportSelectedActivities(String[] id, HttpServletResponse response) throws Exception {
        // 调用Service层方法，查询用户选择的市场活动
        List<Activity> activityList = activityService.querySelectedActivities(id);
        // 创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("Market Activities");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("Owner");
        cell = row.createCell(2);
        cell.setCellValue("Name");
        cell = row.createCell(3);
        cell.setCellValue("Start Date");
        cell = row.createCell(4);
        cell.setCellValue("End Date");
        cell = row.createCell(5);
        cell.setCellValue("Cost");
        cell = row.createCell(6);
        cell.setCellValue("Description");
        cell = row.createCell(7);
        cell.setCellValue("Create Time");
        cell = row.createCell(8);
        cell.setCellValue("Created By");
        cell = row.createCell(9);
        cell.setCellValue("Edit Time");
        cell = row.createCell(10);
        cell.setCellValue("Edited By");

        // 遍历activityList，创建HSSFRow对象，生成所有的数据行
        for (int i = 0; activityList != null && i < activityList.size(); i++) {
            Activity activity = activityList.get(i);

            // 每遍历出一个activity，生成一行
            row = sheet.createRow(i + 1);
            // 每一行创建11列，每一列的数据从activity中获取
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditBy());
        }

        // 把生成的excel文件下载到客户段
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=selectedActivityList.xls");

        OutputStream out = response.getOutputStream();

        wb.write(out);

        wb.close();
        out.flush();
    }
}
