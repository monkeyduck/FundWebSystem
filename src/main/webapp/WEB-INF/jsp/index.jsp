<%--
  Created by IntelliJ IDEA.
  User: llc
  Date: 16/7/7
  Time: 上午10:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String serverPath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/";
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>dialogNode</title>

    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="//cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>

    <%--引入bootstrap js--%>
    <script src='<c:url value="/resources/sbadmin/vendor/bootstrap/js/bootstrap.min.js"></c:url>'></script>


    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/bootstrap/css/bootstrap.min.css"></c:url>' rel="stylesheet" >
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/metisMenu/metisMenu.min.css"></c:url>' rel="stylesheet" >
    <link type="text/css" href='<c:url value="/resources/sbadmin/dist/css/sb-admin-2.css"></c:url>' rel="stylesheet" >
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/morrisjs/morris.css"></c:url>' rel="stylesheet" >
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/font-awesome/css/font-awesome.min.css"></c:url>' rel="stylesheet" >


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script>
        leafNodeList = new Array();
        jQuery.noConflict();
        jQuery(document).ready(function ( $ ) {
            // 如果指定了话题id, 那么直接初始化话题节点列表
            var topic_id = "${topicId}";
            if (!isEmptyObject(topic_id)) {
                showDialogTree(topic_id);
            }
            // 异步初始化类别列表,避免加载时间过长
            $.ajax({
                type: "GET",
                url: "listCategories",
                data: "num=3",
                success: function (data) {
                    var result = "";
                    $("#dropdown_categories").html("");
                    $.each(data, function (i, item) {
                        result += "<li><a href=\"#\" onclick=\"getTopicsByCategoryId(" + item.categoryId + ")\">"
                                + "<div><p><strong>" + item.category + "</strong><span class=\"pull-right text-muted\">"
                                + item.completeRate + "% Complete</span> </p> <div class=\"progress progress-striped active\">"
                                + "<div class=\"progress-bar progress-bar-" + item.infoColor + " role=\"progressbar\" aria-valuenow="
                                + item.completeRate + " aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: "
                                + item.completeRate +"%\"> <span class=\"sr-only\">" + item.completeRate
                                + "% Complete</span> </div> </div> </div> </a> </li> <li class=\"divider\"></li>";

                    });
                    result += "<li><a class=\"text-center\" href=\"#\" onclick=\"listAllCategories()\"> <strong>See All Categories</strong>"
                                    + "<i class=\"fa fa-angle-right\"></i></a></li>";
                    $("#dropdown_categories").html(result);
                }
            });

            $("#s1 option:first,#s2 option:first").attr("selected", true);

            $("#s1").dblclick(function () {
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                so.get(so.length - 1).index == alloptions.length - 1 ? so.prev().attr("selected", true) : so.next().attr("selected", true);

                $("#s2").append(so);
            });

            $("#s2").dblclick(function () {
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                so.get(so.length - 1).index == alloptions.length - 1 ? so.prev().attr("selected", true) : so.next().attr("selected", true);

                $("#s1").append(so);
            });

            $("#add").click(function () {
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                so.get(so.length - 1).index == alloptions.length - 1 ? so.prev().attr("selected", true) : so.next().attr("selected", true);

                $("#s2").append(so);
            });

            $("#remove").click(function () {
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                so.get(so.length - 1).index == alloptions.length - 1 ? so.prev().attr("selected", true) : so.next().attr("selected", true);

                $("#s1").append(so);
            });

            $("#addall").click(function () {
                $("#s2").append($("#s1 option").attr("selected", true));
            });

            $("#removeall").click(function () {
                $("#s1").append($("#s2 option").attr("selected", true));
            });

            $("#s1up").click(function () {
                var so = $("#s1 option:selected");
                if (so.get(0).index != 0) {
                    so.each(function () {
                        $(this).prev().before($(this));
                    });
                }
            });

            $("#s1down").click(function () {
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                if (so.get(so.length - 1).index != alloptions.length - 1) {
                    for (i = so.length - 1; i >= 0; i--) {
                        var item = $(so.get(i));
                        item.insertAfter(item.next());
                    }
                }
            });

            $("#s2up").click(function () {
                var so = $("#s2 option:selected");
                if (so.get(0).index != 0) {
                    so.each(function () {
                        $(this).prev().before($(this));
                    });
                }
            });

            $("#s2down").click(function () {
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                if (so.get(so.length - 1).index != alloptions.length - 1) {
                    for (i = so.length - 1; i >= 0; i--) {
                        var item = $(so.get(i));
                        item.insertAfter(item.next());
                    }
                }
            });

            $("#s2top").click(function() {
                var so = $("#s2 option:selected");
                if (so.length > 0) {
                    for (i = so.length-1 ; i >= 0; i--) {
                        var item = $(so.get(i));
                        item.parent().prepend(item);
                    }
                }
            });

            $("#btn-addNode").click(function () {
                var input = document.getElementsByName("checkbox");
                for (k in input) {
                    if (input[k].checked) {
                        var val = input[k].value;
                        $.ajax({
                            type: "GET",
                            url: "searchTargetTopic",
                            data: "searchKey="+encodeURI(val),
                            success: function (data) {
                                if (!isEmptyObject(data)) {
                                    var title = showPreview(data.nodeId);
                                    var result = "<option title='" + title + "' value=\"" + data.nodeId +"\">" + data.topic + "</option>";
                                    $("#s1").append(result);
                                } else{
                                    alert("不存在该节点: " + val);
                                }
                            }
                        });
                    }
                }
                document.getElementById("btn-addNode-input").value = '';
                $("#hint_addTopic").html("");
            });

        });


        function showPreview(node_id) {
            var content = "";
            $.ajax({
                type: "GET",
                url: "getNodeContent",
                data: "nodeId=" + node_id,
                async: false,
                success: function (data) {
                    content = data[0];
                }
            });
            return content;
        }


        function isEmptyObject(e) {
            var t;
            for (t in e)
                return !1;
            return !0
        }

        function searchTopic(key) {
            getObjectById("hint_searchTopic").style.display = 'none';
            if(!arguments[0]) key = document.getElementById("text_searchTopic").value;
            $.ajax({
                type: "GET",
                url: "searchTopic",
                data: "searchKey="+key,
                success: function (data) {
                    var result = "";
                    $("#treeList").html("");
                    $.each(data, function (i, item) {
                        result += ("<li><a href='#topicId"+item.id+"' onclick=\"showDialogTree(" + item.id + ")\">"
                        + "<i class=\"fa fa-sitemap fa-fw\"></i>" + item.key + "</a></li>");
                    });
                    $("#treeList").html(result);
                }
            });
        }

        function showDialogTree(treeId) {
            $("#s1").html("");
            $("#s2").html("");
            $.ajax({
                type: "GET",
                url: "getLeafNodesByTopicId",
                data: "id=" + treeId,
                success: function (data) {
                    var topic = "";
                    leafNodeList = [];
                    $.each(data, function (i, item) {
                        topic = item.topic;
                        var conn = (item.hasConnect)?"<span style='color:green'>已关联</span>":"<span style='color:red'>未关联</span>";
                        var cont = "<a href='#' class='list-group-item' id='leafNode"+item.nodeId+"' onclick='getCandidates(" + item.nodeId +
                                ")'><span class='list-group-item-heading'>" + conn + " " + item.connectedNodeStr +"</span><p class='list-group-item-text text-muted small'>" + item.content + "</p></a>";
                        leafNodeList.push(cont);

                    });
                    $("#tree-title").html(topic);
                    $("#tree-id").html(treeId);
                    showLeafNodeList(leafNodeList);
                }
            });
        }

        function showLeafNodeList(list) {
            var content = "";
            for (var i = 0; i < list.length; i++) {
                content += list[i];
            }
            $("#leafNodePanel").html(content);
        }

        function getCandidates(id) {
            var newList = new Array();
            var newNode;
            for (var i = 0; i < leafNodeList.length; i++) {
                var node = leafNodeList[i];
                var start = node.indexOf("(");
                var end = node.indexOf(")");
                var nodeId = node.substring(start + 1, end);
                if (id == nodeId) {
                    newNode = node.replace(/class='list-group-item'/, "class='list-group-item' " +
                            "style='background-color:#f5f5f5'");
                } else {
                    newList.push(leafNodeList[i]);
                }
            }
            newList.push(newNode);
            showLeafNodeList(newList);
            // 更新左边候选列表
            $("#src-id").html(id);
            $.ajax({
                type: "GET",
                url: 'candidateNode',
                data: "id=" + id, // appears as $_GET['id'] @ your backend side
                success: function(data) {
                    // data is ur summary
                    var result="";
                    $.each(data, function(i, item) {
                        var detail = showPreview(item.nodeId);
                        result += "<option title='"+ detail + "' value='" + item.nodeId +"'>" + item.topic + "</option>";
                    });
                    $('#s1').html(result);
                    window.location.hash="#leafNode"+id;
                }
            });
            // 更新右边已关联列表
            $.ajax({
                type: "GET",
                url: 'connectedNode',
                data: "id=" + id,
                success: function (data) {
                    var result = "";
                    $.each(data, function (i, item) {
                        result += "<option value=\"" + item.nodeId + "\">" + item.topic + "</option>";
                    });
                    $("#s2").html(result);
                    window.location.hash="#leafNode"+id;
                }
            });
            window.location.hash="#leafNode"+id;
        }
        
        function saveRank() {
            var src_id = document.getElementById("src-id").innerText;
            var options = document.getElementById("s2");
            var result = new Array();
            var len = options.length;
            result.push(src_id);
            for (var i = 0; i < len; ++i) {
                result.push(options[i].value);
            }
            $.ajax({
                type: "POST",
                url: 'saveRank',
                data: "options=" + result,
                async: false
            });
            var treeId = document.getElementById("tree-id").innerText;
            showDialogTree(treeId);
            alert("保存成功");
        }

        var allData = "${allTopics}";
        var wordid = "text_searchTopic";
        var autoid = "hint_searchTopic";
        //词组分割：,
        var datas = allData.split(",");
        datas = datas.sort();
        datas = dislodgeRepeat(datas);
        //高亮的序号--第一个word的序号（ID）是0
        var highlightindex = -1;
        initHint("text_searchTopic", "hint_searchTopic");
        initHint("btn-addNode-input", "hint_addTopic");
        function initHint(wordid, autoid) {
            var wordInput = getObjectById(autoid);
            // 隐藏自动补全框,并定义css属性
            if (wordInput != null) {
                wordInput.style.position = "absolute";
                wordInput.style.border = "0px gray solid";
                wordInput.style.top = wordInput.offsetTop + wordInput.offserHeight + 5 + "px";
                wordInput.style.left = wordInput.offserLeft + "px";
                wordInput.style.width = getObjectById(wordid).offsetWidth + -1 + "px";
            }
        }
        // 给文本框添加键盘按下并弹起的事件
        function onKeyUp(event, wordid, autoid) {
            var myEvent = event || window.event;
            var keyCode = myEvent.keyCode;
            var oldWord = getObjectById(autoid).value;
            if((keyCode >= 65 && keyCode <= 90) || keyCode == 8 || keyCode == 46) {// 字母,退格或删除键
                showAutoWord(wordid, autoid);
            } else if(keyCode == 38 || keyCode == 40) {// 向上,向下
                var childNodes = getObjectById(autoid).childNodes;
                for(var j = 0; j < childNodes.length; j++) {
                    childNodes[j].style.backgroundColor = "white";
                }
                if(highlightindex > -1 && highlightindex < childNodes.length) {
                    if(keyCode == 38) {
                        highlightindex = highlightindex <= 0 ? 0 : --highlightindex;
                    } else if(keyCode == 40) {
                        highlightindex = highlightindex >= childNodes.length - 1 ? highlightindex : ++highlightindex;
                    }
                } else if(highlightindex == -1) {
                    if(keyCode == 38) {
                        highlightindex = childNodes.length - 1;
                    } else if(keyCode == 40) {
                        highlightindex = 0;
                    }
                } else {
                    highlightindex = -1;
                }
                childNodes[highlightindex].style.backgroundColor = "gray";
            } else if (keyCode == 13 && wordid == 'text_searchTopic') { // 回车键 && 搜索话题
                if (highlightindex != -1) {
                    var wordText = getObjectById(wordid).value;
                    var data = getResultData(wordText.trim());
                    var keyWord = data[highlightindex];
                    searchTopic(keyWord);
                    getObjectById(wordid).value = keyWord;
                } else{
                    searchTopic();
                }
                getObjectById(autoid).style.border = "0px black solid";
                getObjectById(autoid).innerHTML = "";
                highlightindex = -1;
            } else if(getObjectById(wordid).value != oldWord) {
                showAutoWord(wordid, autoid);
            }
        }
        //下拉框提示
        function showAutoWord(wordid, autoid) {
            getObjectById(autoid).style.display='block';
            getObjectById(autoid).style.border = "0px black solid";
            var autoNode = getObjectById(autoid);
            var wordText = getObjectById(wordid).value;
            oldWord = wordText;
            if(wordText != "") {
                var data = getResultData(wordText.trim());
                autoNode.innerHTML = "";
                //初始化提示数据
                if(data != null && data.length > 0){
                    getObjectById(autoid).style.border = "1px black solid";
                }
                for(var i = 0; i < data.length; i++) {
                    var wordNode = data[i];
                    var newDivNode = createElement("div");
                    newDivNode.id = i;
                    newDivNode.appendChild(document.createTextNode(wordNode));
                    autoNode.appendChild(newDivNode);
                    // 光标进入
                    newDivNode.onmouseover = function() {
                        var childNodes = getObjectById(autoid).childNodes;
                        for(var j = 0; j < childNodes.length; j++) {
                            childNodes[j].style.backgroundColor = "white";
                        }
                        this.style.backgroundColor = "gray";
                        highlightindex = this.id;
                    };
                    //光标移出
                    newDivNode.onmouseout = function() {
                        this.style.backgroundColor = "white";
                    };
                    // 光标点击
                    newDivNode.onclick = function() {
                        var comText = this.innerHTML;
                        getObjectById(autoid).innerHTML = "";
                        highlightindex = -1;
                        getObjectById(wordid).value = comText;
                        getObjectById(autoid).style.border = "0px black solid";
                        if (wordid == 'text_searchTopic') {
                            searchTopic(comText);
                        }
                    };
                }
            } else {//输入框为""
                autoNode.innerHTML = "";
                highlightindex = -1;
            }
        }

        function showCheckBox(wordid) {
            var wordText = getObjectById(wordid).value;
            if(wordText != "") {
                var data = getResultData(wordText.trim());
                $("#hint_addTopic").html("");
                var checkbox = "";
                for (var i = 0; i < data.length; i++) {
                    var d = data[i];
                    checkbox += "<div class='checkbox'><label><input type='checkbox' name='checkbox' value='"+d+"'>" + d +"</label></div>";
                }
                $("#hint_addTopic").html(checkbox);
            }
        }

        function onCheckBox(event, wordid, autoid) {
            var myEvent = event || window.event;
            var keyCode = myEvent.keyCode;
            var oldWord = getObjectById(autoid).value;
            if((keyCode >= 65 && keyCode <= 90) || keyCode == 8 || keyCode == 46) {// 字母,退格或删除键
                showCheckBox(wordid);
            }
            if(getObjectById(wordid).value != oldWord) {
                showCheckBox(wordid);
            }
        }

        function getObjectById(id) {
            return document.getElementById(id);
        }
        //根据输入词语，换回匹配的词语组
        function getResultData(wordText) {
            var data = new Array();
            for(var i = 0; i < datas.length; i++) {
                var index = datas[i].indexOf(wordText);
                if(index != -1) {
                    data.push(datas[i]);
                }
            }
            return data;
        }
        function createElement(tagName) {
            return document.createElement(tagName);
        }
        //去重
        function dislodgeRepeat(datas) {
            var newDatas = new Array();
            for(var i = 1; i < datas.length; i++) {
                if(datas[i] != datas[i - 1]) {
                    newDatas.push(datas[i]);
                }
            }
            return newDatas;
        }
        // 选中一个类别,根据类别id显示所有文案
        function getTopicsByCategoryId(category_id) {
            $.ajax({
                type: "GET",
                url: "getTopicsByCategoryIdOrdered",
                data: "categoryId=" + category_id,
                success: function (data) {
                    var result = "";
                    $("#treeList").html("");
                    $.each(data, function (i, item) {
                        result += ("<li><a href='#topicId"+item.id+"' id='dialogTree"+item.id+"' onclick=\"showDialogTree(" + item.id + ")\">"
                        + "<i class=\"fa fa-sitemap fa-fw\"></i>" + item.key + "</a></li>");
                    });
                    $("#treeList").html(result);
                }
            });
        }
        // 搜索类别
        function searchCategory() {
            var category = document.getElementById("input_searchCategory").value;
            $.ajax({
                type: "GET",
                url: "getTopicsByCategoryName",
                data: "categoryName=" + category,
                success: function (data) {
                    var result = "";
                    $("#treeList").html("");
                    $.each(data, function (i, item) {
                        result += ("<li><a href='#topicId"+item.id+"' onclick=\"showDialogTree(" + item.id + ")\">"
                        + "<i class=\"fa fa-sitemap fa-fw\"></i>" + item.key + "</a></li>");
                    });
                    $("#treeList").html(result);
                }
            });
        }

        // 列出所有类别
        function listAllCategories() {
            $.ajax({
                type: "GET",
                url: "listCategories",
                data: "num=20",
                success: function (data) {
                    var result = "";
                    $("#dropdown_categories").html("");
                    $.each(data, function (i, item) {
                        result += "<li><a href=\"#\" onclick=\"getTopicsByCategoryId(" + item.categoryId + ")\">"
                                + "<div><p><strong>" + item.category + "</strong><span class=\"pull-right text-muted\">"
                                + item.completeRate + "% Complete</span> </p> <div class=\"progress progress-striped active\">"
                                + "<div class=\"progress-bar progress-bar-" + item.infoColor + " role=\"progressbar\" aria-valuenow="
                                + item.completeRate + " aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: "
                                + item.completeRate +"%\"> <span class=\"sr-only\">" + item.completeRate
                                + "% Complete</span> </div> </div> </div> </a> </li> <li class=\"divider\"></li>";

                    });
                    $("#dropdown_categories").html(result);
                }
            });
        }

    </script>
