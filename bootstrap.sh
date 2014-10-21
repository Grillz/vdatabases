#!/usr/bin/env bash

yum update
yum groupinstall "X Window System"
yum install mysql-server -y
service mysqld start
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
