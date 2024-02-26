<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>webd - 轻量级简易网盘</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
.close {
    background: red;
    color: black;
    border-radius: 12px;
    line-height: 18px;
    text-align: center;
    height: 18px;
    width: 18px;
    font-size: 16px;
    padding: 1px;
    top: -10px;
    right: -10px;
    position: absolute;
}
.close::before {
    content: "\2716";
}
.contentM_qis {
    position: fixed;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius:10px;
    z-index: 10;
    background-color:#2B373B;
    /*margin-left: -100px;*/
    top: 100px;
    width:755px;
    return height:auto;
    box-shadow: 3px 3px 10px #000;
    background: rgba(0,0,0,0.85);
    display:none;
}
.user_title{
    text-align:center;
    font-size:18px;
    color:#99FF00;
    padding:10px;
    font-weight:bold;
}
.webd_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:auto;
}
.webd_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:auto;
}
#webd_config {
	width:99%;
	font-family:'Lucida Console';
	font-size:12px; background:#475A5F;
	color:#FFFFFF;
	text-transform:none;
	margin-top:5px;
	overflow:scroll;
}
.formbottomdesc {
    margin-top:10px;
    margin-left:10px;
}
input[type=button]:focus {
    outline: none;
}
</style>
<script>
var db_webd = {};
var params_input = ["webd_cron_time", "webd_cron_hour_min", "webd_port", "webd_file_path", "webd_bin_path", "webd_cron_type", "webd_user1_name", "webd_user1_pass", "webd_user2_name", "webd_user2_pass"]
var params_check = ["webd_enable", "webd_ipv6_enable", "webd_trash_enable", "webd_fk_file", "webd_dq_file", "webd_lb_file", "webd_sc_file", "webd_yd_file", "webd_yc_file", "webd_mt_file", "webd_user1_file", "webd_dq1_file", "webd_lb1_file", "webd_sc1_file", "webd_yd1_file", "webd_yc1_file", "webd_mt1_file", "webd_user2_file", "webd_dq2_file", "webd_lb2_file", "webd_sc2_file", "webd_yd2_file", "webd_yc2_file", "webd_mt2_file"]
function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	conf2obj();
	get_status();
	buildswitch();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/webd",
		dataType: "json",
		async: false,
		success: function(data) {
			db_webd = data.result[0];
			conf2obj();
		}
	});
}
function conf2obj() {
	//input
	for (var i = 0; i < params_input.length; i++) {
		if(db_webd[params_input[i]]){
			E(params_input[i]).value = db_webd[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_webd[params_check[i]]){
			E(params_check[i]).checked = db_webd[params_check[i]] == 1 ? true : false
		}
	}
}
function get_webd_log() {
	$.ajax({
		url: '/_temp/webd.log',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
            if (res.length == 0){
			 E("logtxt").value = "日志文件为空或程序未启动";
            get_webd_log(); 
			}else{ $('#logtxt').val(res); }
		}
	});
}
function open_conf(open_conf) {
	if (open_conf == "webd_log") {
		get_webd_log();
	}
	$("#" + open_conf).fadeIn(200);
}
function close_conf(close_conf) {
	$("#" + close_conf).fadeOut(200);
}
function clear_log() {
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "webd_config.sh", "params": ["clearlog"], "fields": db_webd };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
			}
		}
	});
}
function get_status() {
        var webButton = document.querySelector('.webd_btn');
		var postData = {
			"id": parseInt(Math.random() * 100000000),
			"method": "webd_status.sh",
			"params": [],
			"fields": ""
		};
		$.ajax({
			type: "POST",
			cache: false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				E("status").innerHTML = response.result;
				if (response.result.includes("运行中")) {
                webButton.style.display = 'block'; 
                } else {
                webButton.style.display = 'none'; 
                }
				setTimeout("get_status();", 10000);
			},
			error: function() {
			    webButton.style.display = 'none';
				setTimeout("get_status();", 5000);
			}
		});
	}


