# Nginx Inc. Ingress Controller Installation


```bash
helm repo add center https://repo.chartcenter.io

# helm pull center/nginx/nginx-ingress

k create ns nginx-ingress

kn nginx-ingress

cd nginx-ingress

helm upgrade --install nginx-controller center/nginx/nginx-ingress -f values.yaml
```

## Trouble Shooting ValidatingWebhookConfiguration

If ingress-nginx is installed, run:

```bash
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```