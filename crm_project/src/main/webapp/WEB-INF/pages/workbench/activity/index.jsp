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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">
        $(function () {
            // 给"创建"按钮添加单机事件
            $('#createActivityBtn').click(function () {
                // 初始化工作，任意js代码
                // 重置所有表单组件的值
                $('#createActivityForm').get(0).reset();

                // 弹出创建市场活动的模态窗口
                $('#createActivityModal').modal('show');
            });

            // 给"保存"按钮加单击事件
            $('#saveCreatedActivityBtn').click(function () {
                // 收集参数
                let owner = $('#create-marketActivityOwner').val();
                let name = $.trim($('#create-marketActivityName').val());
                let startDate = $('#create-startDate').val();
                let endDate = $('#create-endDate').val();
                let cost = $.trim($('#create-cost').val());
                let description = $.trim($('#create-description').val());
                // 表单验证
                if (owner === '') {
                    alert('소유자를 선택하세요');
                    return;
                }
                if (name === '') {
                    alert('마케팅 활동 명칭을 입력하세요');
                    return;
                }
                if (startDate !== '' && endDate !== '') {
                    // 使用字符串的大小代替日期的大小
                    if (endDate < startDate) {
                        alert('종료일자는 시작일자보다 이르면 안 됩니다');
                        return;
                    }
                }
                /*
                正则表达式:
                    1. 语言，语法: 定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式。
                    2. 语法通则:
                        1) //: 在JS中定义一个正则表达式。 const regExp = /.../;
                        2) ^: 匹配字符串的开头位置。
                           $: 匹配字符串的结尾。
                        3) []: 匹配指定字符集中的一位字符。 const regExp = /[a-z0-9]/;
                        4) {}: 匹配次数. const regExp = /^[abc]{5}$/;
                                {m}: 匹配m次
                                {m,n}: 匹配m次到n次
                                {m,}: 匹配m次或者更多次
                        5) 特殊符号:
                            \d: 匹配一位数字，相当于{0-9}。
                            \D: 匹配一位非数字。
                            \w: 匹配所有字符，包括字母，数字，下划线。
                            \W: 匹配非字符，除了字母，数字，下划线之外的字符。

                            *: 匹配0次或者多次，相当于{0,}
                            +: 匹配1次或者多次，相当于{1,}
                            ?: 匹配0次或者1次，相当于{0,1}
                 */
                const regExp = /^(([1-9]\d*)|0)$/
                if (!regExp.test(cost)) {
                    alert('비용은 0 이상의 정수만 입력할 수 있습니다');
                    return;
                }

                // 发送请求
                $.ajax({
                    url: 'workbench/activity/saveCreatedActivity.do',
                    data: {
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code === '1') {
                            // 关闭模态窗口
                            $('#createActivityModal').modal('hide');
                            // 刷新市场活动列表，显示第一页数据，保持每页显示条数不变
                            const rowsPerPage = $('#page-master').bs_pagination('getOption', 'rowsPerPage');
                            queryActivityByConditionForPaging(1, rowsPerPage);
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $('#createActivityModal').modal('show'); // 可以不写
                        }
                    },
                });
            });

            // 当容器加载完成后，对容器调用工具函数
            $('.my-date').datetimepicker({
                language: 'zh-CN', // 语言
                format: 'yyyy-mm-dd', // 日期的格式
                minView: 'month', // 可以选择的最小视图
                initialDate: new Date(), // 初始化选择的日期
                autoclose: true, // 设置选择完日期或者时间后，是否自动关闭日历
                todayBtn: true, // 设置是否显示"今天"按钮，默认为false
                clearBtn: true, // 设置是否显示"清空"按钮，默认为false
            });

            // 当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数，默认每页显示10条
            queryActivityByConditionForPaging(1, 10);

            // 给"查询"按钮添加单击事件
            $('#queryActivityBtn').click(function () {
                // 获取当前'每页显示多少条'的值，bs_pagination插件中提供了获取其参数的方式
                const rowsPerPage = $('#page-master').bs_pagination('getOption', 'rowsPerPage');
                // 当用户点击"查询"按钮，查询所有符合条件的数据的第一页以及所有符合条件数据的总条数
                queryActivityByConditionForPaging(1, rowsPerPage);
            });

            // 给"全选"按钮添加单击事件
            $('#checkAll').click(function () {
                $('#tBody input:checkbox').prop('checked', this.checked);
            });

            /*
            // 为动态生成的复选框添加单击事件，和全选复选框形成联动的效果
            // 下面的方式无法实现效果，因为复选框是动态生成的
            $('#tBody input:checkbox').click(function () {
                console.log('xxx');
                const allChecked = $('#tBody input:checkbox').size() === $('#tBody input:checkbox:checked').size()
                $('#checkAll').prop("checked", allChecked);
            });
             */

            // 为动态生成的复选框添加单击事件，和全选复选框形成联动的效果
            $('#tBody').on('click', 'input:checkbox', function () {
                const allChecked = $('#tBody input:checkbox').size() === $('#tBody input:checkbox:checked').size()
                $('#checkAll').prop("checked", allChecked);
            });

            // 给"删除"按钮添加单击事件
            $('#deleteActivityBtn').click(function () {
                // 收集参数
                // 获取列表中所有被选中的checkbox
                const checkedIds = $('#tBody input:checkbox:checked');

                if (checkedIds.size() === 0) {
                    alert('삭제할 마케팅 활동을 체크하세요');
                    return;
                }
                if (confirm('해당 마케팅 활동을 삭제하겠습니까?')) {
                    let ids = '';
                    $.each(checkedIds, function () {
                        ids += 'id=' + this.value + '&';
                    });
                    ids = ids.substr(0, ids.length - 1);

                    // 发送请求
                    $.ajax({
                        url: 'workbench/activity/deleteActivityByIds.do',
                        data: ids,
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == 1) {
                                // 刷新市场活动列表，显示第一页数据，保持每页显示的条数不变
                                const rowsPerPage = $('#page-master').bs_pagination('getOption', 'rowsPerPage');
                                queryActivityByConditionForPaging(1, rowsPerPage);
                            } else {
                                // 提示信息
                                alert(data.message);
                            }
                        }
                    });
                }
            });

            // 给"修改"按钮添加单击事件
            $('#editActivityBtn').click(function () {

                const checkedIds = $('#tBody input:checkbox:checked');

                // 确保只有一个复选框被选中
                if (checkedIds.size() == 0) {
                    alert('수정할 마케팅 활동을 체크하세요');
                    return;
                }

                if (checkedIds.size() > 1) {
                    alert('수정할 마케팅 활동을 1개 선택하세요');
                    return;
                }

                // 向后台发请求查询当前需要修改的市场活动的数据
                $.ajax({
                    url: 'workbench/activity/queryActivityById.do',
                    data: {
                        id: checkedIds.get(0).value
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        // 回显表单中的数据
                        $('#edit-id').val(data.id);
                        $('#edit-marketActivityOwner').val(data.owner);
                        $('#edit-marketActivityName').val(data.name);
                        $('#edit-startDate').val(data.startDate);
                        $('#edit-endDate').val(data.endDate);
                        $('#edit-cost').val(data.cost);
                        $('#edit-description').val(data.description);

                        // 弹出模态窗口
                        $("#editActivityModal").modal('show');
                    }
                });
            });

            // 给"更新“按钮添加单击事件
            $('#saveEditedActivityBtn').click(function () {
                // 收集参数
                const id = $('#edit-id').val();
                const owner = $('#edit-marketActivityOwner').val();
                const name = $.trim($('#edit-marketActivityName').val());
                const startDate = $('#edit-startDate').val();
                const endDate = $('#edit-endDate').val();
                const cost = $.trim($('#edit-cost').val());
                const description = $.trim($('#edit-description').val());

                if (owner === '') {
                    alert('소유자를 선택하세요');
                    return;
                }
                if (name === '') {
                    alert('마케팅 활동 명칭을 입력하세요');
                    return;
                }
                if (startDate !== '' && endDate !== '') {
                    // 使用字符串的大小代替日期的大小
                    if (endDate < startDate) {
                        alert('종료일자는 시작일자보다 이르면 안 됩니다');
                        return;
                    }
                }

                const regExp = /^(([1-9]\d*)|0)$/
                if (!regExp.test(cost)) {
                    alert('成本只能是非负整数');
                    return;
                }

                // 发送请求
                $.ajax({
                    url: 'workbench/activity/saveEditedActivity.do',
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description,
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 关闭模态窗口
                            $('#editActivityModal').modal('hide');
                            // 刷新市场活动列表，保持页号和每页显示条数都不变
                            const currentPage = $('#page-master').bs_pagination('getOption', 'currentPage');
                            const rowsPerPage = $('#page-master').bs_pagination('getOption', 'rowsPerPage');
                            queryActivityByConditionForPaging(currentPage, rowsPerPage);
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $('#editActivityModal').modal('show');
                        }
                    },
                })
            });

            // 给"批量导出"按钮添加单击事件
            $('#exportAllActivitiesBtn').click(function () {
                // 发送同步请求
                window.location.href = 'workbench/activity/exportAllActivities.do';
            });

            $('#exportSelectedActivitiesBtn').click(function () {

                const checkedIds = $('#tBody input:checkbox:checked');

                if (checkedIds.size() === 0) {
                    alert('다운로드할 마케팅 활동을 체크하세요');
                    return;
                }

                // 拼接q请求参数
                let ids = '';
                $.each(checkedIds, function () {
                    ids += 'id=' + this.value + '&';
                });
                ids = ids.substr(0, ids.length - 1);
                // 发送同步请求
                window.location.href = 'workbench/activity/exportSelectedActivities.do?' + ids;
            });

            $('#importActivityBtn').click(function () {
                // 收集参数
                const activitiesFileName = $('#activitiesFile').val();
                const suffix = activitiesFileName.substr(activitiesFileName.lastIndexOf('.') + 1).toLowerCase();
                if (suffix !== 'xls') {
                    alert('.xls파일만 지원합니다.');
                    return;
                }

                const activitiesFile = $('#activitiesFile').get(0).files[0];
                if (activitiesFile.size > 5 * 1024 * 1024) {
                    alert('파일 용량이 5MB 초과하면 안됩니다.')
                    return;
                }

                // FormDate是ajax提供的接口，可以模拟键值对向后台提交参数。
                // FormDate最大的优势是不但能提供文本数据，还能提交二进制数据。
                const formData = new FormData();
                formData.append('activitiesFile', activitiesFile);
                $.ajax({
                    url: 'workbench/activity/importActivities.do',
                    data: formData,
                    processData: false, // 设置ajax向后台提交参数之前，是否把参数统一转换成字符串，默认是true。
                    contentType: false, // 设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码，默认是true。
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 提示成功导入记录条数
                            alert("成功导入" + data.retData + "条记录");
                            // 关闭模态窗口
                            $('#importActivityModal').modal('hide');
                            // 刷新市场活动列表，显示第一页数据，保持每页显示条数不变
                            const rowsPerPage = $('#page-master').bs_pagination('getOption', 'rowsPerPage');
                            queryActivityByConditionForPaging(1, rowsPerPage);
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $('#importActivityModal').modal('show');
                        }
                    }
                });
            });
        });

        function queryActivityByConditionForPaging(pageNo, pageSize) {
            // 收集参数
            const name = $('#query-name').val();
            const owner = $('#query-owner').val();
            const startDate = $('#query-startDate').val();
            const endDate = $('#query-endDate').val();
            // const pageNo = 1;
            // const pageSize = 10;
            // 发送请求
            $.ajax({
                url: 'workbench/activity/queryActivityByConditionForPaging',
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNo: pageNo,
                    pageSize: pageSize,
                },
                type: 'post',
                dataType: 'json',
                success: function (data) {
                    // 显示总条数
                    // $('#totalRowsB').text(data.totalRows);
                    // 显示市场活动的列表
                    // 遍历activityList，拼接所有行数据
                    var htmlStr = '';
                    $.each(data.activityList, function (index, obj) {
                        htmlStr += '<tr class="active">';
                        htmlStr += '<td><input type="checkbox" value="' + obj.id + '"/></td>';
                        htmlStr += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detailActivity.do?id=' + obj.id + '\'">' + obj.name + '</a></td>';
                        htmlStr += '<td>' + obj.owner + '</td>';
                        htmlStr += '<td>' + obj.startDate + '</td>';
                        htmlStr += '<td>' + obj.endDate + '</td>';
                        htmlStr += '</tr>';
                    });
                    $('#tBody').html(htmlStr);

                    // 每次重新获取市场活动列表数据时，需要将全选复选框的状态设置为未选状态。
                    $('#checkAll').prop('checked', false);

                    // 计算总页数
                    let totalPages = 1;
                    totalPages = data.totalRows / pageSize;
                    if (data.totalRows % pageSize === 0) {
                        totalPages = parseInt(data.totalRows / pageSize);
                    } else {
                        totalPages = parseInt(data.totalRows / pageSize) + 1;
                    }

                    // 调用bs_pagination工具函数，显示分页信息
                    $('#page-master').bs_pagination({
                        currentPage: pageNo, // 当前页号，相当于pageNo

                        rowsPerPage: pageSize, // 每页显示条数，相当于pageSize
                        totalRows: data.totalRows, // 总条数
                        totalPages: totalPages, // 总页数，必填参数

                        visiblePageLinks: 5, // 最多可以显示的卡片数

                        showGoToPage: true, // 是否显示"跳转到"组件，默认为true(显示)
                        showRowsPerPage: true, // 是否显示"每页显示条数"组件，默认为true(显示)
                        showRowsInfo: true, // 是否显示"记录信息"组件，默认为true(显示)
                        // 用户每次切换页号，都会触发此函数
                        // 每次返回切换页号之后的pageNo和pageSize
                        onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has been clicked
                            // console.log(pageObj); // Object { currentPage: 2, rowsPerPage: 20 }
                            queryActivityByConditionForPaging(pageObj.currentPage, pageObj.rowsPerPage);
                        },
                    });
                },
            });
        }
    </script>
