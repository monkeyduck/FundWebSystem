<%--
  Created by IntelliJ IDEA.
  User: llc
  Date: 16/11/2
  Time: 下午9:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <title>关联对话节点</title>
    <link type="text/css" href='<c:url value="/resources/bootstrap/css/bootstrap.css"></c:url>' rel="stylesheet"/>
    <script src='<c:url value="/resources/jquery-3.1.0.min.js"></c:url>'></script>
    <script src="<c:url value="/resources/bootstrap-3.3.5/js/bootstrap.js"></c:url>"></script>

    <!--[if lt IE 9]>
    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <script>
        $(function(){

            $("[data-toggle='tooltip']").tooltip();

            $("#s1 option:first,#s2 option:first").attr("selected",true);

            $("#s1").dblclick(function(){
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);

                $("#s2").append(so);
            });

            $("#s2").dblclick(function(){
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);

                $("#s1").append(so);
            });

            $("#add").click(function(){
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);

                $("#s2").append(so);
            });

            $("#remove").click(function(){
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                so.get(so.length-1).index == alloptions.length-1?so.prev().attr("selected",true):so.next().attr("selected",true);

                $("#s1").append(so);
            });

            $("#addall").click(function(){
                $("#s2").append($("#s1 option").attr("selected",true));
            });

            $("#removeall").click(function(){
                $("#s1").append($("#s2 option").attr("selected",true));
            });

            $("#s1up").click(function(){
                var so = $("#s1 option:selected");
                if(so.get(0).index!=0){
                    so.each(function(){
                        $(this).prev().before($(this));
                    });
                }
            });

            $("#s1down").click(function(){
                var alloptions = $("#s1 option");
                var so = $("#s1 option:selected");

                if(so.get(so.length-1).index!=alloptions.length-1){
                    for(i=so.length-1;i>=0;i--)
                    {
                        var item = $(so.get(i));
                        item.insertAfter(item.next());
                    }
                }
            });

            $("#s2up").click(function(){
                var so = $("#s2 option:selected");
                if(so.get(0).index!=0){
                    so.each(function(){
                        $(this).prev().before($(this));
                    });
                }
            });

            $("#s2down").click(function(){
                var alloptions = $("#s2 option");
                var so = $("#s2 option:selected");

                if(so.get(so.length-1).index!=alloptions.length-1){
                    for(i=so.length-1;i>=0;i--)
                    {
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
//            $("#btn_tooltip").tooltip('show');
            $("#second").hide(); //初始化的时候第二个下拉列表隐藏
            $("#first").change(function(){ //当第一个下拉列表变动内容时第二个下拉列表将会显示
                var parentId=$("#first").val();
                if(null!= parentId && ""!=parentId){
                    getCandidates(parentId);
                    $.getJSON("http://localhost/msg/getSecondTypesJson",{id:parentId},function(myJSON){
                        var options="";
                        if(myJSON.length>0){
                            options+="<option value=''>==请选择类型==</option>";
                            for(var i=0;i<myJSON.length;i++){
                                options+="<option value="+myJSON[i].id+">"+myJSON[i].name+"</option>";
                            }
                            $("#area").html(options);
                            $("#second").show();
                        }
                        else if(myJSON.length<=0){
                            $("#second").hide();
                        }
                    });
                }
                else{
                    $("#second").hide();
                }
            });
        });
        function getCandidates(id) {
            alert("click");
            // 更新左边候选列表
            $.ajax({
                type: "GET",
                url: 'candidateNode',
                data: "id=" + id, // appears as $_GET['id'] @ your backend side
                success: function(data) {
                    // data is ur summary
                    var result="";
                    $.each(data, function(i, item) {
                        result += "<option value=\"" + item +"\">" + item + "</option>";
                    });
                    $('#s1').html(result);
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
                        result += "<option value=\"" + item + "\">" + item + "</option>";
                    });
                    $("#s2").html(result);
                }
            });
        }

        function showNodesByTopic(topic){
            $.ajax({
                type: "GET",
                url: 'topicNode',
                data: "topic=" + topic,
                success: function (data) {
                    var result = "";
                    $.each(data, function(i, item){
                        result += "<tr><td>" + item.nodeId + "</td><td>" + item.topic + "</td>";
                        if (item.hasConnect){
                            result += "<td>已关联</td>";
                        }else{
                            result += "<td>未关联</td>";
                        }
                        result += "<td><button type=\"button\" class=\"btn btn-default\" onclick=\"getCandidates("
                                + item.nodeId + ")\">查看候选关联节点</button></td></tr>";
                    });
                    $("#table_topic").html(result);
                }
            });
        }
        function loadInfo() {
            $.getJSON("loadInfo", function(data) {
                $("#info").html("");//清空info内容
                $.each(data.comments, function(i, item) {
                    $("#info").append(
                        "<div>" + item.id + "</div>" +
                        "<div>" + item.nickname    + "</div>" +
                        "<div>" + item.content + "</div><hr/>");
                });
            });
        }

        function searchTopic(str)
        {
            var xmlhttp;
            if (str.length==0)
            {
                document.getElementById("txtHint").innerHTML="";
                return;
            }
            if (window.XMLHttpRequest)
            {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp=new XMLHttpRequest();
            }
            else
            {// code for IE6, IE5
                xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange=function()
            {
                if (xmlhttp.readyState==4 && xmlhttp.status==200)
                {
                    document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
                }
            }
            xmlhttp.open("GET","/ajax/gethint.asp?q="+str,true);
            xmlhttp.send();
        }
        var allData = "abide,by,The,one,thing,she,cannot,abide,is,lying,abnormal,abnormal,"
                + "behavior,abolish,abolish,old,custom,abrupt,an,abrupt,departure,"
                + "absolute,have,absolute,trust,in,sb,"
                + "absorb,A,sponge,absorbs,water,"
                + "A,flower,is,beautiful,,but,beauty,itself,is,abstract,"
                + "The,idea,that,number,14,brings,bad,luck,is,absurd,abuse,你好,是多少,是滴是滴,倒数第";
        var wordid = "word";
        var autoid = "auto";
        //词组分割：,
        var datas = allData.split(",");
        datas = datas.sort();
        datas = dislodgeRepeat(datas);
        //高亮的序号--第一个word的序号（ID）是0
        var highlightindex = -1;
        var wordInput = getObjectById(autoid);
        var oldWord = getObjectById(autoid).value;
        // 隐藏自动补全框,并定义css属性
        wordInput.style.position = "absolute";
        wordInput.style.border = "0px black solid";
        wordInput.style.top = wordInput.offsetTop + wordInput.offserHeight + 5 + "px";
        wordInput.style.left = wordInput.offserLeft + "px";
        wordInput.style.width = getObjectById(wordid).offsetWidth + -1 + "px";
        // 给文本框添加键盘按下并弹起的事件
        function onKeyUp(event) {
            var myEvent = event || window.event;
            var keyCode = myEvent.keyCode;
            if((keyCode >= 65 && keyCode <= 90) || keyCode == 8 || keyCode == 46) {// 字母,退格或删除键
                showAutoWord();
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
            } else if(getObjectById(wordid).value != oldWord) {
                showAutoWord();
            }
        }
        //下拉框提示
        function showAutoWord() {
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
                    };
                }
            } else {//输入框为""
                autoNode.innerHTML = "";
                highlightindex = -1;
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
                if(index == 0) {
                    data.push(datas[i]);
                }
                if(data.length >= 10) {
                    break;
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
    </script>
</head>

<body>

<div class="container">
    <!-- Main hero unit for a primary marketing message or call to action -->
    <div class="text-center" style="margin-bottom: 10px">
        <h2>对话节点关联工具</h2>
    </div>

    <div class="row" style="margin-bottom: 20px">
        <select style="float:left" class="selectpicker" id="topicSelect" onchange="showNodesByTopic(this.value)" style="width: 40px">
            <option value="">选择话题</option>
            <c:forEach items="${topicList}" var="topic">
                <option value="${topic}" <c:if test="${topic eq selectedTopic}">selected="selected"</c:if> >${topic}</option>
            </c:forEach>
        </select>
    </div>


    <div class="row">
        <table class="table table-striped" id="table_topic" cellpadding="1px" cellspacing="1px">

        </table>
    </div>
    <div class="row" style="margin-bottom: 20px">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <select name="leafNode" size="20" multiple="multiple" id="leafNode" onchange="getCandidates(this.value)" style="width:200px;"></select>
                </td>
                <td>
                    <select name="s1" size="20" multiple="multiple" id="s1" style=" width:200px;"></select>
                </td>
                <td width="70" align="center">
                    <button class="btn btn-default" type="button" name="add" id="add"> >> </button><br />
                    <button class="btn btn-default" type="button" name="remove" id="remove"> << </button><br/><br/>
                    <button class="btn btn-default" type="button" name="addall" id="addall">全选</button><br/>
                    <button class="btn btn-default" name="removeall" id="removeall">全删</button><br/></td>

                <td><select name="s2" size="20" multiple="multiple" id="s2" style=" width:200px;">
                </select></td>
                <td>
                    <button class="btn btn-default" name="s2top" id="s2top">置顶</button><br/><br/>
                    <button class="btn btn-default" name="s2up" id="s2up">上移</button><br/><br/><br>
                    <button class="btn btn-default" name="s2down" id="s2down">下移</button>
                </td>
            </tr>
        </table>
    </div>

    <div id="candidates"></div>
    <button type="button" id="button_candidates" onclick="getCandidates(2)">点击获取候选节点</button>

    <tr>
        <td align="right" width="30%"><span class="red">*</span>短信类型：</td>
        <td align="left">
            <select name='city' id='first'>
                <option value='-1'>==请选择类型==</option>
                <#list typeList as t>
                    <option value='${t.id}'>${t.name}</option>
                </#list>
            </select>

            <span id="second">
                <select id="area" name="msgTypeId">
                </select>
            </span>
        </td>
    </tr>
</div>
<input type="text" id="word" onkeyup="onKeyUp(event)" />
<input type="button" id="bt_sub" value="提交" />
<br />
<div id="auto" style=""></div>
<br>
<button id="btn_tooltip" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="right" title="Tooltip on right">Tooltip on right</button>
<select name="s2" size="20" multiple="multiple" id="select_test" style="width:100%">
    <option value='abc' data-toggle='tooltip' data-placement='right' title='Tooltip on right'>预览1</option>
    <option value='abc' data-toggle='tooltip' data-placement='right' title='Tooltip on right'>预览2</option>

</select>

</body>
</html>