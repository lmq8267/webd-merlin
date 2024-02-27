#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export webd_`
mkdir -p /tmp/upload
webd_enable=`dbus get webd_enable`
webd_cron_time=`dbus get webd_cron_time`
webd_cron_hour_min=`dbus get webd_cron_hour_min`
webd_cron_type=`dbus get webd_cron_type`
webd_log=/tmp/upload/webd.log
logg () {
   echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:  $1" >>${webd_log}
   echo -e "\033[36;1m【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】: \033[0m\033[35;1m$1 \033[0m"
}

# 自启
fun_nat_start(){
    if [ "${webd_enable}"x = "1"x ] ;then
	    [ ! -L "/koolshare/init.d/N99webd.sh" ] && ln -sf /jffs/softcenter/scripts/webd_config.sh /jffs/softcenter/init.d/N99webd.sh
    fi
}
# 定时任务
fun_crontab(){
    if [ "${webd_enable}" != "1" ] || [ "${webd_cron_time}"x = "0"x ];then
        [ -n "$(cru l | grep webd_monitor)" ] && cru d webd_monitor
    fi
     if [ "${webd_cron_hour_min}" == "min" ] && [ "${webd_cron_time}"x != "0"x ] ; then
        if [ "${webd_cron_type}" == "watch" ]; then
        	cru a webd_monitor "*/"${webd_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/webd_config.sh watch"
        elif [ "${webd_cron_type}" == "start" ]; then
            cru a webd_monitor "*/"${webd_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/webd_config.sh restart"
    	fi
    elif [ "${webd_cron_hour_min}" == "hour" ] && [ "${webd_cron_time}"x != "0"x ] ; then
        if [ "${webd_cron_type}" == "watch" ]; then
            cru a webd_monitor "0 */"${webd_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/webd_config.sh watch"
        elif [ "${webd_cron_type}" == "start" ]; then
            cru a webd_monitor "0 */"${webd_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/webd_config.sh restart"
        fi
    fi
}

# 关闭进程（先用默认信号，再使用9）
onkillwebd(){
    PID=$(pidof webd)
    [ -n "$(cru l | grep webd_monitor)" ] && cru d webd_monitor
    if [ -n "${PID}" ];then
		start-stop-daemon -K -p /var/run/webd.pid >/dev/null 2>&1
		kill -9 "${PID}" >/dev/null 2>&1
    fi
    rm -f /var/run/webd.pid
}

# 停止并清理
onstop(){
	onkillwebd
	logger "【软件中心】：关闭 webd..."
        [ -z "$(pidof webd)" ] && logg "webd已停止运行"
}    

fun_start_stop(){

 if [ "${webd_enable}" != "1" ] ; then
   onstop
   return 1
 fi
  webd_port=`dbus get webd_port`
  webd_ipv6=`dbus get webd_ipv6_enable`
  webd_trash=`dbus get webd_trash_enable`
  webd_file=`dbus get webd_file_path`
  webd_bin=`dbus get webd_bin_path`
  webd_user1=`dbus get webd_user1_name`
  webd_user1_pass=`dbus get webd_user1_pass`
  webd_user2=`dbus get webd_user2_name`
  webd_user2_pass=`dbus get webd_user2_pass`
  
  webd_fk=`dbus get webd_fk_file`
  webd_fkdq=`dbus get webd_dq_file`
  webd_fklb=`dbus get webd_lb_file`
  webd_fksc=`dbus get webd_sc_file`
  webd_fkyd=`dbus get webd_yd_file`
  webd_fkyc=`dbus get webd_yc_file`
  webd_fkmt=`dbus get webd_mt_file`
  
  webd_us1=`dbus get webd_user1_file`
  webd_us1dq=`dbus get webd_dq1_file`
  webd_us1lb=`dbus get webd_lb1_file`
  webd_us1sc=`dbus get webd_sc1_file`
  webd_us1yd=`dbus get webd_yd1_file`
  webd_us1yc=`dbus get webd_yc1_file`
  webd_us1mt=`dbus get webd_mt1_file`
  
  webd_us2=`dbus get webd_user2_file`
  webd_us2dq=`dbus get webd_dq2_file`
  webd_us2lb=`dbus get webd_lb2_file`
  webd_us2sc=`dbus get webd_sc2_file`
  webd_us2yd=`dbus get webd_yd2_file`
  webd_us2yc=`dbus get webd_yc2_file`
  webd_us2mt=`dbus get webd_mt2_file`
  [ -z "$webd_port" ] && logg "未获取到webd监听端口参数，程序退出" && return 1
  [ -z "$webd_file" ] && logg "未获取到webd作为服务器的本地文件路径，程序退出" && return 1
  [ -z "$webd_bin" ] && logg "未获取到webd的二进制程序文件路径，程序退出" && return 1
  chmod +x ${webd_bin}
  
  if [ "$webd_fk" = "1" ] ; then
     gust_cmd="-g"
     [ "$webd_fkdq" = "1" ] && gust="r"
     [ "$webd_fklb" = "1" ] && gust="${gust}l"
     [ "$webd_fksc" = "1" ] && gust="${gust}u"
     [ "$webd_fkyd" = "1" ] && gust="${gust}m"
     [ "$webd_fkyc" = "1" ] && gust="${gust}S"
     [ "$webd_fkmt" = "1" ] && gust="${gust}T"
     gust_cmd="${gust_cmd} ${gust}"
  else
     gust_cmd="-g 0"
  fi
  if [ "$webd_us1" = "1" ] ; then
     if [ -z "$webd_user1" ] || [ -z "$webd_user1_pass" ] ; then
        logg "未获取到用户1的帐号或密码，程序退出" && return 1
     fi
     us1_cmd="-u "
     [ "$webd_us1dq" = "1" ] && us1="r"
     [ "$webd_us1lb" = "1" ] && us1="${us1}l"
     [ "$webd_us1sc" = "1" ] && us1="${us1}u"
     [ "$webd_us1yd" = "1" ] && us1="${us1}m"
     [ "$webd_us1yc" = "1" ] && us1="${us1}S"
     [ "$webd_us1mt" = "1" ] && us1="${us1}T"
     us1_cmd="${us1_cmd} ${us1}:${webd_user1}:${webd_user1_pass}"
  fi
   if [ "$webd_us2" = "1" ] ; then
     if [ -z "$webd_user2" ] || [ -z "$webd_user2_pass" ] ; then
        logg "未获取到用户2的帐号或密码，程序退出" && return 1
     fi
     us2_cmd="-u "
     [ "$webd_us2dq" = "1" ] && us2="r"
     [ "$webd_us2lb" = "1" ] && us2="${us2}l"
     [ "$webd_us2sc" = "1" ] && us2="${us2}u"
     [ "$webd_us2yd" = "1" ] && us2="${us2}m"
     [ "$webd_us2yc" = "1" ] && us2="${us2}S"
     [ "$webd_us2mt" = "1" ] && us2="${us2}T"
     us2_cmd="${us1_cmd} ${us2}:${webd_user2}:${webd_user2_pass}"
  fi
  webd_cmd="-l $webd_port"
  [ "$webd_ipv6" = "1" ] && webd_cmd="${webd_cmd} -l [::]:${webd_ipv6}"
  [ ! -z "$gust_cmd" ] && webd_cmd="${webd_cmd} ${gust_cmd}"
  [ ! -z "$us1_cmd" ] && webd_cmd="${webd_cmd} ${us1_cmd}"
  [ ! -z "$us2_cmd" ] && webd_cmd="${webd_cmd} ${us2_cmd}"
  [ ! -z "$webd_file" ] && webd_cmd="${webd_cmd} -w ${webd_file}"
  [ "$webd_trash" = "1" ] && mkdir -p ${webd_file}/.Trash
  logg "当前webd启动参数 ${webd_bin} ${webd_cmd} "
  killall webd 2>/dev/null
    rm -rf /var/run/webd.pid
    start-stop-daemon --start --quiet --make-pidfile --pidfile /var/run/webd.pid --background --startas /bin/sh -- -c  "${webd_bin} ${webd_cmd} >>${webd_log} 2>&1"
   sleep 5
   [ ! -z "$(pidof webd)" ] && logg "webd启动成功！"
}


case $ACTION in
start)

    logger "【软件中心】：启动 webd..."
	fun_start_stop
	fun_nat_start
	fun_crontab
	;;
stop)
	onstop
	;;
restart)
        onstop
        fun_start_stop
	fun_nat_start
	fun_crontab
	;;
watch)
    [ -n "$(pidof webd)" ] && exit
    logger "【软件中心】定时任务：进程掉线，重新启动 webd..."
         onstop
        fun_start_stop
	;;
clearlog)
        true >${webd_log}
	http_response "$1"
    ;;
*)
 if [ "${webd_enable}" != "1" ] ; then
    logger "【软件中心】：未开启webd ，无需启动..."
   exit
 fi

	fun_start_stop
	fun_nat_start
	fun_crontab
	;;
esac
# 界面提交的参数
case $2 in
1)
        logger "【软件中心】：启动 webd..."
	fun_start_stop
	fun_nat_start
	fun_crontab
	http_response "$1"
	;;
clearlog)
        true >${webd_log}
	http_response "$1"
    ;;
esac
