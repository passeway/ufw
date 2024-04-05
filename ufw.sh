#!/bin/bash
# 停止并禁用 firewalld 服务
if ! systemctl stop firewalld.service >/dev/null 2>&1; then
    echo "无法停止 firewalld 服务。"
fi

if ! systemctl disable firewalld.service >/dev/null 2>&1; then
    echo "无法禁用 firewalld 服务。"
fi

# 关闭 SELinux
if ! setenforce 0 >/dev/null 2>&1; then
    echo "无法关闭 SELinux。"
fi

# 禁用 UFW 防火墙
if ! ufw disable >/dev/null 2>&1; then
    echo "无法禁用 UFW 防火墙。"
fi

# 设置 iptables 规则允许所有传入、转发和输出的流量
if ! iptables -P INPUT ACCEPT >/dev/null 2>&1; then
    echo "无法设置 iptables INPUT 策略为 ACCEPT。"
fi

if ! iptables -P FORWARD ACCEPT >/dev/null 2>&1; then
    echo "无法设置 iptables FORWARD 策略为 ACCEPT。"
fi

if ! iptables -P OUTPUT ACCEPT >/dev/null 2>&1; then
    echo "无法设置 iptables OUTPUT 策略为 ACCEPT。"
fi

# 清除 iptables 的 mangle 表和所有链的规则
if ! iptables -t mangle -F >/dev/null 2>&1; then
    echo "无法清除 iptables mangle 表。"
fi

if ! iptables -F >/dev/null 2>&1; then
    echo "无法清除 iptables 规则。"
fi

if ! iptables -X >/dev/null 2>&1; then
    echo "无法删除 iptables 链。"
fi

# 保存 iptables 规则以防止重启后丢失
if ! netfilter-persistent save >/dev/null 2>&1; then
    echo "无法保存 iptables 规则。"
fi
