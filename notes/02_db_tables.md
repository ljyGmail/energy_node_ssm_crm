# CRM物理模型设计

## 1. CRM的表结构

    - tbl_user 用户表

    - tbl_dic_type 数据字典类型表
    - tbl_dic_value 数据字典值

    - tbl_activity 市场活动表
    - tbl_activity_remark 市场活动备注表

    - tbl_clue 线索表
    - tbl_clue_remark 线索备注表

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

