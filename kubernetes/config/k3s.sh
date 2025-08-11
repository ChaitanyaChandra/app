clush  -w "master.durgasri.com,node[1-2].durgasri.com"  -b <<'EOF'
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F
sudo ufw allow from any
sudo ufw allow out to any
sudo ufw allow in from any
EOF

clush  -w "master.durgasri.com,node[1-2].durgasri.com"  -b <<'EOF'
/usr/local/bin/k3s-uninstall.sh
/usr/local/bin/k3s-agent-uninstall.sh
EOF

clush  -w "master.durgasri.com,node[1-2].durgasri.com" "sysctl net.ipv4.ip_forward"

# sudo vi /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# apply
sudo sysctl -p


# disable ipv6
sudo vi /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 quiet splash"
GRUB_CMDLINE_LINUX="ipv6.disable=1"

sudo update-grub


clush  -w "master.durgasri.com,node[1-2].durgasri.com" "ip route"


clush  -w "master.durgasri.com,node[1-2].durgasri.com" "sudo snap remove microk8s"

curl -sfL https://get.k3s.io | sh -

curl -sfL https://get.k3s.io | sh -s - server \
--cluster-cidr=192.168.32.0/20 \
--service-cidr=192.168.8.0/22 \
--tls-san="master.durgasri.com"

root@master:/home/chaitu# cat /var/lib/rancher/k3s/server/node-token
K1002fbdacf1ce0cf52f6702b5ab2a8c50d7a1bce22eb7ca3e969136ee6211e541f::server:e714b06734f559954a79f98821165c12

curl -sfL https://get.k3s.io | K3S_URL=https://master.durgasri.com:6443 K3S_TOKEN=K1051d95eb8f44423788445d292b46454fbdd20684d68727482acd4665b48c7fcaa::server:fae7b2803854f7f37fc9d7f77cca0bea sh -

/etc/rancher/k3s/k3s.yaml
