#!/bin/bash

kubeadm init --skip-preflight-checks --apiserver-advertise-address 192.168.2.207

mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
