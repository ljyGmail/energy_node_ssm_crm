package com.enode.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * ClassName: DateUtils
 * Package: com.enode.crm.commons.utils
 * Description:
 * 对Date类型数据进行处理的工具类
 *
 * @Author: ljy
 * @Create: 2025. 6. 27. 오전 10:09
 * @Version 1.0
 */
public class DateUtils {

    /**
     * 对指定的Date对象进行格式化: yyyy-MM-dd HH:mm:ss
     *
     * @param date
     * @return
     */
    public static String formateDateTime(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String datetimeStr = sdf.format(date);
        return datetimeStr;
    }

    /**
     * 对指定的Date对象进行格式化: yyyy-MM-dd
     *
     * @param date
     * @return
     */
    public static String formateDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdf.format(date);
        return dateStr;
    }

    /**
     * 对指定的Date对象进行格式化: HH:mm:ss
     *
     * @param date
     * @return
     */
    public static String formateTime(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String timeStr = sdf.format(date);
        return timeStr;
    }
}
