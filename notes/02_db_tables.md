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

```Bash
# 创建Docker容器
docker run -d -p 3310:3306 --privileged=true -v ~/Desktop/mysql_volume/log:/var/log/mysql -v ~/Desktop/mysql_volume/data:/var/lib/mysql -v ~/Desktop/mysql_volume/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456 --name mysql mysql:8.0
```

```mysql
SHOW DATABASES;
CREATE DATABASE crm;
USE crm;
SHOW TABLES;

-- ----------------------------
-- Table structure for `tbl_user`
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user`
(
    `id`          char(32) NOT NULL COMMENT 'uuid\r\n            ',
    `login_act`   varchar(255) DEFAULT NULL,
    `name`        varchar(255) DEFAULT NULL,
    `login_pwd`   varchar(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据',
    `email`       varchar(255) DEFAULT NULL,
    `expire_time` char(19)     DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
    `lock_state`  char(1)      DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
    `deptno`      char(4)      DEFAULT NULL,
    `allow_ips`   varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
    `createTime`  char(19)     DEFAULT NULL,
    `create_by`   varchar(255) DEFAULT NULL,
    `edit_time`   char(19)     DEFAULT NULL,
    `edit_by`     varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user`
VALUES ('06f5fc056eac41558a964f96daa7f27c', 'admin', '홍길동', '1234', 'ls@163.com', '2028-11-27 21:50:05', '1', 'A001',
        '127.0.0.1', '2028-11-22 12:11:40', '홍길동', null, null);
INSERT INTO `tbl_user`
VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'sbb', '슈바빙', 'yf123', 'zs@qq.com', '2028-11-30 23:50:55', '1', 'A001',
        '192.168.1.1,192.168.1.2,127.0.0.1,0:0:0:0:0:0:0:1', '2028-11-22 11:37:34', '슈바빙', null, null);

drop table if exists tbl_dic_type;

drop table if exists tbl_dic_value;

/*==============================================================*/
/* Table: tbl_dic_type                                          */
/*==============================================================*/
create table tbl_dic_type
(
    code        varchar(255) not null,
    name        varchar(255),
    description varchar(255),
    primary key (code)
);

/*==============================================================*/
/* Table: tbl_dic_value                                         */
/*==============================================================*/
create table tbl_dic_value
(
    id        char(32) not null,
    value     varchar(255),
    text      varchar(255),
    order_no  varchar(255),
    type_code varchar(255),
    primary key (id)
);

drop table if exists tbl_activity;

drop table if exists tbl_activity_remark;

/*==============================================================*/
/* Table: tbl_activity                                          */
/*==============================================================*/
create table tbl_activity
(
    id          char(32) not null,
    owner       char(32),
    name        varchar(255),
    start_date  char(10),
    end_date    char(10),
    cost        varchar(255),
    description varchar(255),
    create_time char(19),
    create_by   varchar(255),
    edit_time   char(19),
    edit_by     varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_activity_remark                                   */
/*==============================================================*/
create table tbl_activity_remark
(
    id           char(32) not null,
    note_content varchar(255),
    create_time  char(19),
    create_by    varchar(255),
    edit_time    char(19),
    edit_by      varchar(255),
    edit_flag    char(1),
    activity_id  char(32),
    primary key (id)
);

drop table if exists tbl_clue;

drop table if exists tbl_clue_activity_relation;

drop table if exists tbl_clue_remark;

drop table if exists tbl_contacts;

drop table if exists tbl_contacts_activity_relation;

drop table if exists tbl_contacts_remark;

drop table if exists tbl_customer;

drop table if exists tbl_customer_remark;

drop table if exists tbl_tran;

drop table if exists tbl_tran_history;

drop table if exists tbl_tran_remark;

/*==============================================================*/
/* Table: tbl_clue                                              */
/*==============================================================*/
create table tbl_clue
(
    id                char(32) not null,
    fullname          varchar(255),
    appellation       varchar(255),
    owner             char(32),
    company           varchar(255),
    job               varchar(255),
    email             varchar(255),
    phone             varchar(255),
    website           varchar(255),
    mphone            varchar(255),
    state             varchar(255),
    source            varchar(255),
    create_by         varchar(255),
    create_time       char(19),
    edit_by           varchar(255),
    edit_time         char(19),
    description       varchar(255),
    contact_summary   varchar(255),
    next_contact_time char(10),
    address           varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_clue_activity_relation                            */
/*==============================================================*/
create table tbl_clue_activity_relation
(
    id          char(32) not null,
    clue_id     char(32),
    activity_id char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_clue_remark                                       */
/*==============================================================*/
create table tbl_clue_remark
(
    id           char(32) not null,
    note_content varchar(255),
    create_by    varchar(255),
    create_time  char(19),
    edit_by      varchar(255),
    edit_time    char(19),
    edit_flag    char(1),
    clue_id      char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts                                          */
/*==============================================================*/
create table tbl_contacts
(
    id                char(32) not null,
    owner             char(32),
    source            varchar(255),
    customer_id       char(32),
    fullname          varchar(255),
    appellation       varchar(255),
    email             varchar(255),
    mphone            varchar(255),
    job               varchar(255),
    create_by         varchar(255),
    create_time       char(19),
    edit_by           varchar(255),
    edit_time         char(19),
    description       varchar(255),
    contact_summary   varchar(255),
    next_contact_time char(10),
    address           varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts_activity_relation                        */
/*==============================================================*/
create table tbl_contacts_activity_relation
(
    id          char(32) not null,
    contacts_id char(32),
    activity_id char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts_remark                                   */
/*==============================================================*/
create table tbl_contacts_remark
(
    id           char(32) not null,
    note_content varchar(255),
    create_by    varchar(255),
    create_time  char(19),
    edit_by      varchar(255),
    edit_time    char(19),
    edit_flag    char(1),
    contacts_id  char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_customer                                          */
/*==============================================================*/
create table tbl_customer
(
    id                char(32) not null,
    owner             char(32),
    name              varchar(255),
    website           varchar(255),
    phone             varchar(255),
    create_by         varchar(255),
    create_time       char(19),
    edit_by           varchar(255),
    edit_time         char(19),
    contact_summary   varchar(255),
    next_contact_time char(10),
    description       varchar(255),
    address           varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_customer_remark                                   */
/*==============================================================*/
create table tbl_customer_remark
(
    id           char(32) not null,
    note_content varchar(255),
    create_by    varchar(255),
    create_time  char(19),
    edit_by      varchar(255),
    edit_time    char(19),
    edit_flag    char(1),
    customer_id  char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran                                              */
/*==============================================================*/
create table tbl_tran
(
    id                char(32) not null,
    owner             char(32),
    money             varchar(255),
    name              varchar(255),
    expected_date     char(10),
    customer_id       char(32),
    stage             varchar(255),
    type              varchar(255),
    source            varchar(255),
    activity_id       char(32),
    contacts_id       char(32),
    create_by         varchar(255),
    create_time       char(19),
    edit_by           varchar(255),
    edit_time         char(19),
    description       varchar(255),
    contact_summary   varchar(255),
    next_contact_time char(10),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran_history                                      */
/*==============================================================*/
create table tbl_tran_history
(
    id            char(32) not null,
    stage         varchar(255),
    money         varchar(255),
    expected_date char(10),
    create_time   char(19),
    create_by     varchar(255),
    tran_id       char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran_remark                                       */
/*==============================================================*/
create table tbl_tran_remark
(
    id           char(32) not null,
    note_content varchar(255),
    create_by    varchar(255),
    create_time  char(19),
    edit_by      varchar(255),
    edit_time    char(19),
    edit_flag    char(1),
    tran_id      char(32),
    primary key (id)
);


# 数据字典数据
INSERT INTO `tbl_dic_type`
VALUES ('appellation', '호칭', ''),
       ('clueState', '리드 상태', ''),
       ('returnPriority', '재방문 우선순위', ''),
       ('returnState', '재방문 상태', ''),
       ('source', '출처', ''),
       ('stage', '단계', ''),
       ('transactionType', '거래 유형', '');


INSERT INTO `tbl_dic_value`
VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '허위리드', '허위리드', 4, 'clueState'),
       ('0fe33840c6d84bf78df55d49b169a894', '영업 이메일', '영업 이메일', 8, 'source'),
       ('12302fd42bd349c1bb768b19600e6b20', '거래 박람회', '거래 박람회', 11, 'source'),
       ('1615f0bb3e604552a86cde9a2ad45bea', '최고', '최고', 2, 'returnPriority'),
       ('176039d2a90e4b1a81c5ab8707268636', '교수', '교수', 5, 'appellation'),
       ('1e0bd307e6ee425599327447f8387285', '추후 연락', '추후 연락', 2, 'clueState'),
       ('2173663b40b949ce928db92607b5fe57', '리드 손실', '리드 손실', 5, 'clueState'),
       ('2876690b7e744333b7f1867102f91153', '시작 안 됨', '시작 안 됨', 1, 'returnState'),
       ('29805c804dd94974b568cfc9017b2e4c', '성사', '성사', 7, 'stage'),
       ('310e6a49bd8a4962b3f95a1d92eb76f4', '연락 시도', '연락 시도', 1, 'clueState'),
       ('31539e7ed8c848fc913e1c2c93d76fd1', '박사', '박사', 4, 'appellation'),
       ('37ef211719134b009e10b7108194cf46', '자격 심사', '자격 심사', 1, 'stage'),
       ('391807b5324d4f16bd58c882750ee632', '유실된 리드', '유실된 리드', 8, 'stage'),
       ('3a39605d67da48f2a3ef52e19d243953', '채팅', '채팅', 14, 'source'),
       ('474ab93e2e114816abf3ffc596b19131', '낮음', '낮음', 3, 'returnPriority'),
       ('48512bfed26145d4a38d3616e2d2cf79', '광고', '광고', 1, 'source'),
       ('4d03a42898684135809d380597ed3268', '파트너 세미나', '파트너 세미나', 9, 'source'),
       ('59795c49896947e1ab61b7312bd0597c', '씨', '씨', 1, 'appellation'),
       ('5c6e9e10ca414bd499c07b886f86202a', '높음', '높음', 1, 'returnPriority'),
       ('67165c27076e4c8599f42de57850e39c', '부인', '부인', 2, 'appellation'),
       ('68a1b1e814d5497a999b8f1298ace62b', '갱쟁으로 인한 손실 마감', '갱쟁으로 인한 손실 마감', 9, 'stage'),
       ('6b86f215e69f4dbd8a2daa22efccf0cf', '웹 조사', '웹 조사', 13, 'source'),
       ('72f13af8f5d34134b5b3f42c5d477510', '파트너', '파트너', 6, 'source'),
       ('7c07db3146794c60bf975749952176df', '연락 안 됨', '연락 안 됨', 6, 'clueState'),
       ('86c56aca9eef49058145ec20d5466c17', '내부 세미나', '내부 세미나', 10, 'source'),
       ('9095bda1f9c34f098d5b92fb870eba17', '진행 중', '진행 중', 3, 'returnState'),
       ('954b410341e7433faa468d3c4f7cf0d2', '기존 거래', '기존 거래', 1, 'transactionType'),
       ('966170ead6fa481284b7d21f90364984', '연락 완료', '연락 완료', 3, 'clueState'),
       ('96b03f65dec748caa3f0b6284b19ef2f', '연기', '연기', 2, 'returnState'),
       ('97d1128f70294f0aac49e996ced28c8a', '신규 거래', '신규 거래', 2, 'transactionType'),
       ('9ca96290352c40688de6596596565c12', '완료', '완료', 4, 'returnState'),
       ('9e6d6e15232549af853e22e703f3e015', '조건 필요', '조건 필요', 7, 'clueState'),
       ('9ff57750fac04f15b10ce1bbb5bb8bab', '요구 분석', '요구 분석', 2, 'stage'),
       ('a70dc4b4523040c696f4421462be8b2f', '대기 중', '대기 중', 5, 'returnState'),
       ('a83e75ced129421dbf11fab1f05cf8b4', '영업 전화', '영업 전화', 2, 'source'),
       ('ab8472aab5de4ae9b388b2f1409441c1', '일반', '일반', 5, 'returnPriority'),
       ('ab8c2a3dc05f4e3dbc7a0405f721b040', '제안/견적', '제안/견적', 5, 'stage'),
       ('b924d911426f4bc5ae3876038bc7e0ad', '웹 다운로드', '웹 다운로드', 12, 'source'),
       ('c13ad8f9e2f74d5aa84697bb243be3bb', '가치 제안', '가치 제안', 3, 'stage'),
       ('c83c0be184bc40708fd7b361b6f36345', '최저', '최저', 4, 'returnPriority'),
       ('db867ea866bc44678ac20c8a4a8bfefb', '직원 추천', '직원 추천', 3, 'source'),
       ('e44be1d99158476e8e44778ed36f4355', '의사결정자 확정', '의사결정자 확정', 4, 'stage'),
       ('e5f383d2622b4fc0959f4fe131dafc80', '여사', '여사', 3, 'appellation'),
       ('e81577d9458f4e4192a44650a3a3692b', '협상/재검토', '협상/재검토', 6, 'stage'),
       ('fb65d7fdb9c6483db02713e6bc05dd19', '온라인 쇼핑몰', '온라인 쇼핑몰', 5, 'source'),
       ('fd677cc3b5d047d994e16f6ece4d3d45', '공개 매체', '공개 매체', 7, 'source'),
       ('ff802a03ccea4ded8731427055681d48', '외부 추천', '외부 추천', 4, 'source');
```