// 打开 web 界面的函数
function openWebInterface() {
    var webd_port = document.getElementById('webd_port').value;
    var webUiHref = "http://" + window.location.hostname + ":" + webd_port;
    window.open(webUiHref, '_blank');
}
function buildswitch() {
	$("#webd_enable").click(
	function() {
		if (E('webd_enable').checked) {
			document.form.webd_enable.value = 1;
		} else {
			document.form.webd_enable.value = 0;
		}
	});

	$("#webd_ipv6_enable").click(
	function() {
		if (E('webd_ipv6_enable').checked) {
			document.form.webd_ipv6_enable.value = 1;
		} else {
			document.form.webd_ipv6_enable.value = 0;
		}
	});

	$("#webd_trash_enable").click(
	function() {
		if (E('webd_trash_enable').checked) {
			document.form.webd_trash_enable.value = 1;
		} else {
			document.form.webd_trash_enable.value = 0;
		}
	});

	$("#webd_fk_file").click(
	function() {
		if (E('webd_fk_file').checked) {
			document.form.webd_fk_file.value = 1;
		} else {
			document.form.webd_fk_file.value = 0;
		}
	});

	$("#webd_dq_file").click(
	function() {
		if (E('webd_dq_file').checked) {
			document.form.webd_dq_file.value = 1;
		} else {
			document.form.webd_dq_file.value = 0;
		}
	});

	$("#webd_lb_file").click(
	function() {
		if (E('webd_lb_file').checked) {
			document.form.webd_lb_file.value = 1;
		} else {
			document.form.webd_lb_file.value = 0;
		}
	});

	$("#webd_sc_file").click(
	function() {
		if (E('webd_sc_file').checked) {
			document.form.webd_sc_file.value = 1;
		} else {
			document.form.webd_sc_file.value = 0;
		}
	});

	$("#webd_yd_file").click(
	function() {
		if (E('webd_yd_file').checked) {
			document.form.webd_yd_file.value = 1;
		} else {
			document.form.webd_yd_file.value = 0;
		}
	});

	$("#webd_yc_file").click(
	function() {
		if (E('webd_yc_file').checked) {
			document.form.webd_yc_file.value = 1;
		} else {
			document.form.webd_yc_file.value = 0;
		}
	});

	$("#webd_mt_file").click(
	function() {
		if (E('webd_mt_file').checked) {
			document.form.webd_mt_file.value = 1;
		} else {
			document.form.webd_mt_file.value = 0;
		}
	});

	$("#webd_user1_file").click(
	function() {
		if (E('webd_user1_file').checked) {
			document.form.webd_user1_file.value = 1;
		} else {
			document.form.webd_user1_file.value = 0;
		}
	});

	$("#webd_dq1_file").click(
	function() {
		if (E('webd_dq1_file').checked) {
			document.form.webd_dq1_file.value = 1;
		} else {
			document.form.webd_dq1_file.value = 0;
		}
	});

	$("#webd_lb1_file").click(
	function() {
		if (E('webd_lb1_file').checked) {
			document.form.webd_lb1_file.value = 1;
		} else {
			document.form.webd_lb1_file.value = 0;
		}
	});

	$("#webd_sc1_file").click(
	function() {
		if (E('webd_sc1_file').checked) {
			document.form.webd_sc1_file.value = 1;
		} else {
			document.form.webd_sc1_file.value = 0;
		}
	});

	$("#webd_yd1_file").click(
	function() {
		if (E('webd_yd1_file').checked) {
			document.form.webd_yd1_file.value = 1;
		} else {
			document.form.webd_yd1_file.value = 0;
		}
	});

	$("#webd_yc1_file").click(
	function() {
		if (E('webd_yc1_file').checked) {
			document.form.webd_yc1_file.value = 1;
		} else {
			document.form.webd_yc1_file.value = 0;
		}
	});

	$("#webd_mt1_file").click(
	function() {
		if (E('webd_mt1_file').checked) {
			document.form.webd_mt1_file.value = 1;
		} else {
			document.form.webd_mt1_file.value = 0;
		}
	});

	$("#webd_user2_file").click(
	function() {
		if (E('webd_user2_file').checked) {
			document.form.webd_user2_file.value = 1;
		} else {
			document.form.webd_user2_file.value = 0;
		}
	});

	$("#webd_dq2_file").click(
	function() {
		if (E('webd_dq2_file').checked) {
			document.form.webd_dq2_file.value = 1;
		} else {
			document.form.webd_dq2_file.value = 0;
		}
	});

	$("#webd_lb2_file").click(
	function() {
		if (E('webd_lb2_file').checked) {
			document.form.webd_lb2_file.value = 1;
		} else {
			document.form.webd_lb2_file.value = 0;
		}
	});

	$("#webd_sc2_file").click(
	function() {
		if (E('webd_sc2_file').checked) {
			document.form.webd_sc2_file.value = 1;
		} else {
			document.form.webd_sc2_file.value = 0;
		}
	});

	$("#webd_yd2_file").click(
	function() {
		if (E('webd_yd2_file').checked) {
			document.form.webd_yd2_file.value = 1;
		} else {
			document.form.webd_yd2_file.value = 0;
		}
	});

	$("#webd_yc2_file").click(
	function() {
		if (E('webd_yc2_file').checked) {
			document.form.webd_yc2_file.value = 1;
		} else {
			document.form.webd_yc2_file.value = 0;
		}
	});

	$("#webd_mt2_file").click(
	function() {
		if (E('webd_mt2_file').checked) {
			document.form.webd_mt2_file.value = 1;
		} else {
			document.form.webd_mt2_file.value = 0;
		}
	});
}

