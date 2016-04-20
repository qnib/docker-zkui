###### grafana images
FROM qnib/java8

RUN dnf install -y bsdtar maven && \
    curl -fsL https://github.com/DeemOpen/zkui/archive/master.zip |bsdtar xf - -C /opt/ && mv /opt/zkui-master /opt/zkui
RUN cd /opt/zkui && mvn clean install
ADD etc/supervisord.d/zkui* /etc/supervisord.d/
ADD etc/consul.d/zkui.json /etc/consul.d/
ADD etc/consul-templates/zkui.conf.ctmpl /etc/consul-templates/
ADD opt/qnib/zkui/bin/start_zookeeper-update.sh /opt/qnib/zkui/bin/
RUN echo "grep zkSer /opt/zkui/config.cfg" >> /root/.bash_history
ENV ZKUI_ADMIN_PW=admin \
    ZKUI_USER_PW=user
