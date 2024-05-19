#!/bin/bash

# 停止并禁用 firewalld 服务
systemctl stop firewalld.service >/dev/null 2>&1
systemctl disable firewalld.service >/dev/null 2>&1

# 关闭 SELinux
setenforce 0 >/dev/null 2>&1

# 禁用 UFW 防火墙
ufw disable >/dev/null 2>&1

# 设置 iptables 规则允许所有传入、转发和输出的流量
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1

# 清除 iptables 的 mangle 表和所有链的规则
iptables -t mangle -F >/dev/null 2>&1
iptables -F >/dev/null 2>&1
iptables -X >/dev/null 2>&1

# 保存 iptables 规则以防止重启后丢失
netfilter-persistent save >/dev/null 2>&1

# 提示消息
echo "所有 VPS 端口已开放"
