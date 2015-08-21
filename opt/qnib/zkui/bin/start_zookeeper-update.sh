#!/bin/bash

if [ "X${ZK_DC}" != "X" ];then
    sed -i'' -E "s#service \"zookeeper(@\w+)?\"#service \"zookeeper@${ZK_DC}\"#" /etc/consul-templates/zkui.conf.ctmpl
fi

if [ "X${ZK_MIN}" != "X" ];then
    ZK_CNT=0
    while [ ${ZK_CNT} -ne ${ZK_MIN} ];do
        ZK_CNT=$(curl -Ls "localhost:8500/v1/catalog/service/zookeeper?dc=${ZK_DC-dc1}"|python -m json.tool|grep -c Node)
        sleep 5
    done
fi 

consul-template -consul localhost:8500 -wait=15s -template "/etc/consul-templates/zkui.conf.ctmpl:/opt/zkui/config.cfg:supervisorctl restart zkui"
