# Kong Basic Installation

https://docs.konghq.com/2.2.x/kong-for-kubernetes/install/

```bash
helm repo add kong https://charts.konghq.com
helm repo update
helm pull kong/kong
tar xvfz kong-1.11.0.tgz
cd kong
k create ns kong
kn kong
helm install kong kong/kong --set ingressController.installCRDs=false
kga
```

# Kong Advanced Installation with custom values.yaml

```bash
helm upgrade --install kong kong/kong --set ingressController.installCRDs=false -f values.yaml
```

## Install Konga Admin GUI

```bash
git clone https://github.com/pantsel/konga.git
cd konga/charts/konga
--> set service type to LoadBalancer
helm install konga .
```

## Related resources 

https://docs.konghq.com/getting-started-guide/2.1.x/overview/

https://konghq.com/blog/kong-for-kubernetes-0-10-released-with-ingress-v1-resource-improved-ingress-class-handling-and-more/