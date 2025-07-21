package com.enode.crm.settings.service.impl;

import com.enode.crm.settings.domain.DicValue;
import com.enode.crm.settings.mapper.DicValueMapper;
import com.enode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: DicValueServiceImpl
 * Package: com.enode.crm.settings.service.impl
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 21. 오후 11:50
 * @Version 1.0
 */
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
