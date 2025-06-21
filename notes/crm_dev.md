## 002 阶段简介

1. web项目的开发: 如何分析，设计，编码，测试。
2. CRM项目。编程思想和编程习惯，关键。
   课堂上，听懂，跟上思路。
   课下，做项目。

## 003 技术架构1

## 004 技术架构2

## 005 技术架构3

3. CRM的技术架构:
    - 视图层(View): 展示数据，跟用户交互。
        - HTML, CSS, JavaScript, jQuery, Bootstrap (Ext|easyUI), JSP
    - 控制层(Controller): 控制业务处理的流程(
      接收请求，接收参数，封装参数；根据不同的请求调用业务层处理业务；根据处理结果，返回响应信息)
        - (Servlet,)SpringMVC,(WebWork, Struts1, Struts2)
    - 业务层(Service): 处理业务逻辑(处理业务的步骤以及操作的原子性)。
        - JavaSE(工作流: activiti|JBPM)

        1. 添加学生
        2. 记录操作日志
    - 持久层(Dao/Mapper): 操作数据库。
        - (JDBC,) MyBatis,(Hibernate, iBatis)
    - 整合层: 维护类资源，维护数据库资源
        - Spring(IOC, AOP), (EJB, Corba)

## 006 阶段教学目的

4. 教学方式:
    - 做web项目开发，

5. 教学目的:
    1) 对软件公司和软件开发有一定的了解
    2) 了解CRM项目的核心业务
    3) 能够独立完成CRM项目核心业务的开发
    4) 对前期所学的技术进行回顾，熟练，加深和扩展
    5) 掌握互联网基础课: Linux，Redis，Git

## 007 软件开发生命周期1

6. 软件公司的组织结构:
    - 研发部(程序员，美工，DBA)，测试部，产品部，实施部，运维部，市场部

## 008 软件开发生命周期2

7. 软件开发的生命周期:
    1) 招标:  
       投标: ---- 标书

       甲方:  
       乙方:
    2) 可行性分析: ------> 可行性分析报告  
       技术，经济
    3) 需求分析: -------> 需求文档
       产品经理，需求调研  
       项目原型: 容易确定需求，开发项目时作为JSP网页
    4) 分析与设计:
        - 架构设计:
            - 物理架构设计:
                - 应用服务器: tomcat(apache)，WebLogic(BEA-->Oracle)，WebSphere(IBM)，JBOSS(RedHat)，Resin(Microsoft)
                - Web JavaEE: 13种协议
                    - Servlet, JSP, XML, JDBC, MQ...
                - 数据库服务器: MySQL, Oracle, DB2, SQLServer, 达梦




