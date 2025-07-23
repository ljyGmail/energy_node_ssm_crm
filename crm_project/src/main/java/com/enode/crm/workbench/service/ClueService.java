package com.enode.crm.workbench.service;

import com.enode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ClueService
 * Package: com.enode.crm.workbench.service
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 22. 오후 1:58
 * @Version 1.0
 */
public interface ClueService {

    int saveCreatedClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    int queryCountOfClueByCondition(Map<String, Object> map);

    void deleteClue(String[] clueIds);

    Clue queryClueById(String id);

    int saveEditedClue(Clue clue);
}
