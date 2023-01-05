# Bonsai Kube: k3s on multipass VMs on your local machine

Latest version: Kubernetes 1.24.9 (v1.24.9+k3s1)

![multipass-k3s.png](multipass-k3s.png)

## Introduction

![bonsai](bonsai.jpg)

This repo provides a lightweight multi-node k3s deployment on multipass VMs on your local machine.

It deploys mainly k3s with MetalLB and the upstream kubernetes nginx ingress controller and provides couple of useful [addons](./addons/README.md) for developers and ops folks.
## About k3s

[k3s](https://k3s.io/) is a nice tool for development, fun and profit, with k3s you can spin up a lightweight k8s cluster from scratch in less than 3 minutes.

k3s is packed into a single binary, which already includes all you need to quickly spin up a k8s cluster.

To learn more about k3s, please visit [the k3s github repo](https://github.com/rancher/k3s) and [the official documentation.](https://rancher.com/docs/k3s/latest/en/)

## Prerequisites

### Install multipass (on MacOS or Linux)

You need Multipass running on your local machine, to learn more about Multipass, please visit:

https://github.com/CanonicalLtd/multipass

https://multipass.run/

This setup was tested on MacOS, but should work on Linux or Windows too.

You need to have about 4GB free RAM and 16GB free storage on your local machine, but it should work with less resources.

You need sudo rights on your machine.

You need kubectl in your path, if not, you can download the v1.17.4 version and put it in your path:

MacOS users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.3/bin/darwin/amd64/kubectl
```

Linux users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.3/bin/linux/amd64/kubectl
```

```bash
chmod +x ./kubectl
mv kubectl /usr/local/bin/
```

### Important hint for MacOS Intel and Linux users

MacOS Intel and Linux users should adapt the `utlis/create-hosts.sh` and adapt the network interface name `enp0s1` (which is apparently the default nic name of multipass VMs on M2 Silicon MacOS). You can find the nic name with:

```bash
multipass launch --name test
multipass exec test -- bash -c 'echo `ls /sys/class/net | grep en`'
```

Delete and purge the test VM:

```bash
multipass delete test
multipass purge
```

If the above doesn't work somehow, shell into the node and get the nic name:

```bash
multipass shell test
ifconfig
```

## k3s Deployment (step 1)

Clone this repo and deploy a 3-node deployment with a single command:

```bash
git clone https://github.com/kubernauts/bonsai
cd bonsai
./deploy-bonsai.sh
```

You'll be asked to provide the desired number of worker nodes, cpu and memory, the default ones shoul be fine.

After the deplyoment the output provides the total runtime similar to this:

############################################################################

Total runtime in minutes: 03:05

############################################################################

## Clean Up

```bash
./cleanup.sh
./cleanup-rkes.sh
```
## Troubleshooting

k3s uses containerd as CRI (container runtime interface). If you'd like to see the status of the containers on the nodes for e.g. troubleshooting or fun, you can run:

```bash
multipass exec k3s-worker -- /bin/bash -c "sudo crictl ps -a"
```

or shell into the node and run `sudo crictl ps -a`:

```bash
multipass shell k3s-worker1
sudo crictl ps -a
```

## Gotchas

Running `./cleanup.sh` throws an error like:

```bash
Stopping requested instances -[2019-09-14T14:49:51.096] [error] [rke1] process error occurred Crashed
```

which can be ignored.

## Credits

Thanks to the awesome folks at Rancher Labs for making k3s the first choice for a lightweight Kubernetes solution.

And thanks to Mattia Peri for his [great post](https://medium.com/@mattiaperi/kubernetes-cluster-with-k3s-and-multipass-7532361affa3) on medium, which encouraged me to automate everything with this small implementation for k3s on multipass.


## Blog post

A related blog post will is published here:

https://blog.kubernauts.io/k3s-with-metallb-on-multipass-vms-ac2b37298589?


## Related resources

[The Enterprise Grade Rancher Deployment Guide, the hard way](https://blog.kubernauts.io/enterprise-grade-rancher-deployment-guide-ubuntu-fd261e00994c)

[Announcing Maesh, a Lightweight and Simpler Service Mesh Made by the Traefik Team](https://blog.containo.us/announcing-maesh-a-lightweight-and-simpler-service-mesh-made-by-the-traefik-team-cb866edc6f29)

[Howto – Set up a highly available instance of Rancher](https://blog.ronnyvdb.net/2019/01/20/howto-set-up-a-highly-available-instance-of-rancher)

[Terraform configs and asnible playbooks to deploy k3s clusters](https://github.com/AnchorFree/ansible-k3s)

[OpenEBS](https://openebs.io)

[Cloud-Native stateful storage for Kubernetes with Rancher Labs' Longhorn](https://www.civo.com/learn/cloud-native-stateful-storage-for-kubernetes-with-rancher-labs-longhorn)

[Running k3s with metallb on Vagrant](https://medium.com/@toja/running-k3s-with-metallb-on-vagrant-bd9603a5113b)

[vagrant-k3s-metallb](https://github.com/otsuarez/vagrant-k3s-metallb)

[Kubernetes & Traefik 101 When Simplicity Matters](https://medium.com/@geraldcroes/kubernetes-traefik-101-when-simplicity-matters-957eeede2cf8)

[k3s + Gitlab](https://github.com/apk8s/k3s-gitlab)

[Using a k3s Kubernetes Cluster for Your GitLab Project](https://medium.com/better-programming/using-a-k3s-kubernetes-cluster-for-your-gitlab-project-b0b035c291a9)

[KIND and Load Balancing with MetalLB on Mac](https://www.thehumblelab.com/kind-and-metallb-on-mac/)

[Using MetalLB And Traefik Load Balancing For Your Bare Metal Kubernetes Cluster – Part 1](https://www.devtech101.com/2019/02/23/using-metallb-and-traefik-load-balancing-for-your-bare-metal-kubernetes-cluster-part-1/)
