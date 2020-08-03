#!/bin/bash

# make sure you have helm 3 version

helm version --short

helm repo add stable https://kubernetes-charts.storage.googleapis.com

helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

helm upgrade --install private-docker-registry stable/docker-registry --namespace kube-system

helm upgrade --install registry-proxy incubator/kube-registry-proxy \
--set registry.host=private-docker-registry.kube-system \
--set registry.port=5000 \
--set hostPort=5000 \
--namespace kube-system

kubectl apply -f docker-registry-ui.yaml

kubectl apply -f ingress-docker-registry-ui.yaml

# kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.13.2/release.yaml

kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

kubectl get crds

kubectl get images,pipelineruns,pipelines,taskruns,tasks,pipelineresources

# kubectl apply -f tekton-dashboard-release.yaml

kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml

kubectl config set-context --current --namespace tekton-pipelines

kubectl apply -f ingress-tekton-dashboard.yaml

# curl -LO https://github.com/tektoncd/cli/releases/download/v0.10.0/tkn_0.10.0_Linux_x86_64.tar.gz

# tar xvzf tkn_0.10.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

# curl -LO https://github.com/tektoncd/cli/releases/download/v0.10.0/tkn_0.10.0_Darwin_x86_64.tar.gz

# sudo tar xvzf tkn_0.10.0_Darwin_x86_64.tar.gz -C /usr/local/bin tkn

tkn version

kubectl get pipelineresources

tkn resources list

kubectl create ns hello

kubectl config set-context --current --namespace hello

kubectl apply -f node-js-tekton/pipeline/git-resource.yaml

# verify the Resource has been declared.

tkn resources list

kubectl apply -f node-js-tekton/pipeline/task-build-src.yaml

kubectl apply -f node-js-tekton/pipeline/task-deploy.yaml

tkn tasks list

kubectl apply -f node-js-tekton/pipeline/pipeline.yaml

tkn pipelines list

kubectl apply -f node-js-tekton/pipeline/service-account.yaml

kubectl get ServiceAccounts

kubectl apply -f node-js-tekton/pipeline/pipeline-run.yaml

tkn pipelineruns list

tkn pipelineruns describe application-pipeline-run

# kubectl port-forward service/app 8080:8080

# open http://127.0.0.1:8080

