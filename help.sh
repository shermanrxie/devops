netstat -nap

ssh-keygen -t rsa -P ''
scp ~/.ssh/id_rsa.pub root@35.231.254.26 :/tmp/id_rsa.pub_233
ssh -l root 35.231.254.26  cat /tmp/id_rsa.pub_233 >> ~/.ssh/authorized_keys

netstat -nltp
nc -vuz 45.76.19.6  1194

 
ssh -CqTfnN -R 0.0.0.0:9998:localhost:22  root@35.231.254.26
 
 
 
 git checkout  origin/master -b  simple
 git push origin --delete simple
 git branch -d simple
 git push origin  simple
 git branch -av 
 git reset --hard
 git reflog
 
 git reset --hard HEAD~1
 git branch -av
 git push origin sherman  --force
 
 rpm -qa | sort > pkglist.txt
 yum install $(cat /root/pkglist.txt|xargs)
 yum install --downloadonly $(cat pkglist.txt|xargs)

 tar -cvzpf etc.tar.gz   /var/cache/yum



 

 
#   /bin/systemctl start iptables.service
#   fdisk -l | grep 'Disk /dev/*' | awk '{print $2, $3, $4}'
#   ifconfig | grep mtu | awk '{print $1}' | tr -d :
#   iptables -p forward accept
#   kubectl config view
#   kubectl get services
#   more /etc/redhat-release 
#   ps -ef
#  /var/lib/docker/aufs/diff
#  baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
#  df - h
#  dig www.google.com
#  dock search jekins
#  docker container 
#  docker container ls
#  docker --help
#  docker image
#  docker image ls
#  docker info
#  docker login --help
#  docker login registry.gitlab.com
#  docker pull docker push registry.gitlab.com
#  docker pull registry
#  docker pull registry.gitlab.com
#  docker repository
#  docker save -o /usr/registry.tar  docker.io/registry:latest 
#  docker search jekins
#  docker search jenkins
#  docker search openvpn
#  docker search registory
#  docker search registry
#  docker search vpn
#  docker serach jenkins
#  docker serach jenkins dashboard
#  docker -v
#  docker volumes
#  doclker image 
#  dpkg-query -l | grep -c "hdparm"
#  ds -f 
#  fdisk -l
#  free -m 
#  free -m |grep "Mem" | awk '{print $2}' 
#  getconf LONG_BIT 
#  grep "model name" /proc/cpuinfo
#  grep "model name" /proc/cpuinfo | cut -f2 -d:
#  grep "model name" /proc/meminfo
#  grep MemTotal /proc/meminfo 
#  grep MemTotal /proc/meminfo | cut -f2 -d: 
#  history
#  hostname
#  ifconfig
#  ifconfig 
#  ifconfig  lo  | grep -c mtu
#  ifconfig | grep mtu | awk '{nic[$2] = $1}'
#  ifconfig | grep mtu | awk '{print $1}' | tr -d :
#  ifconfig | grep mtu | awk '{print $1}' | tr -d :   t.txt
#  ifconfig | grep mtu | awk '{print $1}' | tr -d :  > "NIC.txt"
#  ifconfig | grep mtu | awk '{print $1}' | tr -d : > x.txt
#  ifconfig | grep mtu | awk '{print }' | tr -d :
#  ifconfig eth0  | grep -c mtu
#  ifconfig eth0 | docker0 | grep -c mtu
#  ifconfig eth0 | grep -c mtu
#  ifconfig etho | grep -c mtu
#  ifocnfig
#  ip route
#  ipconfig
#  iproute
# iptables -P INPUT ACCEPT
# iptables -P FORWARD ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -t nat -F
# iptables -t mangle -F
# iptables -F
# iptables -X
#  iptables -nvL
#  iptables -p forward accept
#  iptables service status
#  journalctl -xe
#  kubectl
#  kubectl attach jenkins-374334337-tgk6t
#  kubectl attach shadowsocksr
#  kubectl cluster-info 
#  kubectl config view
#  kubectl create -f dashboard.yaml
#  kubectl create -f dashboardsvc.yaml
#  kubectl describe  pod jekins
#  kubectl describe pod  jekins
#  kubectl describe service  jekins
#  kubectl get cm  --all-namespaces
#  kubectl get configmap 
#  kubectl get cs  --all-namespaces
#  kubectl get ep
#  kubectl get ep  --all-namespaces
#  kubectl get ep --all-namespaces
#  kubectl get eps
#  kubectl get eps  --all-namespaces
#  kubectl get --help
#  kubectl get -n default  pods
#  kubectl get -n kube-public svc
#  kubectl get po  --all-namespaces
#  kubectl get pod --all-namespaces
#  kubectl get pods
#  kubectl get pods  --all-namespaces
#  kubectl get pods -all-namespace
#  kubectl get pods --all-namespaces
#  kubectl get pods --output=wide
#  kubectl get rc
#  kubectl get service  --all-namespaces
#  kubectl get services
#  kubectl get svc  --all-namespaces
#  kubectl ls
#  kubectl ls cp
#  kubectl start  services
#  ll -a
#  ll -h
#  ls
#  ls 
#  ls -a
#  lscpu
#  lsof -i 2323
#  md /usr/devops
#  md devops
#  mdir devops
#  mkdir ~/.ssh
#  mkdir devops
#  more /proc/cpuinfo
#  name=Kubernetes
#  nc -vuz 35.227.25.87 1194
#  netstat 35.227.25.87 1194
#  netstat -ap | grep 
#  netstat -ap | grep 2323
#  netstat --h
#  netstat -nap
#  netstat -nltp
#  netstat -nptl 
#  netstat -ntlp
#  netstat -nvh
#  netstat -tunlp
#  nginx reload
#  nginx -s realod
#  npm
#  nvc
#  passwd 
#  ping 
#  pip delete  shadowsocks
#  pip -h
#  pip install shadowsocks
#  pip remove  shadowsocks
#  pip uninstall  shadowsocks
#  ps
#  ps  |grep 5000
#  ps -A | grep python
#  ps aux | grep  25
#  ps aux | grep  8080
#  ps aux | grep 5000
#  ps -h
#  ps -list
#  repo_gpgcheck=1
#  rpm
#  rpm -q "hdparm"
#  rpm query
#  sdf  -l
#  sensors
#  server start openvpn
#  service iptables restart
#  service iptables start
#  service iptables status
#  service list
#  service openvpn start
#  service openvpn startservice openvpn start
#  service openvpn.service start
#  systemctl enable iptables
#  systemctl enable openvpn
#  systemctl start  openvpn@server.service
#  systemctl start openvpn
#  systemctl status openvpn@server.service
#  systemctl stop firewalld
#  top
#  touch /.ssh/authorized_keys
#  touch ~/.ssh/authorized_keys
#  touch test.conf
#  uname -a 
#  usr/bin/sh system-check.sh
#  version
#  yum
#  yum clean all 
#  yum fssnapshot
#  yum groups
#  yum info
#  yum install 10.142.0.3
#  yum install bind-utils
#  yum install dig
#  yum install etcd
#  yum install iptables
#  yum install iptables-services
#  yum install nc
#  yum install nvc
#  yum install openvpn
#  yum install python-setuptools && easy_install pip
#  yum install telnet
#  yum install -y kubelet kubeadm kubectl
#  yum install -y kubelet kubeadm kubectl 
#  yum list | grep shadow
#  yum list installed
#  yum list installed | grep shadow
#  yum makecache
#  yum makecache 
#  yum pkg-repos
#  yum remmove iptables
#  yum remove iptable
