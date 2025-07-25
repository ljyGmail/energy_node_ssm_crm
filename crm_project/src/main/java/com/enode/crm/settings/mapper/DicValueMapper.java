package com.enode.crm.settings.mapper;

import com.enode.crm.settings.domain.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DicValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    int insert(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    int insertSelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    DicValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    int updateByPrimaryKeySelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Mon Jul 21 23:43:58 KST 2025
     */
    int updateByPrimaryKey(DicValue record);

    /**
     * 根据typeCode查询数据字典的值
     *
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(@Param("typeCode") String typeCode);
}