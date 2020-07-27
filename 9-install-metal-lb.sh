#!/bin/bash 
export KUBECONFIG=`pwd`/k3s.yaml
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
kubectl create -f metal-lb-layer2-config.yaml
