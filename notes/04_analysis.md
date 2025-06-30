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

## 32 登录功能之后业务主页面与名称

- 把控制层(Controller)代码中处理好的数据传递到视图层(jsp)，使用作用域传递:
    - pageContext: 用来在同一个页面的不同标签之间传递数据。
    - request: 在同一个请求过程中间传递数据。
    - session: 同一个浏览器窗口的不同请求之间传递数据。
    - application: 所有用户都共享的数据，并且长久频繁使用的数据。

## 33 实现回车登录

- jQuery的事件函数的用法:
    - 选择器.click(function() { // 给指定的元素添加事件  
      // js 代码  
      });
    - 选择器.click(); // 在指定的元素上模拟发生一次事件

## 34 实现记住密码

- 记住密码:

```plain text
访问: login.jsp --> 后台: .html: 如果上次记住密码，自动填上账号和密码; 否则，删除cookie。  
                如何判断上次是否记住密码?
                -- 上次登录成功，判断是否需要记住密码: 如果需要记住密码，则往浏览器写cookie; 否则，不写。
                            而且cookie的值必须是该用户的loginAct和loginPwd。
                -- 下次登录时，判断该用户有没有cookie: 如果有，则自动填写账号和密码，否则，不写。
                            而且填写的是cookie的值。
    --> 浏览器显示
    
获取cookie:
1. 使用Java代码获取cookie:
    Cookie[] cs = request.getCookies();
    for(Cookie c : cs) {
        if (c.getName().equals("loginAct")) {
            String loginAct = c.getValue();
        } else if (c.getName().equals("loginPwd")) {
            String loingPwd = c.getValue();
        }
    }
    
2. 使用EL表达式获取cookie:
${cookie.loginAct.value}
```

## 36 安全退出功能分析需求与设计

![img.png](images/036_logout_process.png)

## 37 安全退出功能的实现

## 38 登录验证功能的需求分析

- 用户访问任何业务资源，都需要进行登录验证。
- 只有登录成功的用户才能访问业务资源。
- 没有登录成功的用户访问业务资源，跳转到登录页面。

## 39 登录验证功能实现技术的分析

- 登录验证:
```text
1) 过滤器:
    a) implements Filter {
            -- init
            -- doFilter
            -- destroy
        }
    b) 配置过滤器: web.xml
2) 拦截器:
    a) 提供拦截器类: implements HandlerInterceptor {
                        -- pre
                        -- post
                        -- after
                    }
    b) 配置拦截器: springmvc.xml
```
