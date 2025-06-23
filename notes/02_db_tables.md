# CRM物理模型设计

## 1. CRM的表结构

    - tbl_user 用户表

    - tbl_dic_type 数据字典类型表
    - tbl_dic_value 数据字典值

    - tbl_activity 市场活动表
    - tbl_activity_remark 市场活动备注表

    - tbl_clue 线索表
    - tbl_clue_remark 线索备注表

    - tbl_clue_activity_relation 线索和市场活动的关联关系表

    - tbl_customer 客户表
    - tbl_customer_remark 客户备注表

    - tbl_contacts 联系人表
    - tbl_contacts_remark 联系人备注表

    - tbl_tran 交易表
    - tbl_tran_remark 交易备注表
    - tbl_tran_history 交易历史表

    - tbl_task 任务表

    1) 主键字段: 在数据库表中，如果有一组字段能够唯一确定一条记录，则可以把它们设计成表的主键字段。
            推荐使用一个字段做主键，而且推荐使用没有业务含义的字段做主键,比如: id等。

            主键字段的类型和长度由主键值的生成方式来决定:
                主键值的生成方式:
                    1)自增: 借助数据库自身主键生成机制
                        数值型 长度由数据量来决定

                        运行效率低
                        开发效率高
                    2)assigned: 程序员手动生成主键值，唯一非空，算法。
                        hi/low: 数值型 长度由数据量决定
                        UUID: 字符串 长度是32位
                    3)共享主键: 由另一张表的类型和长度来决定
                        tbl_person      tbl_card
                        id    name        id    name
                        1001  zs          1001  card1
                        1002  ls          1002  card2
                    4)联合主键: 由多个字段的类型和长度来决定

    2) 外键字段: 用来确定表和表之间的关系。
        1) 一对多: 一张表(A)中的一条记录可以对应另一张表(B)中的多条记录;
                另一张表(B)中的一条记录只能对应一张表(A)的一条记录。
                A(1) ---------- B(N)
                父表             子表
                tbl_class         tbl_student
                id      name      id     name  class_id
                111     class1    1001   zs    111
                222     class2    1002   ls    111
                                  1003   ww    222
                                  1004   zl    222

                添加数据时，先添加父表记录，再添加子表记录；
                删除数据时，先删除子表记录，再删除父表记录；
                查询数据时，可能会进行关联查询。
                // 查询所有姓张的学生的id，name和所在班级的name
                select s.id, s.name, c.name as className
                from tbl_student s
                joib tbl_class c on s.class_id = c.id // 假如外键不可以为空
                where s.name like 'z%'

                内连接: 查询所有符合条件的数据，并且要求结果在两张表中都有相对应的的记录；
                左外连接: 查询左侧表中所有符合条件的数据，即使在右侧表中没有相对应的记录。

                * 如果外键不能为空，优先使用内连接；
                  如果外键可以为空，
                            -- 假如只需要查询那些在另一张表中有相对应的记录，使用内连接；
                            -- 假如需要查询左侧表中所有符合条件的记录，使用左外连接。
            
        2) 一对一: 一张表(A)中的一条记录只能对应另一张表(B)中的一条记录;
                另一张表(B)中的一条记录也只能对应一张表(A)的一条记录。
                        tbl_person      tbl_card
                        id    name        id    name
                        1001  zs          1001  card1
                        1002  ls          1002  card2
                        a) 共享主键: (不推荐)
                            添加数据: 先添加先产生的表，再后产生的表记录；
                            删除数据: 先删除后产生的表，再删除先产生的表记录；
                            数据: 无需进行连接查询
                                    // 查询zhangsan的驾照信息 1001
                                    select *
                                    from tbl_card
                                    where id = '1001'
                        b) 唯一外键:
                        tbl_person      tbl_card
                        id    name      id    name     person_id(唯一性约束)
                        1001  zs        111  card1     1001
                        1002  ls        222  card2     1002
                        1003  ww        333  card2     1003
                        * 一对一就是一种特殊的一对多。
                        * 操作跟一对多完全一样。

        3) 多对多: 一张表(A)中的一条记录只能对应另一张表(B)中的多条记录;
                另一张表(B)中的一条记录也可以对应一张表(A)的多条记录。
                tbl_student                 tbl_course
                id      name                id       name
                1001    zs                  111      java
                1002    ls                  222      mysql

                        tbl_student_course_relation
                        student_id    course_id
                        1001          111
                        1001          222
                        1002          111
                        1002          222
                添加数据时，先添加父表记录(tbl_student, tbl_course)，再添加子表(tbl_student_course_relation)记录；
                删除数据时，先删除子表记录(tbl_student_course_relation)，再删除父表(tbl_student, tbl_course)记录；
                查询数据时，可能会进行关联查询:
                            // 查询所有姓张的学生的id,name和所选课程的name
                            select s.id, s.name, c.name as courseName
                            from tbl_student s
                            join tbl_student_course_relation scr on s.id = scr.student_id
                            join tbl_course c on scr.course_id = c.id
                            where s.name like 'z%';

    3) 关于日期和时间的字段:
        都按照字符串来处理:
        char(10) yyyy-MM-dd
        char(19) yyyy-MM-dd HH:mm:ss

