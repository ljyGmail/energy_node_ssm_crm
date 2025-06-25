## 017 搭建开发环境1

## 018 搭建开发环境2

## 019 搭建开发环境3

3. 搭建开发环境
    1) 创建项目: crm_project
       工程  
       创建工程: crm  
       补全目录结构  
       设置编码格式: UTF-8
    2) 添加jar包: 添加依赖
    3) 添加配置文件
    4) 添加静态页面资源

    - webapps
        - stumgr
        - crm
            - .html, .css, .js, .img, test.jsp
            - WEB-INF
                - web.xml
                - classes
                - libs

    * web应用根目录下的内容都是不安全的，外界可以通过url直接访问。  
      所以，一般为了数据的安全，都会把页面放到`WEB-INF`下，因为`WEB-INF`下的资源是受保护的，外界不能直接访问。  
      http://127.0.0.1:8080/crm/test.jsp

    - webapps
        - stumgr
        - crm
            - .css, .js, .img
            - WEB-INF
                - web.xml
                - classes
                - libs
                - pages/test.jsp

    5) 把CRM项目部署到tomcat上。
