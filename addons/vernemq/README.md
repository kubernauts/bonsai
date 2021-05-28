# VerneMQ deployment

This deployment uses the vernemq image form kubernautslabs/vernemq, the adapted Dockerfile has only the env DOCKER_VERNEMQ_ACCEPT_EULA="yes" set, the service type has been set to LoadBalancer and the persistentVolume was set to true and the replicaCount to 3 in values.yaml file.

```
git clone https://github.com/kubernauts/bonsai.git

cd bonsai/addons/vernemq/helm/vernemq

helm repo add vernemq https://vernemq.github.io/docker-vernemq

k create ns vernemq

kn vernemq

helm install vernemq vernemq/vernemq --values values.yaml
```

## Related resources:

https://vernemq.com/

https://github.com/vernemq/vernemq

https://docs.vernemq.com/guides/vernemq-on-kubernetes


