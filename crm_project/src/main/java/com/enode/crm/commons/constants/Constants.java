package com.enode.crm.commons.constants;

/**
 * ClassName: Constants
 * Package: com.enode.crm.commons.constants
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 6. 27. 오후 1:38
 * @Version 1.0
 */
public class Constants {
    // 保存ReturnObject类中的Code值
    public static final String RETURN_OBJECT_CODE_SUCCESS = "1"; // 成功
    public static final String RETURN_OBJECT_CODE_FAILURE = "0"; // 失败

    // 保存当前用户的key
    public static final String SESSION_USER = "sessionUser";

    // 备注的修改标记
    public static final String REMARK_EDIT_FLAG_UNMODIFIED = "0"; // 没有修改过
    public static final String REMARK_EDIT_FLAG_MODIFIED = "1"; // 已经被修改过
}
