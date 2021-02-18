#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

./utils/dependency-chec-helm.sh

echo "############################################################################"
echo "Now deploying Rancher latest in namespace cattle-system"
echo "############################################################################"

echo "set kubeconfig"
export KUBECONFIG=`pwd`/k3s.yaml && echo KUBECONFIG=$KUBECONFIG
 
kubectl create namespace cattle-system

# OFFICIAL RANCHER HELM CHART DOES NOT SUPPORT KUBERNETES 1.20 AT THE MOMENT
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.my.org

# Wait a few seconds for deployment to be created
sleep 5

kubectl -n cattle-system rollout status deploy/rancher

echo "Exposing Rancher deployment with loadbalancer service"
kubectl expose deployment rancher --type=LoadBalancer --name=rancher -n cattle-system
kubectl get svc rancher -n cattle-system

echo "############################################################################"
echo -e "[${GREEN}Success rancher deployment rolled out${NC}]"
echo "############################################################################"
