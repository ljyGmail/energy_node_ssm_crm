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
    
    



