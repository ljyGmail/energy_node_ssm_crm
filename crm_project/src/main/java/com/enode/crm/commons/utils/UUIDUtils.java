package com.enode.crm.commons.utils;

import java.util.UUID;

/**
 * ClassName: UUIDUtils
 * Package: com.enode.crm.commons.utils
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 3. 오전 10:58
 * @Version 1.0
 */
public class UUIDUtils {

    /**
     * 获取UUID
     * @return
     */
    public static String getUUID() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
