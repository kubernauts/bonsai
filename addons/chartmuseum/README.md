# Welcome to Hello Chartmuseum for Private Helm Repos on K3s Bonsai!

This short how to porvides the steps needed to deploy a private helm repo with Chatrmuseum on Kubernetes. We are using our k3s implementation Bonsai on multipass VMs, this guide should work on any k8s cluster like minikube, etc. with minor adaptions though. The helm chart used here is a sample node.js hello world application packaged as a container with a Helm Chart from the [open-toolchain project](https://github.com/open-toolchain/hello-helm).

## Prerequisites

- A running K3s cluster with Bonsai
- LB service on Bonsai with MetalLB (it will be installed by default)
- helm3 version

## About Chartmuseum

To learn about Chartmuseum, please refer to:

https://chartmuseum.com/

## Get Started

Add Kubernetes Charts from googleapis:

helm repo add stable https://kubernetes-charts.storage.googleapis.com

Create a namespace for chartmuseum:

```
kubectl create ns chartmuseum
```

Switch to chatmuseum namespace:

```
kubectl config set-context --current --namespace chartmuseum
or (if kn in place)
kn chartmuseum 
```

### Deploy Chartmuseum

We deploy chartmuseum with custom values and create an ingress with the chartmuseum.local doamin name.

Please set set the follwoing host entries in your /etc/hosts file:

```
# adapt the IP below with the external IP of the traefik LB (run `kubectl get svc -A` and find the external IP)
192.168.64.26 chartmuseum.local
192.168.64.26 chart-example.local
```

And deploy chartmuseum:

```
helm install chartmuseum stable/chartmuseum --values custom-values.yaml
kubectl apply -f ingress.yaml
```

N.B.: the main change which was needed was to set DISABLE_API to false in custom-values.yaml (unless we can't push our charts to chartmuseum):

```bash
        - name: DISABLE_API
          value: "false"
```

And now browse to:

http://chartmuseum.local

If you see the "Welcome to ChartMuseum!", then you're fine.

## Build the hello-helm image and push to your private or public docker registry

Please substitute kubernautslabs with your docker registry name (we are using a private repo here):

```
cd chartmuseum/hello-helm
docker build -t kubernautslabs/hello-helm .
docker push kubernautslabs/hello-helm:latest
```

Adapt the image path in the values.yaml and change this part:

```
image:
  repository: kubernautslabs/hello-helm
  tag: latest
```

to:

```
image:
  repository: <your docker registry repo>/hello-helm
  tag: latest
```

Now we are ready to add the chartmuseum repo and install the helm-push plugin and package the sample hello-helm chart and push it to our chartmuseum running on K3s:

```
# add the repo
helm repo add chartmuseum http://chartmuseum.local
# install helm push plugin:
helm plugin install https://github.com/chartmuseum/helm-push.git
# build the package:
cd hello-helm/chart
helm package hello/
# the helm package name will be hello-1.tgz
ls -l hello-1.tgz
# push the package to chartmuseum
helm push hello-1.tgz chartmuseum
```

You should get:

```bash
Pushing hello-1.tgz to chartmuseum...
Done :-)
```

If you're going to push your image to a private docker registry, you nee to create a regsecret like this and finally install the chart:

kubectl create secret docker-registry regsecret --docker-server=https://index.docker.io/v1/  --docker-username=<your dockerhub username> --docker-password=xxxxxxxx --docker-email=xxxxxxxx

### Install the Chart

To install a chart, this is the basic command used:

```
helm install <chartmuseum-repo-name>/<chart-name> --name <release-name> (helm2)
helm install <release-name> <chartmuseum-repo-name>/<chart-name> (helm3)
```

We need to update our helm repos and install the chart:

```
helm repo update
helm install hello chartmuseum/hello
```

We should get a similiar output like this:

```
NAME: hello
LAST DEPLOYED: Sat Jul 25 17:56:23 2020
NAMESPACE: chartmuseum
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

### Harvest your work

curl http://chart-example.local/

*Welcome to Hello Chartmuseum for Private Helm Repos on K3s Bonsai!*

### List or delete the Chart

```
curl -i -X GET http://chartmuseum.local/api/charts/hello/1
curl -i -X DELETE http://chartmuseum.local/api/charts/hello/1
```

## Cleanup

```bash
helm repo remove chartmuseum
helm delete hello
helm delete chartmuseum
helm plugin remove push
```

## Related Links and Resources

https://github.com/helm/chartmuseum

https://github.com/open-toolchain/hello-helm

https://github.com/chartmuseum/helm-push/issues/13

https://chartmuseum.com/docs/#helm-chart

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

