<%--
  Created by IntelliJ IDEA.
  User: liangjinyong
  Date: 2025. 7. 14.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示文件上传</title>
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
<!--
    文件上传的表单的三个条件:
        1. 表单组件标签必须用: <input type="file">
        <input type="text|password|radio|checkbox|hidden|button|submit|reset|file"/>
            <select>,<textarea>等
        2. 请求方式只能用post
            get: 参数通过请求头提交到后台，参数放在URL后边，只能向后台提交文本数据，对参数对长度有限制，数据不安全，效率高。
            post: 参数通过请求体提交到后台，既能提交文本数据，也能提交二进制数据。理论上来讲对长度没有限制，相对安全，效率相对较低。
        3. 表单的编码格式只能用: multipart/form-data
            根据HTTP协议的规定，浏览器每次向后台提交参数，都会对参数进行统一编码，默认采用的编码格式是urlencoded，这种编码格式只能对文本数据进行编码。
            浏览器每次向后台提交参数，都会首先把所有的参数都转换成字符串，然后对这些数据统一进行urlencoded编码。
            文件上传的表单编码格式只能用multipart/form-data: enctype="multipart/form-data"。
-->
<form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
    <input type="file" name="myFile"><br>
    <input type="text" name="userName"><br>
    <input type="submit" value="上传">
</form>
</body>
</html>
