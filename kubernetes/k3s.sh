clush  -w "master.durgasri.com,node[1-2].durgasri.com"  -b <<'EOF'
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo ufw allow from any
sudo ufw allow out to any
sudo ufw allow in from any
sudo reboot
EOF

clush  -w "master.durgasri.com,node[1-2].durgasri.com" "sudo snap stop microk8s"

curl -sfL https://get.k3s.io | sh -


curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
sudo cp k3sup-arm64 /usr/local/bin/k3sup

k3sup --help

  # create cluster
k3sup install \
--host=master \
--user=root \
--cluster \
--tls-san 192.168.48.45 \
--k3s-extra-args="--node-taint node-role.kubernetes.io/master=true:NoSchedule"

  # join master nodes
k3sup join \
--host=node2 \
--server-user=root \
--server-host=192.168.100.51 \
--user=root \
--server \
--k3s-extra-args="--node-taint node-role.kubernetes.io/master=true:NoSchedule"

  # join worker nodes on master
k3sup join \
--host=node1 \
--server-user=root \
--server-host=192.168.48.45 \
--user=root

k3sup join \
--host=node2 \
--server-user=root \
--server-host=192.168.48.45 \
--user=root


