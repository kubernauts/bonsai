# K8ssandra on Bonsai

Run k3s bonsai with:

```
./deploy-bonsai.sh
1 worker, 4 CPU and 16 GB of RAM
```

## Deploy K8ssandra with Helm

```
helm repo add k8ssandra https://helm.k8ssandra.io/stable

helm repo update

k create ns k8ssandra

kn k8ssandra

helm install -f k8ssandra.yaml k8ssandra k8ssandra/k8ssandra

Note: stargate heap, cpu request and limits have been increased in `k8ssandra.yaml`.

--> wait about 4-5 minutes

k get pods

kubectl get secret k8ssandra-superuser -o jsonpath="{.data.username}" | base64 --decode ; echo

kubectl get secret k8ssandra-superuser -o jsonpath="{.data.password}" | base64 --decode ; echo

--> adapt <super user pw> in commands below

kubectl exec -it k8ssandra-dc1-default-sts-0 -c cassandra -- nodetool -u k8ssandra-superuser -pw <super user pw>  info

kubectl exec -it k8ssandra-dc1-default-sts-0 -c cassandra -- nodetool -u k8ssandra-superuser -pw <super user pw>  status

kubectl exec -it k8ssandra-dc1-default-sts-0 -c cassandra -- nodetool -u k8ssandra-superuser -pw <super user pw>  ring
```

## Related resources

https://k8ssandra.io/get-started/

https://docs.k8ssandra.io/quickstarts/site-reliability-engineer/