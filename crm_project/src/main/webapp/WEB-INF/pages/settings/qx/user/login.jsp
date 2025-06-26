<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 设置动态初始访问路径（这里本地是http://127.0.0.1:8080/crm/）
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2022 ylx</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input id="loginAct" class="form-control" type="text" value="${cookie.loginAct.value}"
                           placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" class="form-control" type="password" value="${cookie.loginPwd.value}"
                           placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <%--存在账号密码cookie就默认选择复选框，如果不存在那么默认不选中--%>
                        <c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                            <input id="isRemPwd" type="checkbox" checked>
                        </c:if>
                        <c:if test="${empty cookie.loginAct and empty cookie.loginPwd}">
                            <input id="isRemPwd" type="checkbox">
                        </c:if>
                        记住密码
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="color: red"></span>
                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
                <br/>
                <button type="button" class="btn btn-primary btn-lg btn-block" id="registerBtn"
                        style="width: 350px; position: relative;top: 45px;">注册
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>