#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

echo -e "[${GREEN}Deploying MetalLB LoadBalancer${NC}]"
echo "############################################################################"

export KUBECONFIG=`pwd`/k3s.yaml
kubectl create ns metallb-system
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.5/manifests/metallb.yaml
kubectl create -f metal-lb-layer2-config.yaml
