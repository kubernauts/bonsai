#!/bin/bash

# check if required applications and files are available
./utils/dependency-check.sh

nodeCount=2
read -p  "How many worker nodes do you want?(default:$nodeCount) promt with [ENTER]:" inputNode
nodeCount="${inputNode:-$nodeCount}"
cpuCount=2
read -p  "How many cpus do you want per node?(default:$cpuCount) promt with [ENTER]:" inputCpu
cpuCount="${inputCpu:-$cpuCount}"
memCount=4
read -p  "How many gigabyte memory do you want per node?(default:$memCount) promt with [ENTER]:" inputMem
memCount="${inputMem:-$memCount}"
diskCount=10
read -p  "How many gigabyte diskspace do you want per node?(default:$diskCount) promt with [ENTER]:" inputDisk
diskCount="${inputDisk:-$diskCount}"
# k8sversion=1.19.8
# k8sversion=1.20.7
# k8sversion=1.21.3
#k8sversion=1.24.9
k8sversion=1.25.10
#k8sversion=1.26.5
read -p  "Which k8s version do you want to use? check https://github.com/k3s-io/k3s/releases (default:$k8sversion, also possible: 1.26.5) promt with [ENTER]:" inputK8Sversion
k8sversion="${inputK8Sversion:-$k8sversion}"
echo $k8sversion > k8sversion

MASTER=$(echo "k3s-master ") && WORKER=$(eval 'echo k3s-worker{1..'"$nodeCount"'}')

NODES+=$MASTER
NODES+=$WORKER

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus ${cpuCount} --memory ${memCount}G --disk ${diskCount}G --cloud-init cloud-config.yaml; done

# Wait a few seconds for nodes to be up
sleep 5

# # create hosts files for multipass vms and cluster access with local environment
./utils/create-hosts.sh

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
sudo cp hosts.local /etc/hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"

for NODE in ${NODES}; do
  multipass transfer hosts.vm ${NODE}:
  multipass transfer ~/.ssh/id_rsa.pub ${NODE}:
  multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
  multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys'
  multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
  multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts.vm >> /etc/hosts'
done

# cleanup tmp hostfiles
rm hosts.vm