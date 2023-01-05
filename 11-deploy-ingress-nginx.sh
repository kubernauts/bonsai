#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

echo -e "[${GREEN}Deploying Nginx Ingress Controller${NC}]"
echo "############################################################################"

export KUBECONFIG=`pwd`/k3s.yaml
# kubectl create ns ingress-nginx
kubectl create -f addons/ingress-nginx/deploy.yaml