</head>
<body>
<div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="<%=basePath%>index">基金查询系统</a>
    </div>
    <!-- /.navbar-header -->


    <ul class="nav navbar-top-links navbar-right">
        <!-- /.dropdown -->
        <%--<li class="dropdown">--%>
            <%--<a class="dropdown-toggle" data-toggle="dropdown" href="#">--%>
                <%--<i class="fa fa-tasks fa-fw"></i> <i class="fa fa-caret-down"></i>--%>
            <%--</a>--%>
            <%--<ul class="dropdown-menu dropdown-tasks" id="dropdown_categories" style="max-height: 420px; overflow-y: auto;">--%>
                <%--<li>--%>
                    <%--<a class="text-center" href="#" onclick="listAllCategories()">--%>
                        <%--<strong>See All Categories</strong>--%>
                        <%--<i class="fa fa-angle-right"></i>--%>
                    <%--</a>--%>
                <%--</li>--%>
            <%--</ul>--%>
            <%--<!-- /.dropdown-tasks -->--%>
        <%--</li>--%>

        <!-- /.dropdown -->
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-user">
                <%--<li><a href="<%=basePath%>graph"><i class="fa fa-bar-chart-o fa-fw"></i>关联图</a></li>--%>
                <%--<li class="divider"></li>--%>
                <li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                </li>
                <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                </li>
                <li class="divider"></li>
                <li><a href="#"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                </li>
            </ul>
            <!-- /.dropdown-user -->
        </li>
        <!-- /.dropdown -->
        <%--<li>--%>
            <%--<div class="search-container">--%>
                <%--<form class="form-inline float-sm-right">--%>
                    <%--<input class="form-control" id="input_searchCategory" type="text" placeholder="搜索类别..">--%>
                    <%--&lt;%&ndash;<span class="input-group-btn">&ndash;%&gt;--%>
                    <%--<button class="btn btn-default" type="button" id="btn_searchCategory" onclick="searchCategory()">--%>
                        <%--<i class="fa fa-search"></i></button>--%>
                    <%--&lt;%&ndash;</span>&ndash;%&gt;--%>
                    <%--&lt;%&ndash;<button class="btn btn-outline-success" type="submit">Search</button>&ndash;%&gt;--%>
                <%--</form>--%>
            <%--</div>--%>
        <%--</li>--%>
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <li class="sidebar-search">
                    <div class="input-group custom-search-form">
                        <input type="text" class="form-control" id="text_searchTopic" placeholder="搜索文案"
                               onkeyup="onKeyUp(event, 'text_searchTopic', 'hint_searchTopic')" >
                                <span class="input-group-btn">
                                <button class="btn btn-default" type="button" id="btn_searchTopic"
                                        onclick="searchTopic()">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                    </div>
                    <div id="hint_searchTopic" style="max-height: 200px;overflow-y: auto;display: none;"></div>
                    <!-- /input-group -->
                </li>
            </ul>
            <ul class="nav" id="treeList" style="max-height: 520px; overflow-y: auto;">

            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    </div>
    <!-- /.navbar-static-side -->
