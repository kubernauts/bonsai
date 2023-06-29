## Using external NFS Server with NFS Subdir External Provisioner on k3s k8s 1.20

Sometimes we need shared storage with Read-Write-Many (RWX) capability for development on our local machine. At this time of writing the NFS external provisioner didn't work on k8s 1.20, I'd to build a new image to get t working.

Here we go:

Deploy k3s from the root directory of this repo on multipass VMs and install nfs utils on the workers.

```
./deploy-bonsai.sh
## shell into worker nodes and install nfs-common utils
multipass shell k3s-worker1 (or k3s-worker2)
sudo apt update
sudo apt upgrade
sudo apt install nfs-common
```

Launch a new nfs-server VM:

```
multipass launch --name nfs-server --cpus 2 --memory 2G --disk 10G;
```

### Install NFS Kernel Server

```
multipass shell nfs-server
sudo apt update
sudo apt upgrade
sudo apt install nfs-kernel-server
sudo mkdir /var/nfs/general -p
mkdir nfs
sudo chown nobody:nogroup /var/nfs/general
sudo nano /etc/exports
## add these lines to exports (adapt the network address of yur multipass env)
/var/nfs/general    192.168.64.0/24(rw,sync,no_subtree_check)
/home/ubuntu/nfs    192.168.64.0/24(rw,sync,no_root_squash,no_subtree_check)
sudo systemctl restart nfs-kernel-server
```

```
ubuntu@nfs-server:~$ sudo exportfs
/var/nfs/general
		192.168.64.0/24
/home/ubuntu/nfs
		192.168.64.0/24
```

### Deploy nfs-client-provisioner

Adapt the NFS Server IP address in `deployment.yaml`:

```
          env:
            - name: PROVISIONER_NAME
              value: fuseim.pri/ifs
            - name: NFS_SERVER
              value: 192.168.64.26
            - name: NFS_PATH
              value: /home/ubuntu/nfs
      volumes:
        - name: nfs-client-root
          nfs:
            server: 192.168.64.26
            path: /home/ubuntu/nfs
```

And deploy the `nfs-client-provsioner`, the `managed-nfs-storage` StorageClass, rbac and the sample apps:

```
k apply -f .
k get pods
k get pvc
k get pv
```

Shell into nfs-server and check under `/home/ubuntu/nfs` if the PVs have been created:

```
ls -l nfs
default/
default-ghost-pv-claim-pvc-57d8f374-6276-4c08-8bc7-da68d0bf3810/
default-test-claim-pvc-fa159d47-a6e3-4f20-a329-f8ad94b31396/
```

# Related links

## Setup NFS Server and client for testing

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04

## Deploy NFS external provisioner

https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner

## Distributed Replicated Block Device (DRBD)

https://developweekly.com/docs/drbd/

## Highly Available NFS Server with Pacemaker & DRBD

https://developweekly.com/docs/pacemaker/

## Setting up an raspberrypi4 k3s-cluster with nfs persistent-storage

https://medium.com/@michael.tissen/setting-up-an-raspberrypi4-k3s-cluster-with-nfs-persistent-storage-a931ebb85737
