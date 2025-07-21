package com.enode.crm.settings.service;

import com.enode.crm.settings.domain.DicValue;

import java.util.List;

/**
 * ClassName: DicValueService
 * Package: com.enode.crm.settings.service
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 21. 오후 11:49
 * @Version 1.0
 */
public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
