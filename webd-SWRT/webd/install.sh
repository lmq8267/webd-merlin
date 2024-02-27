#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export webd_`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)

en=`dbus get webd_enable`
if [ ! -d "/jffs/softcenter" ] ; then
  echo_date "你的固件不适配，无法安装此插件包，请正确选择插件包！"
  rm -rf /tmp/webd* >/dev/null 2>&1
  exit 1
fi
if [ "${en}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/webd_config.sh stop
fi
find /jffs/softcenter/init.d/ -name "*webd.sh*"|xargs rm -rf
cd /tmp

cp -rf /tmp/webd/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/webd/webs/* /jffs/softcenter/webs/
cp -rf /tmp/webd/res/* /jffs/softcenter/res/
cp /tmp/webd/uninstall.sh /jffs/softcenter/scripts/uninstall_webd.sh
ln -sf /jffs/softcenter/scripts/webd_config.sh /jffs/softcenter/init.d/S39webd.sh



chmod +x /jffs/softcenter/scripts/webd_*
chmod +x /jffs/softcenter/init.d/S39webd.sh
chmod +x /jffs/softcenter/scripts/uninstall_webd.sh
dbus set softcenter_module_webd_description="轻量级(self-hosted)自建网盘软件"
dbus set softcenter_module_webd_install=1
dbus set softcenter_module_webd_name=webd
dbus set softcenter_module_webd_title=webd
dbus set softcenter_module_webd_version="$(cat $DIR/version)"

sleep 1
echo_date "webd 插件安装完毕！"
rm -rf /tmp/webd* >/dev/null 2>&1
en=`dbus get webd_enable`
if [ "${en}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/webd_config.sh restart
fi
exit 0
