###### grafana images
FROM qnib/alpn-maven

RUN curl -Lso /tmp/master.zip  https://github.com/DeemOpen/zkui/archive/master.zip \
 && cd /opt/ \
 && unzip /tmp/master.zip \
 && mv /opt/zkui-master /opt/zkui \
 && rm -rf /tmp/master.zip
RUN cd /opt/zkui && mvn clean install
ADD etc/supervisord.d/zkui.ini \
    etc/supervisord.d/zkui-update.ini \
    /etc/supervisord.d/
ADD etc/consul.d/zkui.json /etc/consul.d/
ADD etc/consul-templates/zkui.conf.ctmpl /etc/consul-templates/
ADD opt/qnib/zkui/update/bin/start.sh /opt/qnib/zkui/update/bin/
RUN echo "grep zkSer /opt/zkui/config.cfg" >> /root/.bash_history
ENV ZKUI_ADMIN_PW=admin \
    ZKUI_USER_PW=user \
    ZKUI_PORT=9090
ADD opt/qnib/zkui/bin/healthcheck.sh /opt/qnib/zkui/bin/
HEALTHCHECK --interval=2s --retries=300 --timeout=1s \
 CMD /opt/qnib/zkui/bin/healthcheck.sh
