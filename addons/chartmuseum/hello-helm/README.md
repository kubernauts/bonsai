# Welcome to Hello Chartmuseum for Private Helm Repos on Bonsai!

This short how to porvides the needed steps to deploy a private helm repo with Chatrmuseum on Kubernetes. We are using our k3s implementation Bonsai on multipass VMs, this guide should work on any k8s cluster like minikube, etc. with minor adaptions though. The helm chart used here is a sample node.js hello world application packaged as a container with a Helm Chart from the [open-toolchain project](https://github.com/open-toolchain/hello-helm).

## Prerequisites

- running k8s 
- LB service on Bonsai with MetalLB would be nice, not a must, but you need to change the service type if LB service not available!
- helm2 or helm3 versions
- basic helm skills

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

```
cd addons/chartmuseum/hello-helm
helm install chartmuseum stable/chartmuseum (helm3)
helm install stable/chartmuseum (helm2)
```

You should get the following output from the helm install run above, run it:

```
export POD_NAME=$(kubectl get pods --namespace chartmuseum -l "app=chartmuseum" -l "release=chartmuseum" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 --namespace chartmuseum
```

Browse to:

http://127.0.0.1:8080

If you see the "Welcome to ChartMuseum!" then you're fine.

## Build the image and push to your private or public registry

Please substitute kubernautslabs with your docker registry name (we are using a private repo here):

```
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

In a second terminal run the following commands to add the chartmuseum repo and install the helm-push plugin and package the sample hello chart and push it to chartmuseum:

```
# add the repo
helm repo add chartmuseum http://localhost:8080
# install helm push plugin:
helm plugin install https://github.com/chartmuseum/helm-push.git
# build the package:
cd addons/chartmuseum/hello-helm/chart
helm package hello/
# the helm package name will be hello-1.tgz
ls -l hello-1.tgz
# push the package to chartmuseum
helm push hello-1.tgz chartmuseum
```

The helm push command doens't work for now, we love problems ;-)

```
Pushing hello-1.tgz to chartmuseum...
Error: 404: not found
Error: plugin "push" exited with error
```

### We solve problems :-)

Well, it doesn't work :-(

We need to edit the chartmuseum deployment and set the env. variable DISABLE_API to false:

```
kubectl edit deployments.apps chartmuseum-chartmuseum
```

and set:

```bash
        - name: DISABLE_API
          value: "false"
```

Get the service and do a port forward again and push your hello helm chart to the private repo finally:

```bash
k get svc
k port-forward service/chartmuseum-chartmuseum 8080
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
helm install <release-name> <chartmuseum-repo-name>/<chart-name>
```

In some cases you need to update your helm repos and install the chart:

```
helm repo update
helm install chartmuseum/hello --name hello (helm2)
helm install hello chartmuseum/hello (helm3)
```

Now that our chart is deployed, we can call the app:

First provide the following entry in your /etc/hosts (adapt the IP adress to the traefik LB IP) like this:

```
192.168.64.26 chart-example.local
```

### Harvest your work

curl http://chart-example.local/

Welcome to Hello Chartmuseum for Private Helm Repos on Bonsai!

### List or delete the Chart

```
curl -i -X GET http://localhost:8080/api/charts/hello/1
curl -i -X DELETE http://localhost:8080/api/charts/hello/1
```

## Cleanup

```bash
helm repo remove chartmuseum
helm delete --purge hello
helm ls
helm delete --purge <chatmuseum release name>
helm plugin remove push
```

## Try it on Kubernautic

If you'd like to try this guide on our free Kubernetes offering Kubernautic, feel free to get startet here:

https://kubernauts.sh

N.B. you need most probably to change couple of things like service type and build the image with no root privileges.

## Related Links and Resources

https://github.com/helm/chartmuseum

https://github.com/open-toolchain/hello-helm

https://github.com/chartmuseum/helm-push/issues/13

https://chartmuseum.com/docs/#helm-chart

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

