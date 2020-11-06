FROM centos:7

RUN yum install -y java-11-openjdk
RUN yum install -y java-11-openjdk-devel
 
COPY symmetricds "/var/www"

CMD ["/var/www/bin/sym"]
