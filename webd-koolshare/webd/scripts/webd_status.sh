#!/bin/sh

source /koolshare/scripts/base.sh
webd_pid=`pidof webd`
if [ -n "$webd_pid" ];then
        #webdver=`dbus get webd_version`
        #[ ! -z "$webdver" ] && webdver="webd $webdver "
	webd_log="$webdver<span style='color:  #7FFF00'>运行中</span'><img src='https://www.right.com.cn/forum/data/attachment/album/202401/30/081238k459q2d5klacs8rk.gif' width='30px' alt=''> PID：$webd_pid"
else
	webd_log="<span style='color:  #FF0000'>未运行</span'>"
fi

http_response "$webd_log"
