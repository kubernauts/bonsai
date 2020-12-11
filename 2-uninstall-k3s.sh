#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

echo -e "[${LB}Info${NC}] uninstall k3s on k3s-master"
multipass exec k3s-master -- /bin/bash -c "k3s-uninstall.sh"

WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
for WORKER in ${WORKERS}; 
do echo -e "[${LB}Info${NC}] uninstall k3s on ${WORKER}" && multipass exec ${WORKER} -- /bin/bash -c "k3s-agent-uninstall.sh"; 
done

