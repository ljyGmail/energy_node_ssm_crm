package com.enode.crm.uuid;

import org.junit.Test;

import java.util.UUID;

/**
 * ClassName: UUIDTest
 * Package: com.enode.crm.uuid
 * Description:
 *
 * @Author: ljy
 * @Create: 2025. 7. 3. 오전 10:54
 * @Version 1.0
 */
public class UUIDTest {

    @Test
    public void testUUID() {
        System.out.println(UUID.randomUUID().toString().replaceAll("-", ""));
    }
}