</nav>
    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h2 class="page-header" id="tree-title"></h2>
            </div>
            <div id="tree-id" style="display: none;"></div>
            <div id="src-id" style="display: none;"></div>
            <!-- /.col-lg-12 -->
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-tasks fa-fw"></i> 叶子节点
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <div class="list-group" id="leafNodePanel">

                        </div>
                        <!-- /.list-group -->
                    </div>
                    <!-- /.panel-body -->

                </div>
            </div>
            <div class="col-lg-12" id="nodeConnection">

                <table class="table table-bordered table-hover table-striped">
                    <tr>
                        <td width="45%">
                            <select name="s1" size="20" multiple="multiple" id="s1" style="width:100%"></select>

                            <div class="panel-footer">
                                <div class="input-group">
                                    <input id="btn-addNode-input" type="text" class="form-control input-sm"
                                           placeholder="输入要关联的节点..."
                                           onkeyup="onCheckBox(event, 'btn-addNode-input', 'hint_addTopic')" />
                                <span class="input-group-btn">
                                    <button class="btn btn-success btn-sm" id="btn-addNode">Add</button>
                                </span>
                                </div>
                                <div id="hint_addTopic" style="height: 220px; overflow-y: auto;"></div>
                            </div>
                        </td>
                        <td  align="center" width="5%">
                            <button class="btn btn-default" type="button" name="add" id="add"> >> </button><br/><br/>
                            <button class="btn btn-default" type="button" name="remove" id="remove"> << </button><br/><br/>
                            <button class="btn btn-success btn-sm" type="button" name="addall" id="addall">全选</button><br/><br/>
                            <button class="btn btn-danger btn-sm" name="removeall" id="removeall">全删</button></td>

                        <td width="45%">
                            <select name="s2" size="20" multiple="multiple" id="s2" style="width:100%"></select>
                        </td>
                        <td width="5%" align="center">
                            <button class="btn btn-default" name="s2top" id="s2top">置顶</button><br/><br/>
                            <button class="btn btn-default" name="s2up" id="s2up">上移</button><br/><br/>
                            <button class="btn btn-default" name="s2down" id="s2down">下移</button><br/><br/>
                            <button class="btn btn-success" name="save" id="save" onclick="saveRank()">保存</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

    </div>




</div>
<!-- Le javascript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->

<!-- jQuery -->
<script src='<c:url value="/resources/sbadmin/vendor/jquery/jquery.min.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/vendor/metisMenu/metisMenu.min.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/vendor/raphael/raphael.min.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/vendor/morrisjs/morris.min.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/data/morris-data.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/dist/js/sb-admin-2.js"></c:url>'></script>

<%--<!-- Bootstrap Core JavaScript -->--%>
<%--<script src="/resources/sbadmin/vendor/bootstrap/js/bootstrap.min.js"></script>--%>

<%--<!-- Metis Menu Plugin JavaScript -->--%>
<%--<script src="/resources/sbadmin/vendor/metisMenu/metisMenu.min.js"></script>--%>

<%--<!-- Morris Charts JavaScript -->--%>
<%--<script src="/resources/sbadmin/vendor/raphael/raphael.min.js"></script>--%>
<%--<script src="/resources/sbadmin/vendor/morrisjs/morris.min.js"></script>--%>
<%--<script src="/resources/sbadmin/data/morris-data.js"></script>--%>

<%--<!-- Custom Theme JavaScript -->--%>
<%--<script src="/resources/sbadmin/dist/js/sb-admin-2.js"></script>--%>

</body>
</html>