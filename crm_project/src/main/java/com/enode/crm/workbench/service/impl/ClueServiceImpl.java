package com.enode.crm.workbench.service.impl;

import com.enode.crm.workbench.domain.Clue;
import com.enode.crm.workbench.mapper.ClueMapper;
import com.enode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ClueServiceImpl
 * Package: com.enode.crm.workbench.service.impl
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 22. 오후 2:07
 * @Version 1.0
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Override
    public int saveCreatedClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public void deleteClue(String[] clueIds) {
        clueMapper.deleteClueByIds(clueIds);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditedClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }
}
