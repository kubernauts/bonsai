# Running K3s in a namespace on Bonsai or on any Kubernetes Cluster (e.g. EKS or Minikube)

With this simple implementation you can run K3s in one or more namespaces on any K8s Cluster as a Virtual Cluster, which helps us to save time, money and our planet and to become more productive in our daily work by CI/CD and many other use cases.

Imagine: you can run your dev / qa and stage clusters in seperate namespaces on a single cluster, how many idle clusters can you delete afterwards?

## TL;DR

```
kubectl create -f .

kubectl -n v1 exec -it v1-0 -- sh

kubectl create ns ghost

kubectl config set-context --current --namespace ghost

kubectl create -f https://raw.githubusercontent.com/kubernauts/practical-kubernetes-problems/master/3-ghost-deployment.yaml

kubectl get all
```
## Note on Storage Class and service cidr on EKS

If using minikube or EKS or whatever k8s cluster, you'd need to set the right `storageClassName` in `sts-k3s.yaml` for your environment:

```
      # k3s (default)
      storageClassName: local-path
      # minikube
      # storageClassName: standard
      # aws efs
      # storageClassName: efs-sc
      # aws gp2
      # storageClassName: gp2
```

AND set the right service-cidr of our k8s cluster in `sts-k3s.yaml`

```
        - --service-cidr=10.43.0.0/16
        # For AWS EKS adapt this service cidr and comment the line above and uncomment this line
        # - --service-cidr=172.20.0.0/16
```
