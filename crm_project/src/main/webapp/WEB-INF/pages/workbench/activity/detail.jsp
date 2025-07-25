<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelActivityRemarkBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;

                // 清空文本域中内容
                $("#remark").val("");
            });

            /*$(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });*/
            $("#remarkDivList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            /*$(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });*/
            $("#remarkDivList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            /*$(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });*/
            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            /*$(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });*/
            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            // 给"保存"按钮添加单击事件
            $("#saveCreateActivityRemarkBtn").click(function () {
                // 收集参数
                var noteContent = $.trim($("#remark").val());
                var activityId = '${activity.id}'; // 从request域中收集
                // 表单验证
                if (noteContent == "") {
                    alert("비고 내용을 작성하세요");
                    return;
                }
                // 发送请求
                $.ajax({
                    url: 'workbench/activity/saveCreatedActivityRemark.do',
                    data: {
                        noteContent: noteContent,
                        activityId: activityId
                    },
                    type: 'post',
                    dateType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 清空输入框
                            $("#remark").val("");
                            // 刷新备注列表
                            var htmlStr = "";
                            htmlStr += "<div id=\"div_" + data.retData.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr += "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr += "<h5>" + data.retData.noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">마케팅 활동</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\"> " + data.retData.createTime + "에 ${sessionScope.sessionUser.name}님이 등록했습니다.</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "<a class=\"myHref\" name=\"editA\" remarkId=\"" + data.retData.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a class=\"myHref\" name=\"deleteA\" remarkId=\"" + data.retData.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            $("#remarkDiv").before(htmlStr); // 以追加的方式增加备注
                        } else {
                            // 提示信息
                            alert(data.message);
                        }
                    }
                });
            });

            // 给所有的"删除"图标添加单击事件
            $("#remarkDivList").on("click", "a[name='deleteA']", function () {
                // 收集参数
                var id = $(this).attr("remarkId"); // 获取删除选中的备注的id，使用attr()来获取自定义属性remarkId存放的的备注id值
                // 发送请求
                $.ajax({
                    url: 'workbench/activity/deleteActivityRemarkById.do',
                    data: {
                        id: id
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 刷新备注列表（直接移除删除的备注，此时数据库已经删除成功，这里是删除前端界面的信息）
                            $("#div_" + id).remove(); // remove()会从dom树中删除匹配元素
                        } else {
                            // 提示信息
                            alert(data.message);
                        }
                    }
                });
            });

            // 给所有市场活动备注后边的"修改"图标添加单击事件
            $("#remarkDivList").on("click", "a[name='editA']", function () {
                // 获取备注的id和noteContent
                var id = $(this).attr("remarkId"); // 通过自定义标签获取
                // 获取div的标签中的h5标签的内容，h5标签中就是备注内容（父子选择器，不要忘了前面的空格）
                var noteContent = $("#div_" + id + " h5").text();
                // 把备注的id和noteContent写到修改备注的模态窗口中
                $("#edit-id").val(id); // 给修改备注的模态窗口的隐藏input标签中写入该备注的id，用于修改
                $("#edit-noteContent").val(noteContent); // 写入备注的内容
                // 弹出修改市场活动备注的模态窗口
                $("#editRemarkModal").modal("show");
            });

            // 给“更新”按钮添加单击事件
            $("#updateRemarkBtn").click(function () {
                //收集参数
                var id = $("#edit-id").val(); // 修改备注的模态窗口的备注id
                var noteContent = $.trim($("#edit-noteContent").val()); // 修改备注的模态窗口的备注内容
                //表单验证
                if (noteContent == "") {
                    alert("비고 내용을 작성하세요");
                    return;
                }
                // 发送请求
                $.ajax({
                    url: 'workbench/activity/saveEditedActivityRemark.do',
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                            // 刷新备注列表（在前端写数据）
                            $("#div_" + data.retData.id + " h5").text(data.retData.noteContent); // 备注前端显示修改后的数据
                            $("#div_" + data.retData.id + " small").text(" " + data.retData.editTime + "에 ${sessionScope.sessionUser.name}님이 수정했습니다.");
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $("#editRemarkModal").modal("show");
                        }
                    }
                });
            });
        });
    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>마케팅 활동-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">소유자</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">명칭</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">시작일자</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">종료일자</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">원가</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">등록자</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">수정자</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">상세</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>비고</h4>
    </div>

    <!-- 备注1 -->
    <!--遍历市场活动列表-->
    <c:forEach items="${activityRemarkList}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">마케팅 활동</font> <font color="gray">-</font> <b>${activity.name}</b> <small
                    style="color: gray;">${remark.editFlag=='1'?remark.editTime:remark.createTime}에 ${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'님이 수정했습니다.':'님이 등록했습니다.'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- 备注2 -->
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>呵呵！</h5>--%>
    <%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="비고를 작성하세요..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelActivityRemarkBtn" type="button" class="btn btn-default">취소</button>
                <button type="button" class="btn btn-primary" id="saveCreateActivityRemarkBtn">저장</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>