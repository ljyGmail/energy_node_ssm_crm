<%--
  Created by IntelliJ IDEA.
  User: liangjinyong
  Date: 2025. 7. 12.
  Time: 오후 10:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示文件下载</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
            // 给"下载"按钮添加单击事件
            $('#fileDownloadBtn').click(function () {
                // 发送文件下载的请求
                window.location.href = 'workbench/activity/fileDownload.do';
            });
        });
    </script>
</head>
<body>
<input type="button" value="下载" id="fileDownloadBtn">
</body>
</html>
