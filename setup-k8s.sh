#!/bin/bash

systemctl daemon-reload
# Disable firewalld
systemctl stop firewalld
systemctl disable firewalld

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y docker kubelet-1.6.0 kubeadm-1.6.0 kubectl-1.6.0 kubernetes-cni-0.5.1 --disableexcludes=kubernetes

sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
sed -i 's/^Environment="KUBELET_NETWORK_ARGS/#Environment="KUBELET_NETWORK_ARGS/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload

systemctl enable --now docker
systemctl enable --now kubelet

swapoff -a
sed -i '/^LABEL=swap/d' /etc/fstab
