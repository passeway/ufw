#!/bin/bash
# 停止并禁用 firewalld 服务
if systemctl stop firewalld.service >/dev/null 2>&1 && systemctl disable firewalld.service >/dev/null 2>&1; then
    echo "Firewalld 服务已成功停止并禁用。"
else
    echo "无法停止并禁用 firewalld 服务。"
fi

# 关闭 SELinux
if setenforce 0 >/dev/null 2>&1; then
    echo "SELinux 已成功关闭。"
else
    echo "无法关闭 SELinux。"
fi

# 禁用 UFW 防火墙
if ufw disable >/dev/null 2>&1; then
    echo "UFW 防火墙已成功禁用。"
else
    echo "无法禁用 UFW 防火墙。"
fi

# 设置 iptables 规则允许所有传入、转发和输出的流量
if iptables -P INPUT ACCEPT >/dev/null 2>&1 && iptables -P FORWARD ACCEPT >/dev/null 2>&1 && iptables -P OUTPUT ACCEPT >/dev/null 2>&1; then
    echo "iptables 规则已成功设置。"
else
    echo "无法设置 iptables 规则。"
fi

# 清除 iptables 的 mangle 表和所有链的规则
if iptables -t mangle -F >/dev/null 2>&1 && iptables -F >/dev/null 2>&1 && iptables -X >/dev/null 2>&1; then
    echo "iptables mangle 表和所有链的规则已成功清除。"
else
    echo "无法清除 iptables mangle 表和所有链的规则。"
fi

# 保存 iptables 规则以防止重启后丢失
if netfilter-persistent save >/dev/null 2>&1; then
    echo "iptables 规则已成功保存。"
else
    echo "无法保存 iptables 规则。"
fi
