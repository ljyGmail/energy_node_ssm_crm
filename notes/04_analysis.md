## 20 首页功能分析与设计

2. 首页
    1) 分析需求
    2) 分析与设计
    3) 编码实现
    4) 测试

![img.png](images/020_first_page_process.png)

## 21 首页功能实现Controller层

## 22 首页功能实现页面层

## 23 首页功能测试以及由首页跳转到登录页面的分析与设计

## 24 首页跳转到登录页面实现Controller层

## 25 首页跳转到登录页面实现页面层

## 26 登录功能的分析与设计

![img.png](images/026_login_process.png)

1. 同步请求和异步请求点区别:  
   同步请求: 浏览器窗口发出的请求，响应信息返回浏览器窗口，所以会进行全局刷新。  
   异步请求: ajax发出的请求，响应信息返回到ajax的回调函数，既可以进行全局刷新，也可以进行局部刷新。

   小结: 如果需要进行全局刷新，推荐使用同步请求，当然也可以使用异步请求。  
   如果需要进行局部刷新，只能使用异步请求。  
   如果即可能进行全局刷新，也可能进行局部刷新，也是只能使用异步请求。

2. MyBatis逆向工程:
    1) 简介: 根据表生成mapper层的三部分代码： 实体类，mapper接口，映射文件。
    2) 使用MyBatis逆向工程:
       a) 创建工程: crm-mybatis-generator
       b) 添加插件
        ```xml
       <!-- MyBatis逆向工程插件 -->
       <plugin>
           <groupId>org.mybatis.generator</groupId>
           <artifactId>mybatis-generator</artifactId>
           <version>1.3.2</version>
           <configuration>
               <verbose>true</verbose>
               <overwrite>true</overwrite>
           </configuration>
       </plugin>
        ```
       c) 添加配置文件
        - 数据库连接信息
        - 代码保存的目录
        - 表的信息

       d) 运行MyBatis的逆向工程，根据指定表生成Java代码，保存到指定的目录中。

## 29 登录功能实现Mapper层和Service层

## 30 登录功能实现Controller层

## 31 登录功能实现页面层与优化登录实现代码

3. 使用jQuery获取指定元素的指定属性的值:  
   选择器.attr('属性名'); // 用来获取那些值不是true/false的属性的值  
   选择器.prop('属性名'); // 用来获取值是true/false的属性的值，例如: checked, selected, readonly, disabled等  