function updateElementValues() {
  var webdEnableChecked = document.getElementById("webd_enable").checked;

  if (webdEnableChecked) { 
    if (
      document.getElementById("webd_fk_file").checked &&
      !document.getElementById("webd_dq_file").checked &&
      !document.getElementById("webd_lb_file").checked &&
      !document.getElementById("webd_sc_file").checked &&
      !document.getElementById("webd_yd_file").checked &&
      !document.getElementById("webd_yc_file").checked &&
      !document.getElementById("webd_mt_file").checked
    ) {
      document.getElementById("webd_dq_file").checked = true;
      document.getElementById("webd_lb_file").checked = true;
    }
  }
}


function save() {
	    if (trim(E("webd_enable").value) == "1") {
		   if (trim(E("webd_file_path").value) == "") {
			alert("未填写作为服务器的本地文件路径，请填写正确的文件路径！");
			return false;
		    }
			if (trim(E("webd_bin_path").value) == "") {
			alert("未填写webd的二进制程序文件路径，请填写正确的文件路径以及文件名，且文件名必须是webd！");
			return false;
		    }
			if (trim(E("webd_fk_file").value) == "1") { 
			   if (trim(E("webd_dq_file").value) == "" && trim(E("webd_lb_file").value) == "" && trim(E("webd_sc_file").value) == "" && trim(E("webd_yd_file").value) == "" && trim(E("webd_yc_file").value) == "" && trim(E("webd_mt_file").value) == "") {
			       alert("启用了访客，请至少勾选一项用户权限！");
			      return false;
		          }
		    }
			if (trim(E("webd_user1_file").value) == "1") { 
			   if (trim(E("webd_user1_name").value) == "" || trim(E("webd_user1_pass").value) == "") {
			       alert("启用了自定义用户2，但是未填写帐号或者密码，请填写正确的帐号或密码！");
			      return false;
		          }
		    }
			if (trim(E("webd_user2_file").value) == "1") { 
			     if (trim(E("webd_user2_name").value) == "" || trim(E("webd_user2_pass").value) == "") {
			       alert("启用了自定义用户3，但是未填写帐号或者密码，请填写正确的帐号或密码！");
			      return false;
		          }
		    }
			if (trim(E("webd_port").value) == "") {
			alert("webd监听端口未填写，请填写正确的监听端口！");
			return false;
		    }
		}
		if(E("webd_cron_time").value == "0"){
		    E("webd_cron_hour_min").value = "";
		    E("webd_cron_type").value = "";
		}
		updateElementValues();
	showLoading(3);

	//input
	for (var i = 0; i < params_input.length; i++) {
		if (trim(E(params_input[i]).value) && trim(E(params_input[i]).value) != db_webd[params_input[i]]) {
			db_webd[params_input[i]] = trim(E(params_input[i]).value);
		}else if (!trim(E(params_input[i]).value) && db_webd[params_input[i]]) {
			db_webd[params_input[i]] = "";
            }
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
        if (E(params_check[i]).checked != db_webd[params_check[i]]){
            db_webd[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
        }
	}
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "webd_config.sh", "params": [1], "fields": db_webd };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				refreshpage();
			}
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "软件中心", "离线安装", "webd");
	tablink[tablink.length - 1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_webd.asp");
}

