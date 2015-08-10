###### grafana images
FROM qnib/java7

RUN yum install -y bsdtar maven && \
    curl -fsL https://github.com/DeemOpen/zkui/archive/master.zip |bsdtar xf - -C /opt/ && mv /opt/zkui-master /opt/zkui
RUN cd /opt/zkui && mvn clean install
ADD etc/supervisord.d/zkui* /etc/supervisord.d/
ADD etc/consul.d/zkui.json /etc/consul.d/
ADD etc/consul-templates/zkui.conf.ctmpl /etc/consul-templates/
