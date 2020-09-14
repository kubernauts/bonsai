# K3s in K3s on Bonsai or any Kubernetes Cluster

With this simple implementation you can run K3s in a namespace on any K8s Cluster.

## TL;DR


```
kubectl create -f .

kubectl -n v1 exec -it v1-0 -- sh

kubectl create ns ghost

kubectl config set-context --current --namespace ghost

kubectl create -f https://raw.githubusercontent.com/kubernauts/practical-kubernetes-problems/master/3-ghost-deployment.yaml

kubectl get all
```

