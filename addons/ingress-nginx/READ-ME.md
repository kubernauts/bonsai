# Installation Guide with MetalLB

## Install MetalLB

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl create -f metal-lb-layer2-config.yaml
```

## Install Ingress Nginx Controller for Bare Metal

https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

```bash
k create ns ingress-nginx

kn ingress-nginx

wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.0/deploy/static/provider/baremetal/deploy.yaml

k apply -f deploy.yaml
```

Changed the service type of ingress-nginx-controller from NodePort to LoadBalancer:

```bash
apiVersion: v1
kind: Service
metadata:
  annotations:
  labels:
    helm.sh/chart: ingress-nginx-3.8.0
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.41.0
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  # changed to lb type
  type: LoadBalancer
  # type: NodePort
```







