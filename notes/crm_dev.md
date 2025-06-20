## 002 阶段简介

1. web项目的开发: 如何分析，设计，编码，测试。
2. CRM项目。编程思想和编程习惯，关键。
   课堂上，听懂，跟上思路。
   课下，做项目。

## 003 技术架构1

## 004 技术架构2

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
    - 持久层(Dao/Mapper):
