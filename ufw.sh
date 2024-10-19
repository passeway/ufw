#!/bin/bash

# 检查系统类型
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    OS=$(uname -s)
    VERSION=$(uname -r)
fi

echo "操作系统: $OS $VERSION"

# 停止并禁用 firewalld 或其他常见防火墙工具
if systemctl list-unit-files | grep -q firewalld.service; then
    systemctl stop firewalld.service >/dev/null 2>&1
    systemctl disable firewalld.service >/dev/null 2>&1
    echo "firewalld 已停止并禁用"
elif systemctl list-unit-files | grep -q nftables.service; then
    systemctl stop nftables.service >/dev/null 2>&1
    systemctl disable nftables.service >/dev/null 2>&1
    echo "nftables 已停止并禁用"
else
    echo "没有检测到 firewalld 或 nftables"
fi

# 关闭 SELinux 并修改配置文件以禁用 SELinux
if command -v setenforce >/dev/null 2>&1; then
    setenforce 0 >/dev/null 2>&1
    if [ -f /etc/selinux/config ]; then
        sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        echo "SELinux 已关闭并配置为禁用"
    else
        echo "SELinux 配置文件不存在"
    fi
else
    echo "SELinux 未安装或不可用"
fi

# 禁用 UFW 防火墙（如果存在）
if command -v ufw >/dev/null 2>&1; then
    ufw disable >/dev/null 2>&1
    echo "UFW 防火墙已禁用"
else
    echo "UFW 防火墙未安装"
fi

# 设置 iptables 规则允许所有传入、转发和输出的流量
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1

# 清除 iptables 的 mangle 表和所有链的规则
iptables -t mangle -F >/dev/null 2>&1
iptables -F >/dev/null 2>&1
iptables -X >/dev/null 2>&1

# 检查并保存 iptables 规则
if command -v netfilter-persistent >/dev/null 2>&1; then
    netfilter-persistent save >/dev/null 2>&1
    echo "iptables 规则已保存"
elif command -v iptables-save >/dev/null 2>&1; then
    iptables-save > /etc/iptables/rules.v4 >/dev/null 2>&1
    echo "iptables 规则已保存到 /etc/iptables/rules.v4"
else
    echo "无法保存 iptables 规则，请手动检查保存工具"
fi

# 提示消息
echo "所有 VPS 端口已开放"