function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";
	 if (itemNum == 1) {
		statusmenu = "启用webd轻量级文件服务器。";
		_caption = " webd开关";
	} else if (itemNum == 2) {
		statusmenu = " 显示 webd 的进程状态及 pid值。";
		_caption = " 运行状态";
	} else if (itemNum == 3) {
		statusmenu = "定时执行操作。<font color='#F46'>检查：</font>检查webd的进程是否存在，若不存在则重新启动；<font color='#F46'>重启：</font>重新启动webd进程，而不论当时是否在正常运行。重新启动服务会导致文件服务器短暂的无法访问.<br><font color='#F46'>注意：</font>填写内容为 0 关闭定时功能！<br/>建议：选择分钟填写“60的因数”【1、2、3、4、5、6、10、12、15、20、30、60】，选择小时填写“24的因数”【1、2、3、4、6、8、12、24】。";
		_caption = "定时功能";
	} else if (itemNum == 4) {
		statusmenu = "显示webd目前运行的启动参数。";
		_caption = "启动参数";
	} else if (itemNum == 5) {
		statusmenu = "指定webd的ipv4监听端口";
		_caption = " IPV4端口";
	} else if (itemNum == 6) {
		statusmenu = "同时监听ipv6端口。";
		_caption = " IPV6端口";
	} else if (itemNum == 7) {
		statusmenu = "指定作为文件服务器的本地文件路径。";
		_caption = "指定文件路径";
	} else if (itemNum == 8) {
		statusmenu = " 指定webd二进制程序的存放路径，必须填写完整的路径和文件名，且文件名必须是webd";
		_caption = " 程序路径";
	} else if (itemNum == 9) {
		statusmenu = "允许自动创建回收站文件夹，否则在访问文件服务器的时候无法不能删除文件。";
		_caption = "回收站功能";
	} else if (itemNum == 10) {
		statusmenu = "设置运行访问的用户，启用访客访问，将不需要帐号密码即可访问你的文件，目前只支持三个用户。<br><font color='#F46'>注意：</font>启用访客 至少要勾选一个后面的用户权限！";
		_caption = "启用/停用";
	} else if (itemNum == 11) {
		statusmenu = " 设置用户的登录帐号";
		_caption = "用户列表";
	} else if (itemNum == 12) {
		statusmenu = "设置用户的登录密码";
		_caption = "用户密码";
	} else if (itemNum == 13) {
		statusmenu = "允许访问读取下载服务器的文件";
		_caption = "读取权限";
	} else if (itemNum == 14) {
		statusmenu = "允许获取服务器的文件列表";
		_caption = "文件列表";
	} else if (itemNum == 15) {
		statusmenu = "允许上传文件到服务器";
		_caption = "上传文件";
	} else if (itemNum == 16) {
		statusmenu = "允许删除或移动服务器的文件";
		_caption = "删除移动";
	} else if (itemNum == 17) {
		statusmenu = "允许可以查看服务器里的隐藏文件";
		_caption = "查看隐藏文件";
	} else if (itemNum == 18) {
		statusmenu = " 允许可以播放服务器里的媒体文件";
		_caption = "播放媒体";
	}
	return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	var tag_name = document.getElementsByTagName('a');
	for (var i = 0; i < tag_name.length; i++)
		tag_name[i].onmouseout = nd;
	if (helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if (hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else {
		if (hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=webd" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_webd.asp"/>
<input type="hidden" name="next_page" value="Module_webd.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" valign="top">
                        <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">
                            <tr>
                                <td bgcolor="#4D595D" colspan="3" valign="top">
                                    <div>&nbsp;</div>
                                    <div style="float:left;" class="formfonttitle">webd - 轻量级简易网盘</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc">webd 是一个轻量级(self-hosted)自建网盘软件。【主页链接：<a href="https://webd.cf/" target="_blank"><em><u>webd.cf</u></em></a>】【下载地址：<a href="https://cnt2.cf/fidx.html#/webd/" target="_blank"><em><u>cnt2.cf</u></em></a>】<br/><i>* 点击参数设置的文字，可查看帮助信息 *</i> </div>
                                    <div id="webd_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">开启webd</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="webd_enable">
                                                        <input id="webd_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <a type="button" class="webd_btn" style="cursor:pointer; display: none;padding-top:5px;margin-left:10px;margin-top:0px;float: left;" href="javascript:void(0);" onclick="openWebInterface()">WEB界面</a>
                                            </td>
                                        </tr>
                                        <tr id="webd_status">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>
                                       
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">定时功能(<i>0为关闭</i>)</a></th>
                                            <td>
                                                每 <input type="text" oninput="this.value=this.value.replace(/[^\d]/g, '')" id="webd_cron_time" name="webd_cron_time" class="input_3_table" maxlength="2" value="0" placeholder="" />
                                                <select id="webd_cron_hour_min" name="webd_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 
                                                    <select id="webd_cron_type" name="webd_cron_type" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                        <option value="watch">检查</option>
                                                        <option value="start">重启</option>
                                                    </select> 一次服务
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(26)">程序启动日志</th>
                                            <td>
                                                <a type="button" class="webd_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('webd_log');" >日志</a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">监听端口</a></th>
                                            <td>
                                        <input type="text" oninput="this.value=this.value.replace(/[^\d-]/g, ''); if(value>65535)value=65535" class="input_ss_table" id="webd_port" name="webd_port" maxlength="6" value="" placeholder="7777" />
                                            </td>
                                        </tr>
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">监听IPV6</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="webd_ipv6_enable">
                                                        <input id="webd_ipv6_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">本地路径</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="webd_file_path" name="webd_file_path"  value="" placeholder="" />
                                            </td>
                                        </tr>
										<tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">程序路径</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="webd_bin_path" name="webd_bin_path"  value="" placeholder="" />
                                            </td>
                                        </tr>
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">回收站</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="webd_trash_enable">
                                                        <input id="webd_trash_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>  
                                            </td>
                                        </tr>
										</tr>

                                        
                                    </table>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="10">用户设置</td>
                                              </tr>
                                          </thead>

                                          <tr>
										  <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">启用</a></th>
                                            <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">用户名</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">密码</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">读取文件</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">获取文件列表</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">上传文件</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">删除或移动文件</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">显示隐藏文件</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">播放媒体</a></th>
                                          
                                          </tr>
                                          <tr>
										   <td>
										     <input type="checkbox" id="webd_fk_file" name="webd_fk_file">
                                        </td>
                                        <td>
                                            访客
                                        </td>
                                         <td>
                                           无需账号密码
                                        </td>
                                         <td>
										   <input type="checkbox" id="webd_dq_file" name="webd_dq_file">
                                        </td>
                                        <td>
											<input type="checkbox" id="webd_lb_file" name="webd_lb_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_sc_file" name="webd_sc_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_yd_file" name="webd_yd_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_yc_file" name="webd_yc_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_mt_file" name="webd_mt_file">
                                        </td>
                                        
                                        </td>
                                          </tr>
										  <tr>
										   <td>
                                              <input type="checkbox" id="webd_user1_file" name="webd_user1_file">
                                        </td>
                                        <td>
                                            <input type="text" id="webd_user1_name" name="webd_user1_name" class="input_12_table" maxlength="50" value="" placeholder=""/>
                                        </td>
                                         <td>
                                            <input type="password" id="webd_user1_pass" name="webd_user1_pass" autocomplete="new-password"  utocorrect="off" autocapitalize="off" onBlur="switchType(this, false);" onFocus="switchType(this, true);" class="input_6_table" maxlength="150" style="width:160px;" placeholder=""/>
                                        </td>
                                         <td>
										    <input type="checkbox" id="webd_dq1_file" name="webd_dq1_file">
                                        </td>
                                        <td>
										   <input type="checkbox" id="webd_lb1_file" name="webd_lb1_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_sc1_file" name="webd_sc1_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_yd1_file" name="webd_yd1_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_yc1_file" name="webd_yc1_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_mt1_file" name="webd_mt1_file">
                                        </td>
                                      
                                          </tr>
										  <tr>
										   <td>
										   <input type="checkbox" id="webd_user2_file" name="webd_user2_file">
                                        </td>
                                        <td>
                                            <input type="text" id="webd_user2_name" name="webd_user2_name" class="input_12_table" maxlength="50" value="" placeholder=""/>
                                        </td>
                                         <td>
                                            <input type="password" id="webd_user2_pass" name="webd_user2_pass" autocomplete="new-password"  utocorrect="off" autocapitalize="off" onBlur="switchType(this, false);" onFocus="switchType(this, true);" class="input_6_table" maxlength="150" style="width:160px;" placeholder=""/>
                                        </td>
                                         <td>
										    <input type="checkbox" id="webd_dq2_file" name="webd_dq2_file">
                                        </td>
                                        <td>
										     <input type="checkbox" id="webd_lb2_file" name="webd_lb2_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_sc2_file" name="webd_sc2_file">
                                        </td>
                                        <td>
										    <input type="checkbox" id="webd_yd2_file" name="webd_yd2_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_yc2_file" name="webd_yc2_file">
                                        </td>
                                        <td>
                                            <input type="checkbox" id="webd_mt2_file" name="webd_mt2_file">
                                        </td>
                                        
                                        </td>
                                          </tr>
                                      </table>
                                    </div>

                                    
                                    <div class="apply_gen">
                                        <span><input class="button_gen" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
                                    </div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formbottomdesc" id="cmdDesc">
                                        <i>* 注意事项：</i><br/>
                                        1、启用访客，后面的用户权限至少勾选一项(未设置时默认为可以读取文件和获取文件列表) <br/>
										     &nbsp; &nbsp; &nbsp;启用后将不需要账号密码即可访问你的文件。<br/>
                                        2、<i>点击</i>参数设置项目的<i>文字</i>，可<i>查看帮助</i>信息。<br/>
                                        3、用户设置中，只能设置三个个用户。<br/>
										4、用户权限可以任意灵活组合, 列举几种特殊的情况: <br/>
										 &nbsp;&nbsp; a. 不含读取文件列表但有访问读取文件的情况, 表示不能获取文件列表, 但在知晓文件路径的情况下可直接访问文件. <br/>
										 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;反之,含有读取文件列表的权限但没有访问读取文件的权限则表示能获取列表但无法访问文件. <br/>
										 &nbsp;&nbsp; b. 含有上传文件但没读取文件列表或读取文件, 表示可以上传, 但上传后看不到文件列表, 也无法再次下载. <br/>
										 &nbsp;&nbsp; c. 含有上传文件和读取文件但没有读取文件列表, 表示可以上传, 上传后无法获取文件列表, 但可输入路径直接下载. <br/>
										 &nbsp;&nbsp; d. 含有上传文件和读取文件列表但没有读取文件, 表示可以上传, 可以获取文件列表, 但无法下载. <br/>
                                    </div>
                                </td>
                            </tr>
                        </table>
                            </tr>
                        </table>
						<div id="webd_log"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">webd 启动日志<a href="javascript:void(0)" onclick="close_conf('webd_log');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>文本不会自动刷新，需要手动刷新，读取的文件是[/tmp/upload/webd.log]</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="logtxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node3" class="button_gen" type="button" onclick="close_conf('webd_log');" value="返回主界面">
                                            &nbsp;&nbsp;<input class="button_gen" type="button" onclick="close_conf('webd_log');clear_log();" value="清除日志">
                                        </div>
                                    </div>
                    </td>
                </tr>
            </table>
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
</form>
<div id="footer"></div>
</body>
</html>

