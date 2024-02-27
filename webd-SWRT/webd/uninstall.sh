#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export webd`

en=`dbus get webd_enable`
bin=`dbus get webd_bin_path`
if [ "${en}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/webd_config.sh stop
fi
rm -rf $bin
confs=`dbus list webd|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf /jffs/softcenter/scripts/webd*
rm -rf /jffs/softcenter/bin/webd*
rm -rf /jffs/softcenter/init.d/?39webd.sh
rm -rf /jffs/softcenter/webs/Module_webd.asp
rm -rf /jffs/softcenter/res/icon-webd.png

echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】: 卸载完成，江湖有缘再见~"
rm -rf /jffs/softcenter/scripts/uninstall_webd.sh
