
```
kn default
mkcert '*.nginx.svc'
k create secret tls nginx-secret --cert=_wildcard.nginx.svc.pem --key=_wildcard.nginx.svc-key.pem
k apply -f nginx.yaml
kgs
kgi
# map the IP of the traefik LB or one of the worker nodes to my.nginx.svc in /etc/hosts file.
curl https://my.nginx.svc
```