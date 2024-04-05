这段脚本用于停止和禁用 firewalld 服务，将 SELinux 设置为宽松模式，禁用 UFW，以及清除 iptables 规则。最后，它保存了 netfilter-persistent 所做的更改。
```
curl -sS -o ufw.sh https://raw.githubusercontent.com/passeway/ufw/main/ufw.sh && chmod +x ufw.sh && ./ufw.sh
