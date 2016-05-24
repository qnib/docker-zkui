###### grafana images
FROM qnib/alpn-jdk8
#java8

#RUN dnf install -y bsdtar maven && \
RUN wget http://ftp.fau.de/apache/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.tar.gz \
 && tar -zxvf apache-maven-3.3.1-bin.tar.gz \
 && rm apache-maven-3.3.1-bin.tar.gz \
 && mv apache-maven-3.3.1 /usr/lib/mvn 

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
