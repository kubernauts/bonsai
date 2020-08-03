#!/bin/bash

kubectl config set-context --current --namespace tekton-pipelines

kubectl delete all --all

helm delete private-docker-registry -n kube-system

helm delete registry-proxy -n kube-system

kubectl delete -f node-js-tekton/pipeline/git-resource.yaml

kubectl delete -f node-js-tekton/pipeline/task-build-src.yaml

kubectl delete -f node-js-tekton/pipeline/task-deploy.yaml

kubectl delete -f node-js-tekton/pipeline/pipeline.yaml

kubectl config set-context --current --namespace hello

kubectl delete -f node-js-tekton/pipeline/service-account.yaml

kubectl delete -f node-js-tekton/pipeline/pipeline-run.yaml

kubectl delete ns hello --force --grace-period=0

# kubectl delete ns tekton-pipelines --force --grace-period 0

kubectl delete crd conditions.tekton.dev images.caching.internal.knative.dev pipelineresources.tekton.dev pipelines.tekton.dev pipelineruns.tekton.dev tasks.tekton.dev clustertasks.tekton.dev clustertriggerbindings.triggers.tekton.dev eventlisteners.triggers.tekton.dev triggerbindings.triggers.tekton.dev triggertemplates.triggers.tekton.dev extensions.dashboard.tekton.dev
