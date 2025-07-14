package com.enode.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

/**
 * ClassName: HSSFUtils
 * Package: com.enode.crm.commons.utils
 * Description:
 * 关于excel文件操作的工具类
 *
 * @Author: ljy
 * @Create: 2025. 7. 14. 오후 3:43
 * @Version 1.0
 */
public class HSSFUtils {
    /**
     * 从指定的HSSFCell对象中获取列的值
     *
     * @return
     */
    public static String getCellValueForStr(HSSFCell cell) {
        String ret;
        if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
            ret = cell.getStringCellValue();
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
            ret = cell.getNumericCellValue() + "";
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN) {
            ret = cell.getBooleanCellValue() + "";
        } else if (cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA) {
            ret = cell.getCellFormula() + "";
        } else {
            ret = "";
        }
        return ret;
    }
}
