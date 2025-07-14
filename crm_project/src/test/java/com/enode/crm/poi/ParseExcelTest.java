package com.enode.crm.poi;

import com.enode.crm.commons.utils.HSSFUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.InputStream;

/**
 * ClassName: ParseExcelTest
 * Package: com.enode.crm.poi
 * Description:
 * 使用apache-poi解析excel文件
 *
 * @Author: ljy
 * @Create: 2025. 7. 14. 오후 3:05
 * @Version 1.0
 */
public class ParseExcelTest {

    @Test
    public void testParseExcel() throws Exception {
        // 根据excel文件生成HSSFWorkbook对象，封装了excel文件到所有信息
        InputStream is = new FileInputStream("/Users/liangjinyong/Desktop/kkk.xls");
        HSSFWorkbook wb = new HSSFWorkbook(is);
        // 根据wb获取HSSFSheet对象，封装了
        HSSFSheet sheet = wb.getSheetAt(0);
        // 根据sheet获取HSSFRow对象，封装了一行的所有信息
        HSSFRow row;
        HSSFCell cell;
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {// sheet.getLastRowNum()最后一行的下标
            row = sheet.getRow(i); // 行的下标，下标从0开始，依次增加
            for (int j = 0; j < row.getLastCellNum(); j++) { // row.getLastCellNum(): 最有一列的下标+1
                // 根据row获取HSSFCell对象，封装了一个单元格的所有信息
                cell = row.getCell(j);

                // 获取单元格中的数据
                System.out.print(HSSFUtils.getCellValueForStr(cell) + " ");
            }

            // 每一行中所有列都打完，打印一个换行
            System.out.println();
        }
    }
}
