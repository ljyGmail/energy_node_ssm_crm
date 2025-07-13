<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
        //页面加载完毕
        $(function () {
            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color", "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color", "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function () {
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color", "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color", "white");
            });

            // 跳转工作台界面
            window.open("workbench/main/index.do", "workareaFrame");

            // 退出按钮事件
            $("#logoutBtn").click(function () {
                // 发送同步请求
                window.location.href = "settings/qx/user/logout.do";
            })
        });
    </script>
</head>
<body>

<!-- 我的资料 模态窗口 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">내 정보</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    성명：<b>${sessionScope.sessionUser.name}</b><br><br>
                    계정：<b>${sessionScope.sessionUser.loginAct}</b><br><br>
                    부서번호：<b>${sessionScope.sessionUser.deptno}</b><br><br>
                    메일：<b>${sessionScope.sessionUser.email}</b><br><br>
                    계정실효일시：<b>${sessionScope.sessionUser.expireTime}</b><br><br>
                    접속 허용 IP：<b>${sessionScope.sessionUser.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">비밀번호 변경</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">기존 비밀번호</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="oldPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">새 비밀번호</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">새 비밀번호 확인</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="window.location.href='login.html';">변경
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">로그아웃</h4>
            </div>
            <div class="modal-body">
                <p>로그아웃 하겠습니까?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
                <button type="button" id="logoutBtn" class="btn btn-primary" data-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2025&nbsp;LJY</span></div>
    <div style="position: absolute; top: 15px; right: 15px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.sessionUser.name} <span
                        class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="left: -80px;">
                    <li><a href="settings/index.html"><span class="glyphicon glyphicon-wrench"></span> 시스템 설정</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span
                            class="glyphicon glyphicon-file"></span> 내 정보</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span
                            class="glyphicon glyphicon-edit"></span> 비번변경</a></li>
                    <li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span
                            class="glyphicon glyphicon-off"></span> 로그아웃</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">

        <ul id="no1" class="nav nav-pills nav-stacked">
            <li class="liClass"><a href="workbench/main/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-home"></span> 워크벤치</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-tag"></span> 활동 내역</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-time"></span> 승인</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-user"></span> 고객 공용 풀</a></li>
            <li class="liClass"><a href="workbench/activity/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-play-circle"></span> 마케팅 활동</a></li>
            <li class="liClass"><a href="workbench/clue/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-search"></span> 리드(잠재 고객)</a></li>
            <li class="liClass"><a href="workbench/customer/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-user"></span> 고객</a></li>
            <li class="liClass"><a href="workbench/contacts/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-earphone"></span> 연락처</a></li>
            <li class="liClass"><a href="workbench/transaction/index.do" target="workareaFrame"><span
                    class="glyphicon glyphicon-usd"></span> 거래(비즈니스 기회)</a></li>
            <li class="liClass"><a href="visit/index.html" target="workareaFrame"><span
                    class="glyphicon glyphicon-phone-alt"></span> 애프터서비스 방문</a></li>
            <li class="liClass">
                <a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span>
                    통계 차트</a>
                <ul id="no2" class="nav nav-pills nav-stacked collapse">
                    <li class="liClass"><a href="workbench/chart/activity/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 市场活动统计图表</a></li>
                    <li class="liClass"><a href="workbench/chart/clue/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 线索统计图表</a></li>
                    <li class="liClass"><a href="workbench/chart/customerAndContacts/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 客户和联系人统计图表</a></li>
                    <li class="liClass"><a href="workbench/chart/transaction/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span> 交易统计图表</a></li>
                </ul>
            </li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-file"></span> 보고서</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-shopping-cart"></span> 판매 주문서</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-send"></span> 배송서</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-earphone"></span> 후속 조치</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-leaf"></span> 제품</a></li>
            <li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span
                    class="glyphicon glyphicon-usd"></span> 견적</a></li>
        </ul>

        <!-- 分割线 -->
        <div id="divider1"
             style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>
</html>