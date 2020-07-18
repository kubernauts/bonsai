# Welcome to Hello Chartmuseum for Private Helm Repos on Bonsai!

This short how to porvides the needed steps to deploy a private helm repo with Chatrmuseum on Kubernetes. We are using our k3s implementation Bonsai on multipass VMs, this guide should work on any k8s cluster like minikube, etc. with minor adaptions though.

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
helm install chartmuseum stable/chartmuseum (helm3)
helm install stable/chartmuseum (helm2)
```

You should get the following output from the helm install run above, run it:

```
export POD_NAME=$(kubectl get pods --namespace chartmuseum -l "app=chartmuseum" -l "release=chartmuseum" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 --namespace chartmuseum
```

In a second terminal run the following commands to add the chartmuseum repo and install the helm-push plugin and packege the sample hello chart and pusht it to chartmuseum:

```
helm repo add chartmuseum http://localhost:8080
helm plugin install https://github.com/chartmuseum/helm-push.git
cd addons/chartmuseum/hello-helm/chart
helm package hello/
helm push hello-1.tgz chartmuseum
```

The helm push command doens't work for now, we love problems ;-)

```
Pushing hello-1.tgz to chartmuseum...
Error: 404: not found
Error: plugin "push" exited with error
```

### We love problems :-)

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

### Deploy the Chart

To install a chart, this is the basic command:

```
helm install <chartmuseum-repo-name>/<chart-name> --name <release-name>
```

In some cases you need to update your helm repos and install the chart:

```
helm repo update
helm install chartmuseum/hello --name hello (helm2)
helm install hello chartmuseum/hello (helm3)
```

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

## Related Links and Resources

https://github.com/helm/chartmuseum

https://github.com/open-toolchain/hello-helm

https://github.com/chartmuseum/helm-push/issues/13

https://chartmuseum.com/docs/#helm-chart

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

