# KubernetesSetup



# Pre-reqs for Master and Worker (we are using centos 7.6)

-> uname -a

-> free -m or dmidecode

-> nproc

-> free -m   (also cat /etc/fstab) --> if you see anything with SWAP as FS just comment that line and run swapoff -a 

-> getenforce
   setenforce 0
   vi /etc/selinux/config     --> change enforcing to permissive and save the file
   getenforce

-> hostnamectl set-hostname thinknyxmaster  (remember just allow two special characters in names one in "." And one is "-")
-> hostnamectl set-hostname thinknyxworkerone

-> ip addr (find the private ips of both server)
-> vi /etc/hosts (on both server and add IP to name mapping for both server)
-> Once done ping worker from master and vice versa

-> Port are all open

# Letting iptables see bridged traffic

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# Installing CRI-O as a runtime

--> export VERSION=1.24
--> export OS=CentOS_7

--> echo $VERSION
--> echo $OS

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

yum repolist 

yum install cri-o

systemctl status crio
systemctl start crio
systemctl enable crio
systemctl status crio

crio --version

# Installation of kubeadm, kubectl and kubelet

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

yum repolist

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet

Note: The kubelet will not start unless and until we complete the bootstrapping of our cluster

rpm -qa | grep -i kube*

# Initializing K8S Cluster

kubeadm init

# Seeting up Calico
# Details about CNI https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy

curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml -O
kubectl apply -f calico.yaml

kubectl get nodes

# Add the worker to the master node by running Join command
