#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export webd`

en=`dbus get webd_enable`
bin=`dbus get webd_bin_path`
if [ "${en}"x = "1"x ] ; then
    sh /koolshare/scripts/webd_config.sh stop
fi
rm -rf $bin
confs=`dbus list webd|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf /koolshare/scripts/webd*
rm -rf /koolshare/bin/webd*
rm -rf /koolshare/init.d/?99webd.sh
rm -rf /koolshare/webs/Module_webd.asp
rm -rf /koolshare/res/icon-webd.png

echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】: 卸载完成，江湖有缘再见~"
rm -rf /koolshare/scripts/uninstall_webd.sh
