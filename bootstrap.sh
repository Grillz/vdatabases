#!/usr/bin/env bash

yum -y update

wget -O /opt/jdk-7u67-linux-x64.tar.gz --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz"
tar xzf /opt/jdk-7u67-linux-x64.tar.gz -C /opt/
touch /etc/profile.d/java.sh
echo "export JAVA_HOME=/opt/jdk1.7.0_67" >> /etc/profile.d/java.sh
echo "export JRE_HOME=/opt/jdk1.7.0_67/jre" >> /etc/profile.d/java.sh
echo "export PATH=$PATH:/opt/jdk1.7.0_67/bin:/opt/jdk1.7.0_67/jre/bin" >> /etc/profile.d/java.sh

yum install mysql-server -y
service mysqld start

rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
REPO="[elasticsearch-1.3]
name=Elasticsearch repository for 1.3.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.3/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1"
echo "$REPO" > /etc/yum.repos.d/elasticsearch.repo
yum install -y elasticsearch

REPO="[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1"
echo "$REPO" > /etc/yum.repos.d/mongodb.repo
sudo yum install -y mongodb-org

iptables -F
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 9200 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 9300 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 27017 -j ACCEPT
service iptables save
