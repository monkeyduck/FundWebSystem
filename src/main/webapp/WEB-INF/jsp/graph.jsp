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

        function searchTopic(key) {
            if(!arguments[0]) key = document.getElementById("text_searchTopic").value;
            $.ajax({
                type: "GET",
                url: "searchTopic",
                data: "searchKey="+key,
                success: function (data) {
                    var result = "";
                    $("#treeList").html("");
                    $.each(data, function (i, item) {
                        result += ("<li><a href='#' onclick=\"showGraph(" + item.id + ")\">"
                        + "<i class=\"fa fa-sitemap fa-fw\"></i>" + item.key + "</a></li>");
                    });
                    $("#treeList").html(result);
//                    document.getElementById("treeList").html(result);
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
                        result += ("<li><a href='#' onclick=\"showGraph(" + item.id + ")\">"
                        + "<i class=\"fa fa-sitemap fa-fw\"></i>" + item.key + "</a></li>");
                    });
                    $("#treeList").html(result);
                }
            });
        }

        // 显示关联节点网状图
        function showGraph(topic_id) {
            var myChart = echarts.init(document.getElementById('chartPanel'));
            var option = {
                tooltip : {
                    show : true,   //默认显示
                    showContent:true, //是否显示提示框浮层
                    trigger:'item',//触发类型，默认数据项触发
                    triggerOn:'click',//提示触发条件，mousemove鼠标移至触发，还有click点击触发
                    alwaysShowContent:false, //默认离开提示框区域隐藏，true为一直显示
                    showDelay:0,//浮层显示的延迟，单位为 ms，默认没有延迟，也不建议设置。在 triggerOn 为 'mousemove' 时有效。
                    hideDelay:200,//浮层隐藏的延迟，单位为 ms，在 alwaysShowContent 为 true 的时候无效。
                    enterable:false,//鼠标是否可进入提示框浮层中，默认为false，如需详情内交互，如添加链接，按钮，可设置为 true。
                    position:'right',//提示框浮层的位置，默认不设置时位置会跟随鼠标的位置。只在 trigger 为'item'的时候有效。
                    confine:false,//是否将 tooltip 框限制在图表的区域内。外层的 dom 被设置为 'overflow: hidden'，或者移动端窄屏，导致 tooltip 超出外界被截断时，此配置比较有用。
                    transitionDuration:0.4,//提示框浮层的移动动画过渡时间，单位是 s，设置为 0 的时候会紧跟着鼠标移动。
                },
                series : [ {
                    type : 'graph', //关系图
                    name : "节点关联", //系列名称，用于tooltip的显示，legend 的图例筛选，在 setOption 更新数据和配置项时用于指定对应的系列。
                    layout : 'force', //图的布局，类型为力导图，'circular' 采用环形布局，见示例 Les Miserables
                    legendHoverLink : true,//是否启用图例 hover(悬停) 时的联动高亮。
                    hoverAnimation : true,//是否开启鼠标悬停节点的显示动画
                    coordinateSystem : null,//坐标系可选
                    xAxisIndex : 0, //x轴坐标 有多种坐标系轴坐标选项
                    yAxisIndex : 0, //y轴坐标
                    force : { //力引导图基本配置
                        //initLayout: ,//力引导的初始化布局，默认使用xy轴的标点
                        repulsion : 100,//节点之间的斥力因子。支持数组表达斥力范围，值越大斥力越大。
                        gravity : 0.03,//节点受到的向中心的引力因子。该值越大节点越往中心点靠拢。
                        edgeLength :80,//边的两个节点之间的距离，这个距离也会受 repulsion。[10, 50] 。值越小则长度越长
                        layoutAnimation : true
                        //因为力引导布局会在多次迭代后才会稳定，这个参数决定是否显示布局的迭代动画，在浏览器端节点数据较多（>100）的时候不建议关闭，布局过程会造成浏览器假死。
                    },
                    roam : true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
                    nodeScaleRatio : 0.6,//鼠标漫游缩放时节点的相应缩放比例，当设为0时节点不随着鼠标的缩放而缩放
                    draggable : true,//节点是否可拖拽，只在使用力引导布局的时候有用。
                    focusNodeAdjacency : true,//是否在鼠标移到节点上的时候突出显示节点以及节点的边和邻接节点。
                    //symbol:'roundRect',//关系图节点标记的图形。ECharts 提供的标记类型包括 'circle'(圆形), 'rect'（矩形）, 'roundRect'（圆角矩形）, 'triangle'（三角形）, 'diamond'（菱形）, 'pin'（大头针）, 'arrow'（箭头）  也可以通过 'image://url' 设置为图片，其中 url 为图片的链接。'path:// 这种方式可以任意改变颜色并且抗锯齿
                    //symbolSize:10 ,//也可以用数组分开表示宽和高，例如 [20, 10] 如果需要每个数据的图形大小不一样，可以设置为如下格式的回调函数：(value: Array|number, params: Object) => number|Array
                    //symbolRotate:,//关系图节点标记的旋转角度。注意在 markLine 中当 symbol 为 'arrow' 时会忽略 symbolRotate 强制设置为切线的角度。
                    //symbolOffset:[0,0],//关系图节点标记相对于原本位置的偏移。[0, '50%']
                    edgeSymbol : [ 'none', 'none' ],//边两端的标记类型，可以是一个数组分别指定两端，也可以是单个统一指定。默认不显示标记，常见的可以设置为箭头，如下：edgeSymbol: ['circle', 'arrow']
                    edgeSymbolSize : 10,//边两端的标记大小，可以是一个数组分别指定两端，也可以是单个统一指定。
                    itemStyle : {//===============图形样式，有 normal 和 emphasis 两个状态。normal 是图形在默认状态下的样式；emphasis 是图形在高亮状态下的样式，比如在鼠标悬浮或者图例联动高亮时。
                        normal : { //默认样式
                            label : {
                                show : true
                            },
                            borderType : 'solid', //图形描边类型，默认为实线，支持 'solid'（实线）, 'dashed'(虚线), 'dotted'（点线）。
//                            borderColor : 'rgba(255,215,0,0.4)', //设置图形边框为淡金色,透明度为0.4
                            borderWidth : 2, //图形的描边线宽。为 0 时无描边。
                            opacity : 1
                            // 图形透明度。支持从 0 到 1 的数字，为 0 时不绘制该图形。默认0.5

                        },
                        emphasis : {//高亮状态

                        }
                    },
                    lineStyle : { //==========关系边的公用线条样式。
                        normal : {
//                            color : 'rgba(255,0,255,0.4)',
                            width : '2',
                            type : 'solid', //线的类型 'solid'（实线）'dashed'（虚线）'dotted'（点线）
                            curveness : 0, //线条的曲线程度，从0到1
                            opacity : 1
                            // 图形透明度。支持从 0 到 1 的数字，为 0 时不绘制该图形。默认0.5
                        },
                        emphasis : {//高亮状态

                        }
                    },
                    label : { //=============图形上的文本标签
                        normal : {
                            show : true,//是否显示标签。
                            position : 'inside',//标签的位置。['50%', '50%'] [x,y]
                            textStyle : { //标签的字体样式
//                                color : '#cde6c7', //字体颜色
                                color : '#000000', // 纯黑色
                                fontStyle : 'normal',//文字字体的风格 'normal'标准 'italic'斜体 'oblique' 倾斜
                                fontWeight : 'bolder',//'normal'标准'bold'粗的'bolder'更粗的'lighter'更细的或100 | 200 | 300 | 400...
                                fontFamily : 'sans-serif', //文字的字体系列
                                fontSize : 10, //字体大小
                            }
                        },
                        emphasis : {//高亮状态

                        }
                    },
                    edgeLabel : {//==============线条的边缘标签
                        normal : {
                            show : false
                        },
                        emphasis : {//高亮状态

                        }
                    }
                } ]
            };
            myChart.setOption(option);
            myChart.showLoading();
            $.get('getGraphData?topicId='+topic_id).done(function (data) {
                myChart.hideLoading();
                myChart.setOption({
                    legend : { //=========圖表控件
                        show : true,
                        data : data.categories
                    },
                    series: [{
                        // 根据名字对应到相应的系列
                        data: data.data,
                        links: data.links,
                        categories: data.categories
                    }]
                });
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
            <a class="navbar-brand" href="/graph">关联网状图</a>
        </div>
        <!-- /.navbar-header -->


        <ul class="nav navbar-top-links navbar-right">
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-tasks fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-tasks" id="dropdown_categories">
                    <c:forEach items="${categoryInfo}" var="categ">
                        <li>
                            <a href="#" onclick="getRandomTopic(${categ.categoryId})">
                                <div>
                                    <p>
                                        <strong>${categ.category}</strong>
                                        <span class="pull-right text-muted">${categ.completeRate}% Complete</span>
                                    </p>
                                    <div class="progress progress-striped active">
                                        <div class="progress-bar progress-bar-${categ.infoColor}" role="progressbar" aria-valuenow="${categ.completeRate}" aria-valuemin="0" aria-valuemax="100" style="width: ${categ.completeRate}%">
                                            <span class="sr-only">${categ.completeRate}% Complete</span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                    </c:forEach>

                    <li>
                        <a class="text-center" href="#" onclick="listAllCategories()">
                            <strong>See All Categories</strong>
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </li>
                </ul>
                <!-- /.dropdown-tasks -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-bell fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-alerts">
                    <li>
                        <a class="text-center" href="/index">
                            <strong>回到节点关联</strong>
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </li>
                </ul>
                <!-- /.dropdown-alerts -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                    </li>
                    <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                    </li>
                    <li class="divider"></li>
                    <li><a href="login.html"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                    </li>
                </ul>
                <!-- /.dropdown-user -->
            </li>
            <!-- /.dropdown -->
            <li>
                <div class="search-container">
                    <form class="form-inline float-sm-right">
                        <input class="form-control" id="input_searchCategory" type="text" placeholder="搜索类别..">
                        <%--<span class="input-group-btn">--%>
                        <button class="btn btn-default" type="button" id="btn_searchCategory" onclick="searchCategory()">
                            <i class="fa fa-search"></i></button>
                        <%--</span>--%>
                        <%--<button class="btn btn-outline-success" type="submit">Search</button>--%>
                    </form>
                </div>
            </li>
        </ul>
        <!-- /.navbar-top-links -->

        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="sidebar-search">
                        <div class="input-group custom-search-form">
                            <input type="text" class="form-control" id="text_searchTopic" placeholder="搜索文案" >
                                <span class="input-group-btn">
                                <button class="btn btn-default" type="button" id="btn_searchTopic"
                                        onclick="searchTopic()">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                        </div>
                        <!-- /input-group -->
                    </li>
                </ul>
                <ul class="nav" id="treeList">

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
            <div class="col-lg-12" id="chartPanel" style="height:500px;">

            </div>
            <!-- /.col-lg-12 -->
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
<%--引入echarts--%>
<script src='<c:url value="/resources/echarts.js"></c:url>'></script>

<%--<script src="//cdn.bootcss.com/echarts/3.3.2/echarts.common.js"></script>--%>

</body>
</html>