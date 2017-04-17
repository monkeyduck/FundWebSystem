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
//    String serverPath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/";
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


    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/bootstrap/css/bootstrap.min.css"></c:url>'
          rel="stylesheet">
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/metisMenu/metisMenu.min.css"></c:url>'
          rel="stylesheet">
    <link type="text/css" href='<c:url value="/resources/sbadmin/dist/css/sb-admin-2.css"></c:url>' rel="stylesheet">
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/morrisjs/morris.css"></c:url>' rel="stylesheet">
    <link type="text/css" href='<c:url value="/resources/sbadmin/vendor/font-awesome/css/font-awesome.min.css"></c:url>'
          rel="stylesheet">


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src='<c:url value="/resources/sbadmin/vendor/jquery/jquery.min.js"></c:url>'></script>
    <script src='<c:url value="/resources/sbadmin/vendor/morrisjs/morris.min.js"></c:url>'></script>
    <script src='<c:url value="/resources/sbadmin/data/morris-data.js"></c:url>'></script>
    <script src='<c:url value="/resources/sbadmin/dist/js/sb-admin-2.js"></c:url>'></script>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

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
            <a class="navbar-brand" href="<%=basePath%>index">对话节点关联</a>
        </div>
        <!-- /.navbar-header -->


        <ul class="nav navbar-top-links navbar-right">
            <!-- /.dropdown -->

            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <li><a href="<%=basePath%>graph"><i class="fa fa-bar-chart-o fa-fw"></i>关联图</a></li>
                </ul>
                <!-- /.dropdown-user -->
            </li>
            <!-- /.dropdown -->
        </ul>
        <!-- /.navbar-top-links -->

        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
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
                <h2 class="page-header" id="tree-title">
                    {{treeTitle}}
                </h2>
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
                            <a href="javascript:void(0);" class="list-group-item" v-for="(info,index) in nodeInfoList"
                               @click="getCandidates(info.nodeId,index)"
                               v-bind:style="info.selected?{backgroundColor:'#f5f5f5'}:{}">
                                <span class="list-group-item-heading">
                                    <span v-bind:style="{color:info.hasConnect?'green':'red'}">
                                        {{ info.hasConnect?'已关联':'未关联' }}
                                    </span>
                                    {{ info.connectedNodeStr }}
                                </span>
                                <p class="list-group-item-text text-muted small">
                                    {{ info.content}}
                                </p>
                            </a>
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
                            <select name="s1" size="20" multiple="multiple" id="s1" style="width:100%" title="left"
                                    v-model="recommendSelected"
                                    @dblclick="move(recommendSelected,'recommendList','connectedList')">
                                <option v-for="r in recommendList" :title="r.content" :value="r.nodeId">
                                    {{ r.topic }}
                                </option>
                            </select>

                            <div class="panel-footer">
                                <div class="input-group">
                                    <input id="btn-addNode-input" type="text" class="form-control input-sm"
                                           placeholder="输入要关联的节点..."
                                    <%--onkeyup="onCheckBox(event, 'btn-addNode-input', 'hint_addTopic')"--%>
                                           v-model="searchTopicByKey"/>
                                    <span class="input-group-btn">
                                    <button class="btn btn-success btn-sm" id="btn-addNode"
                                            @click="addToRecommend">添加</button>
                                </span>
                                </div>
                                <div id="hint_addTopic" style="height: 220px; overflow-y: auto;">
                                    <div class='checkbox' v-for="s in searchTopicResult">
                                        <label>
                                            <input type='checkbox' name='checkbox' :value="s.nodeId"
                                                   v-model="s.checked"/>
                                            {{ s.topic }}
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td align="center" width="5%">
                            <button class="btn btn-default" type="button" name="add" id="add"
                                    @click="move(recommendSelected,'recommendList','connectedList')"> >>
                            </button>
                            <br/><br/>
                            <button class="btn btn-default" type="button" name="remove" id="remove"
                                    @click="move(connectedSelected,'connectedList','recommendList')">
                                <<
                            </button>
                            <br/><br/>
                            <button class="btn btn-success btn-sm" type="button" name="addall" id="addall"
                                    @click="moveAll('recommendList','connectedList')">
                                全选
                            </button>
                            <br/><br/>
                            <button class="btn btn-danger btn-sm" name="removeall" id="removeall"
                                    @click="moveAll('connectedList','recommendList')">
                                全删
                            </button>
                        </td>

                        <td width="45%">
                            <select name="s2" size="20" multiple="multiple" id="s2" style="width:100%" title="right"
                                    v-model="connectedSelected"
                                    @dblclick="move(connectedSelected,'connectedList','recommendList')">
                                <option v-for="c in connectedList" :title="c.content" :value="c.nodeId">
                                    {{ c.topic }}
                                </option>
                            </select>
                        </td>
                        <td width="5%" align="center">
                            <button class="btn btn-default" name="s2top" id="s2top" @click="top()">置顶</button>
                            <br/><br/>
                            <button class="btn btn-default" name="s2up" id="s2up" @click="up()">上移</button>
                            <br/><br/>
                            <button class="btn btn-default" name="s2down" id="s2down" @click="down()">下移</button>
                            <br/><br/>
                            <button class="btn btn-success" name="save" id="save" @click="saveRank()">保存</button>
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
<script src='<c:url value="/resources/sbadmin/vendor/metisMenu/metisMenu.min.js"></c:url>'></script>
<script src='<c:url value="/resources/sbadmin/vendor/raphael/raphael.min.js"></c:url>'></script>

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
<script src="http://cdn.bootcss.com/vue/2.2.4/vue.js"></script>
<script src="//cdn.jsdelivr.net/ramda/0.23.0/ramda.min.js"></script>
<script src="http://cdn.bootcss.com/lodash.js/4.17.4/lodash.js"></script>
<script>
    var vm = new Vue({
        el: '#wrapper',
        data: {
            topicId:${topicId},
            rootId:${rootId},
            treeTitle: '',
            nodeInfoList: [],
            srcId: -1,
            recommendList: [],
            connectedList: [],
            recommendSelected: [],
            connectedSelected: [],
            movePrediction: R.curry(function (list, r) {
                return R.contains(r.nodeId, list);
            }),
            searchTopicByKey: '',
            searchTopicResult: []
        },
        watch: {
            searchTopicByKey: function (newKey, oldKey) {
                this.searchTopicByInput();
            }
        },
        methods: {
            notInSet:function () {
                var set = R.flatten(arguments);
                return R.append(this.rootId,R.map(function (i) {
                    return i.nodeId;
                },set));
            },
            getCandidates: function (nodeId, index) {
                this.srcId = nodeId;
                var nodeList = vm.nodeInfoList;
                R.forEach(function (node) {
                    node['selected'] = false;
                }, nodeList);
                var clickedNode = nodeList.splice(index, 1);
                clickedNode[0]['selected'] = true;
                vm.nodeInfoList = R.concat(nodeList, clickedNode);
                $.ajax({
                    type: "GET",
                    url: 'connectedNode',
                    data: "id=" + nodeId
                }).then(function (data) {
                    console.log('connected:', data);
                    vm.connectedList = data;
                    return $.ajax({
                        type: "GET",
                        url: 'candidateNode',
                        data: "id=" + nodeId
                    })
                }).then(function (data) {
                    console.log('candidate:', data);
                    vm.recommendList = R.reject(function (r) {
                        return R.contains(r.nodeId, vm.notInSet(vm.connectedList))
                    }, data);
                })
            },
            move: function (selected, fromKey, toKey) {
                if (selected.length > 0) {
                    var from = vm[fromKey];
                    var to = vm[toKey];
                    var predict = this.movePrediction(selected);
                    var mvList = R.filter(predict, from);
                    var toIds = to;
                    mvList = R.reject(function (r) {
                        return R.contains(r.nodeId, toIds);
                    }, mvList);
                    vm[toKey] = R.concat(to, mvList);
                    vm[fromKey] = R.reject(predict, from);

                }
            },
            moveAll: function (fromKey, toKey) {
                vm[toKey] = R.concat(vm[toKey], vm[fromKey]);
                vm[fromKey] = [];
            },
            top: function () {
                var predict = this.movePrediction(vm.connectedSelected);
                var head = R.filter(predict, vm.connectedList);
                var tail = R.reject(predict, vm.connectedList);
                vm.connectedList = R.concat(head, tail);
            },
            up: function () {
                for (var i = 1; i < vm.connectedList.length; i++) {
                    var c = vm.connectedList[i];
                    if (R.contains(c.nodeId, this.connectedSelected)) {
                        var tmp = vm.connectedList[i - 1];
                        this.connectedList.splice(i - 1, 1, c);
                        this.connectedList.splice(i, 1, tmp);
                    }
                }
            },
            down: function () {
                for (var i = vm.connectedList.length - 2; i >= 0; i--) {
                    var c = vm.connectedList[i];
                    if (R.contains(c.nodeId, this.connectedSelected)) {
                        var tmp = vm.connectedList[i + 1];
                        this.connectedList.splice(i + 1, 1, c);
                        this.connectedList.splice(i, 1, tmp);
                    }
                }
            },
            saveRank: function () {
                if (this.srcId === -1) {
                    alert('请先选择一个节点');
                    return;
                }
                var result = R.concat([this.srcId],R.map(function (r) {
                    return r.nodeId;
                },R.reject(function (c) {
                    return R.contains(c.nodeId,vm.notInSet());
                },this.connectedList)));
                $.ajax({
                    type: "POST",
                    url: 'saveRank',
                    data: "options=" + result
                }).done(function () {
                    reloadTopic();
                    alert('保存成功');
                })
            },
            searchTopicByInput: _.debounce(function () {
                $.ajax({
                    type: 'GET',
                    url: 'fuzzySearchTargetTopic',
                    data: 'searchKey=' + this.searchTopicByKey
                }).done(function (data) {
                    console.log('searchResult:', data);
                    vm.searchTopicResult = R.reject(function (r) {
                        return R.contains(r.nodeId,vm.notInSet(vm.connectedList,vm.recommendList))
                    },data);
                })
            }, 500),
            addToRecommend: function () {
                var checked = R.filter(function (s) {
                    return s.checked
                }, this.searchTopicResult);
                var nodeSet = this.notInSet(this.recommendList);
                var notInRecommend = R.reject(function (c) {
                    return R.contains(c.nodeId, nodeSet);
                }, checked);
                if (notInRecommend.length < 1) {
                    alert('选择的结果已经包含在左边了');
                    return;
                }
                var tmp = R.forEach(function (n) {
                    delete n.checked;
                }, notInRecommend);
                this.recommendList = R.concat(this.recommendList, tmp);
            }
        }
    });
    $(function () {
        console.log('page_loaded');
        reloadTopic();
    });
    function reloadTopic() {
        $.ajax({
            type: "GET",
            url: "getLeafNodesByTopicId",
            data: "id=" + vm.topicId,
            success: function (data) {
                console.log(data);
                vm.nodeInfoList = data;
                vm.treeTitle = data[0]['topic'];
                vm.connectedList = [];
                vm.recommendList = [];
                vm.searchTopicByKey = '';
            }
        });
    }
</script>
</body>
</html>