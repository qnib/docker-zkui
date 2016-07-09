###### grafana images
FROM qnib/alpn-jdk8
#java8
ENV MVN_VER=3.3.9

#RUN dnf install -y bsdtar maven && \
RUN wget -qO - http://ftp.fau.de/apache/maven/maven-3/${MVN_VER}/binaries/apache-maven-${MVN_VER}-bin.tar.gz | tar xfz - -C /tmp/
RUN mv /tmp/apache-maven-${MVN_VER} /usr/lib/mvn 

ENV M2_HOME=/usr/lib/mvn \
    M2=/usr/lib/mvn/bin 
ENV PATH $PATH:$$JAVA_HOME:$JAVA:$M2_HOME:$M2
RUN curl -Lso /tmp/master.zip  https://github.com/DeemOpen/zkui/archive/master.zip \
 && cd /opt/ \
 && unzip /tmp/master.zip \
 && mv /opt/zkui-master /opt/zkui \
 && rm -rf /tmp/master.zip
RUN cd /opt/zkui && mvn clean install
ADD etc/supervisord.d/zkui* /etc/supervisord.d/
ADD etc/consul.d/zkui.json /etc/consul.d/
ADD etc/consul-templates/zkui.conf.ctmpl /etc/consul-templates/
ADD opt/qnib/zkui/bin/start_zookeeper-update.sh /opt/qnib/zkui/bin/
RUN echo "grep zkSer /opt/zkui/config.cfg" >> /root/.bash_history
ENV ZKUI_ADMIN_PW=admin \
    ZKUI_USER_PW=user \
    ZKUI_PORT=9090
