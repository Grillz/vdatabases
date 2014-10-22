#!/usr/bin/env bash

yum update

yum groupinstall "X Window System"

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
