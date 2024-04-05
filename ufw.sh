#!/bin/bash
# 停止并禁用 firewalld 服务
if ! systemctl stop firewalld.service >/dev/null 2>&1; then
    echo "Failed to stop firewalld service."
fi

if ! systemctl disable firewalld.service >/dev/null 2>&1; then
    echo "Failed to disable firewalld service."
fi

# 关闭 SELinux
if ! setenforce 0 >/dev/null 2>&1; then
    echo "Failed to disable SELinux."
fi

# 禁用 UFW 防火墙
if ! ufw disable >/dev/null 2>&1; then
    echo "Failed to disable UFW firewall."
fi

# 设置 iptables 规则允许所有传入、转发和输出的流量
if ! iptables -P INPUT ACCEPT >/dev/null 2>&1; then
    echo "Failed to set iptables INPUT policy to ACCEPT."
fi

if ! iptables -P FORWARD ACCEPT >/dev/null 2>&1; then
    echo "Failed to set iptables FORWARD policy to ACCEPT."
fi

if ! iptables -P OUTPUT ACCEPT >/dev/null 2>&1; then
    echo "Failed to set iptables OUTPUT policy to ACCEPT."
fi

# 清除 iptables 的 mangle 表和所有链的规则
if ! iptables -t mangle -F >/dev/null 2>&1; then
    echo "Failed to flush iptables mangle table."
fi

if ! iptables -F >/dev/null 2>&1; then
    echo "Failed to flush iptables rules."
fi

if ! iptables -X >/dev/null 2>&1; then
    echo "Failed to delete iptables chains."
fi

# 保存 iptables 规则以防止重启后丢失
if ! netfilter-persistent save >/dev/null 2>&1; then
    echo "Failed to save iptables rules."
fi
