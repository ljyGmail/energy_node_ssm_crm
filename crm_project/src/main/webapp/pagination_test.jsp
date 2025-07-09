<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>演示bs_pagination插件</title>
    <base href="<%=basePath%>">
    <!-- jQuery -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!-- Bootstrap框架 -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css"/>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <!-- Bootstrap pagination插件 -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script>
        $(function () {
            $('#demo_pag1').bs_pagination({
                currentPage: 3, // 当前页号，相当于pageNo

                rowsPerPage: 20, // 每页显示条数，相当于pageSize
                totalRows: 1000, // 总条数
                totalPages: 50, // 总页数，必填参数

                visiblePageLinks: 10, // 最多可以显示的卡片数

                showGoToPage: true, // 是否显示"跳转到"组件，默认为true(显示)
                showRowsPerPage: true, // 是否显示"每页显示条数"组件，默认为true(显示)
                showRowsInfo: true, // 是否显示"记录信息"组件，默认为true(显示)
                // 用户每次切换页号，都会触发此函数
                // 每次返回切换页号之后的pageNo和pageSize
                onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has been clicked
                    console.log(pageObj); // Object { currentPage: 2, rowsPerPage: 20 }
                },
            });
        });
    </script>
</head>
<body>
<div id="demo_pag1"></div>
</body>
</html>