</head>
<body>
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">마케팅 활동 등롱</h4>
            </div>
            <div class="modal-body">
                <form id="createActivityForm" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">소유자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">마케팅 활동 명칭<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">시작일자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control my-date" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">종료일자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control my-date" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-cost" class="col-sm-2 control-label">원가</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">상세</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" id="closeCreateActivityBtn">닫기
                </button>
                <button type="button" class="btn btn-primary" id="saveCreatedActivityBtn">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">마케팅 활동 수정</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" id="owner" class="col-sm-2 control-label">소유자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">마케팅 활동 명칭<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">시작일자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control my-date" id="edit-startDate" value="2020-10-10">
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">종료일자</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control my-date" id="edit-endDate" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">원가</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">상세</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="saveEditedActivityBtn">수정</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">마케팅 활동 가져오기</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    업로드할 파일을 선택하세요:<small style="color: gray;">[.xls파일만 가능]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activitiesFile">
                    <br>
                    <a href="file/activity.xls" download="activity-mode.xls"
                       style="text-decoration:none;color: #2a6496"><b>엑셀 템플릿 다운로드</b></a>
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>안내</h3>
                    <ul>
                        <li>본 기능은 Excel 파일만 지원하며, 파일 확장자가 .xls인 경우에만 가능합니다.</li>
                        <li>업로드한 파일의 첫 번째 행은 필드명으로 인식됩니다.</li>
                        <li>파일 크기는 최대 5MB를 초과하지 않아야 합니다.</li>
                        <li>날짜 값은 텍스트 형식으로 저장되며, yyyy-MM-dd 형식을 따라야 합니다.</li>
                        <li>날짜와 시간은 텍스트 형식으로 저장되며, yyyy-MM-dd HH:mm:ss 형식을 따라야 합니다.</li>
                        <li>기본 문자 인코딩은 UTF-8(유니코드)입니다. 올바른 문자 인코딩 방식으로 저장된 파일인지 확인해 주세요.</li>
                        <li>실제 데이터를 가져오기 전에 테스트 파일로 가져오기 기능을 사전 테스트해 보시길 권장합니다.</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">가져오기</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>마켓팅 활동 목록</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">명칭</div>
                        <input class="form-control clear-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">소유자</div>
                        <input class="form-control clear-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">시작일자</div>
                        <input class="form-control my-date clear-control" type="text" id="query-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">종료일자</div>
                        <input class="form-control my-date clear-control" type="text" id="query-endDate" readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityBtn">조회</button>
                &nbsp;
                <button type="button" class="btn btn-default" id="clearActivityBtn">초기화</button>
            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn"><span
                        class="glyphicon glyphicon-plus"></span> 등록
                </button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 수정
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span
                        class="glyphicon glyphicon-minus"></span> 삭제
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 데이터 목록 업로드
                </button>
                <button id="exportAllActivitiesBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 데이터 목록 다운로드(일괄)
                </button>
                <button id="exportSelectedActivitiesBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 데이터 목록 다운로드(개별)
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>명칭</td>
                    <td>소유자</td>
                    <td>시작일자</td>
                    <td>종료일자</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--						<tr class="active">--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>2020-10-10</td>--%>
                <%--                            <td>2020-10-20</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
            <div id="page-master"></div>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 30px;">--%>
        <%--            <div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB"></b>条记录--%>
        <%--                </button>--%>
        <%--            </div>--%>
        <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
        <%--                <div class="btn-group">--%>
        <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
        <%--                        10--%>
        <%--                        <span class="caret"></span>--%>
        <%--                    </button>--%>
        <%--                    <ul class="dropdown-menu" role="menu">--%>
        <%--                        <li><a href="#">20</a></li>--%>
        <%--                        <li><a href="#">30</a></li>--%>
        <%--                    </ul>--%>
        <%--                </div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
        <%--            </div>--%>
        <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
        <%--                <nav>--%>
        <%--                    <ul class="pagination">--%>
        <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
        <%--                        <li class="active"><a href="#">1</a></li>--%>
        <%--                        <li><a href="#">2</a></li>--%>
        <%--                        <li><a href="#">3</a></li>--%>
        <%--                        <li><a href="#">4</a></li>--%>
        <%--                        <li><a href="#">5</a></li>--%>
        <%--                        <li><a href="#">下一页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
        <%--                    </ul>--%>
        <%--                </nav>--%>
        <%--            </div>--%>
        <%--        </div>--%>
    </div>
</div>
</body>
</html>