<%@ page language="java" contentType="text/html; charset=UTF-8" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.cqut.genhoo.ScriptLoader" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
ScriptLoader loader = new ScriptLoader(new String[]{"base","easyui","artDialog","childPage"});
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>权限管理</title>
<%=loader.cssFile()%>
<%=loader.scriptFile()%>
<style type="text/css">

</style>
</head>
<body>
	<div class="topbar">
        <div class="leftrace">
           <span class="location">当前位置：</span>
           <a href="admin/Permission/index" style="color:#333; font-size:12px;">权限</a>
        </div>
        <div class="arrow"></div>
        <div class="btnbar">
        	<a id="addBtn" href="javascript:;">添加</a> &nbsp; | &nbsp; <a href="javascript:;" id="deleteBtn">删除</a>
        </div>
    </div>
    
    <div class="content">
    	<table id="dataTable" width="100%"></table>	
    </div>
	
<script>
$(document).ready(function(){
	
	$('#dataTable').datagrid({
		url:"admin/Permission/list",
		rownumbers:true,
		fitColumns:true,
		pagination:true,
		height:308,
		columns:[[
			{checkbox:true},
			{field:'permissionID',title:'primary key',width:1},
			{field:'name',title:'权限点名称',width:1},
			{field:'key',title:'权限标识',width:1},
			{field:'module',title:'模块',width:1},
			{field:'remark',title:'备注',width:1},
			{field:'operator',title:'操作',width:1,formatter:function(value,row,index){
				return "<a href='javascript:void(0);' onclick=\"editFun("+row.permissionID+")\">编辑</a> | <a href='javascript:void(0);' onclick='deleteRow("+row.permissionID+")'>删除</a>" ;
			}}
		]],
		loadFilter:function(data){
			//console.info(data);
			if(data.ok){
				return data.grid;
			}else{
				alert(data.message);
				return false;
			}
		},
		onOpen:function(){
			//在面板第一加载成功的时候重新调整表格的宽度，让每一列更好的适应表格
			$('#dataTable').datagrid("resize");
		}
		
	});
	$(window).resize(function(){
		$('#dataTable').datagrid("resize");
	});
	
	$("#addBtn").click(function(){
		art.dialog.open('admin/Permission/initAdd', {
			width: 500,
			//height: 500,
		    fixed: true,
		    resize: true,
		    drag: true,
			title: '新增',
			lock: true,
			ok:function(){
				var validateResult = this.iframe.contentWindow.DialogInterface.validate();
				if(!validateResult){
					return false;
				}else{
					var data = this.iframe.contentWindow.DialogInterface.getData();
					$.post("admin/Permission/add",data,function(data){
			 			if(data.OK){
			 				$('#dataTable').datagrid("reload");
			 				CQUTDialog.showSuccess({
			 					message:data.message
			 				});
			 			}else{
			 				CQUTDialog.showError({
			 					message:data.message
			 				});
			 			}
			 		});
				}
			},
			cancelVal: '关闭',
		    cancel: true //为true等价于function(){}
		});
	});
	
	
	//删除 选中的行
	$("#deleteBtn").click(function(){
		//得到所有被选中的行
		var selections = $('#dataTable').datagrid("getSelections");

		var ids = [];
		for(var i=0;i<selections.length;i++){
			ids.push(selections[i].permissionID);
		}
		
		if(ids.length==0){
			alert("请选择需要删除的行。");
		}else{
			var r=confirm("确定要删除选中的数据吗");
			if(r){
				$.post("admin/Permission/deleteSelections",{selections:ids.join(",")},function(data){
					$('#dataTable').datagrid("reload");
				});
			}
		}
		
		
	});
	
});

//删除 
function deleteRow(permissionID){
	var r=confirm("确定要删除吗");
	if(r){
		$.post("admin/Permission/delete",{permissionID:permissionID},function(data){
			$('#dataTable').datagrid("reload");
		});
	}
}

//编辑
function editFun(permissionID){
	art.dialog.open("admin/Permission/initEdit?permissionID="+permissionID, {
		width: 500,
		//height: 500,
		title: '编辑',
		lock: true,
		ok:function(){
			var validateResult = this.iframe.contentWindow.DialogInterface.validate();
			if(!validateResult){
				return false;
			}else{
				var data = this.iframe.contentWindow.DialogInterface.getData();
				$.post("admin/Permission/edit",data,function(data){
		 			if(data.OK){
		 				$('#dataTable').datagrid("reload");
		 				CQUTDialog.showSuccess({
		 					message:data.message
		 				});
		 			}else{
		 				CQUTDialog.showError({
		 					message:data.message
		 				});
		 			}
		 		});
			}
		},
		cancelVal: '关闭',
	    cancel: true
	});
}	

</script>
</body>
</html>
