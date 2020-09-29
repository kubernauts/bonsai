# Tekton Pipeline Example Using Node.js

The [Tekton Pipelines project](https://tekton.dev/) provides Kubernetes-style resources for declaring [CI](https://martinfowler.com/articles/continuousIntegration.html) / [CD](https://martinfowler.com/bliki/ContinuousDelivery.html) style pipelines. Tekton is an open-source project that formed as a sub project of the [Knative](https://knative.dev/) project in March of 2019. Using established Kubernetes style declarations whole pipelines can be declared. The pipelines run on Kubernetes like any other process. Each steps runs as an independent container. Tekton also helps normalize and standardize the terms and methods for forming and running pipelines. Tekton pipelines can compliment a variety of popular CI/CD engines. For more information also see the [Continuous Delivery Foundation (CDF)](https://cd.foundation/).

This project demonstrates the building, deploying and running a Node.js application using Tekton on Kubernetes.

## Build and Deploy a Node.js App Using Tekton Pipeline

To see how this works, follow the hands-on Katacoda tutorial [here](www.katacoda.com/javajon/pipelines).

## References

This tutorial was adapted from [this other helpful tutorial](https://github.com/IBM/deploy-app-using-tekton-on-kubernetes).