## 2. CRM的建表脚本

```mysql
SHOW DATABASES;
CREATE DATABASE crm2025;
USE crm2025;
SHOW TABLES;

-- 用户
DROP TABLE IF EXISTS tbl_user;
CREATE TABLE tbl_user
(
    id          CHAR(32) NOT NULL COMMENT 'UUID',
    login_act   VARCHAR(255) DEFAULT NULL,
    name        VARCHAR(255) DEFAULT NULL,
    login_pwd   VARCHAR(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密',
    email       VARCHAR(255) DEFAULT NULL,
    expire_time CHAR(19)     DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效',
    lock_state  CHAR(1)      DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定',
    deptno      CHAR(4)      DEFAULT NULL,
    allow_ips   VARCHAR(255) DEFAULT NULL,
    create_time CHAR(19)     DEFAULT NULL,
    create_by   VARCHAR(255) DEFAULT NULL,
    edit_time   CHAR(19)     DEFAULT NULL,
    edit_by     VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id)
);


INSERT INTO tbl_user VALUE ('aaaaaaaaaabbbbbbbbbbccccccccccdd', 'ls', '李四', 'yf123', 'ls@163.com',
                            '2018-11-27 21:50:05', '1', 'A001', '192.168.1.1',
                            '2018-11-22 12:11:40', '李四', '', '');
INSERT INTO tbl_user VALUE ('ddddddddddeeeeeeeeeeffffffffffgg', 'zs', '张三', 'yf123', 'zs@qq.com',
                            '2018-11-30 23:50:05', '1', 'A001', '192.168.1.1',
                            '2018-11-22 11:37:34', '张三', '', '');

-- 数据字典
DROP TABLE IF EXISTS tbl_dic_type;
DROP TABLE IF EXISTS tbl_dic_value;

CREATE TABLE tbl_dic_type
(
    code        VARCHAR(255) NOT NULL,
    name        VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (code)
);

CREATE TABLE tbl_dic_value
(
    id        CHAR(32) NOT NULL,
    value     VARCHAR(255),
    text      VARCHAR(255),
    order_no  VARCHAR(255),
    type_code VARCHAR(255),
    PRIMARY KEY (id)
);

-- 业务相关
DROP TABLE IF EXISTS tbl_activity;
DROP TABLE IF EXISTS tbl_activity_remark;
DROP TABLE IF EXISTS tbl_clue;
DROP TABLE IF EXISTS tbl_clue_remark;
DROP TABLE IF EXISTS tbl_clue_activity_relation;
DROP TABLE IF EXISTS tbl_contacts;
DROP TABLE IF EXISTS tbl_contacts_remark;
DROP TABLE IF EXISTS tbl_contacts_activity_relation;
DROP TABLE IF EXISTS tbl_customer;
DROP TABLE IF EXISTS tbl_customer_remark;
DROP TABLE IF EXISTS tbl_tran;
DROP TABLE IF EXISTS tbl_tran_history;
DROP TABLE IF EXISTS tbl_tran_remark;

-- 市场活动
CREATE TABLE tbl_activity
(
    id          CHAR(32) NOT NULL,
    owner       CHAR(32),
    name        VARCHAR(255),
    start_date  CHAR(10),
    end_date    CHAR(10),
    cost        VARCHAR(255),
    description VARCHAR(255),
    create_time CHAR(19),
    create_by   VARCHAR(255),
    edit_time   CHAR(19),
    edit_by     VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE tbl_activity_remark
(
    id           CHAR(32) NOT NULL,
    note_content VARCHAR(255),
    create_time  CHAR(19),
    create_by    VARCHAR(255),
    edit_time    CHAR(19),
    edit_by      VARCHAR(255),
    edit_flag    CHAR(1) COMMENT '0表示未修改，1表示已修改',
    activity_id  CHAR(32),
    PRIMARY KEY (id)
);

-- 线索
CREATE TABLE tbl_clue
(
    id                CHAR(32) NOT NULL,
    fullname          VARCHAR(255),
    appellation       VARCHAR(255),
    owner             CHAR(32),
    company           VARCHAR(255),
    job               VARCHAR(255),
    email             VARCHAR(255),
    phone             VARCHAR(255),
    website           VARCHAR(255),
    mphone            VARCHAR(255),
    state             VARCHAR(255),
    source            VARCHAR(255),
    create_time       CHAR(19),
    create_by         VARCHAR(255),
    edit_time         CHAR(19),
    edit_by           VARCHAR(255),
    description       VARCHAR(255),
    contact_summary   VARCHAR(255),
    next_contact_time CHAR(10),
    address           VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE tbl_clue_remark
(
    id           CHAR(32) NOT NULL,
    note_content VARCHAR(255),
    create_time  CHAR(19),
    create_by    VARCHAR(255),
    edit_time    CHAR(19),
    edit_by      VARCHAR(255),
    edit_flag    CHAR(1) COMMENT '0表示未修改，1表示已修改',
    clue_id      CHAR(32),
    PRIMARY KEY (id)
);

-- 市场活动/线索 关联表
CREATE TABLE tbl_clue_activity_relation
(
    id          CHAR(32) NOT NULL,
    clue_id     CHAR(32),
    activity_id CHAR(32),
    PRIMARY KEY (id)
);

-- 联系人
CREATE TABLE tbl_contacts
(
    id                CHAR(32) NOT NULL,
    owner             CHAR(32),
    source            VARCHAR(255),
    customer_id       CHAR(32),
    fullname          VARCHAR(255),
    appellation       VARCHAR(255),
    email             VARCHAR(255),
    mphone            VARCHAR(255),
    job               VARCHAR(255),
    create_time       CHAR(19),
    create_by         VARCHAR(255),
    edit_time         CHAR(19),
    edit_by           VARCHAR(255),
    description       VARCHAR(255),
    contact_summary   VARCHAR(255),
    next_contact_time CHAR(10),
    address           VARCHAR(255),
    state             VARCHAR(255),
    PRIMARY KEY (id)
);
CREATE TABLE tbl_contacts_remark
(
    id           CHAR(32) NOT NULL,
    note_content VARCHAR(255),
    create_time  CHAR(19),
    create_by    VARCHAR(255),
    edit_time    CHAR(19),
    edit_by      VARCHAR(255),
    edit_flag    CHAR(1) COMMENT '0表示未修改，1表示已修改',
    contacts_id  CHAR(32),
    PRIMARY KEY (id)
);

-- 联系人/市场活动 关联表
CREATE TABLE tbl_contacts_activity_relation
(
    id          CHAR(32) NOT NULL,
    contacts_id CHAR(32),
    activity_id CHAR(32),
    PRIMARY KEY (id)
);

-- 客户
CREATE TABLE tbl_customer
(
    id                CHAR(32) NOT NULL,
    owner             CHAR(32),
    website           VARCHAR(255),
    phone             VARCHAR(255),
    create_time       CHAR(19),
    create_by         VARCHAR(255),
    edit_time         CHAR(19),
    edit_by           VARCHAR(255),
    contact_summary   VARCHAR(255),
    next_contact_time CHAR(10),
    description       VARCHAR(255),
    address           VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE tbl_customer_remark
(
    id           CHAR(32) NOT NULL,
    note_content VARCHAR(255),
    create_time  CHAR(19),
    create_by    VARCHAR(255),
    edit_time    CHAR(19),
    edit_by      VARCHAR(255),
    edit_flag    CHAR(1) COMMENT '0表示未修改，1表示已修改',
    customer_id  CHAR(32),
    PRIMARY KEY (id)
);

-- 交易
CREATE TABLE tbl_tran
(
    id                CHAR(32) NOT NULL,
    owner             CHAR(32),
    money             VARCHAR(255),
    name              VARCHAR(255),
    expected_date     CHAR(10),
    customer_id       CHAR(32),
    stage             VARCHAR(255),
    type              VARCHAR(255),
    source            VARCHAR(255),
    activity_id       CHAR(32),
    contacts_id       CHAR(32),
    create_time       CHAR(19),
    create_by         VARCHAR(255),
    edit_time         CHAR(19),
    edit_by           VARCHAR(255),
    description       VARCHAR(255),
    contact_summary   VARCHAR(255),
    next_contact_time CHAR(10),
    PRIMARY KEY (id)
);

CREATE TABLE tbl_tran_history
(
    id          CHAR(32) NOT NULL,
    stage       VARCHAR(255),
    money       VARCHAR(255),
    create_time CHAR(19),
    create_by   VARCHAR(255),
    tran_id     CHAR(32),
    PRIMARY KEY (id)
);

CREATE TABLE tbl_tran_remark
(
    id           CHAR(32) NOT NULL,
    note_content VARCHAR(255),
    create_time  CHAR(19),
    create_by    VARCHAR(255),
    edit_time    CHAR(19),
    edit_by      VARCHAR(255),
    edit_flag    CHAR(1) COMMENT '0表示未修改，1表示已修改',
    tran_id      CHAR(32),
    PRIMARY KEY (id)
);
```


