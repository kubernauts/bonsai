#!/bin/bash 
export KUBECONFIG=`pwd`/k3s.yaml
kubectl create ns metallb-system
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.5/manifests/metallb.yaml
kubectl create -f metal-lb-layer2-config.yaml
