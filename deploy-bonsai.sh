#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color
res1=$(date +%s)
./1-deploy-multipass-vms.sh
./2-deploy-k3s.sh
./9-install-metal-lb.sh
res2=$(date +%s)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
echo "############################################################################"
echo -e "${GREEN}FINISHED${NC}"
printf "${GREEN}Total runtime in minutes was: %02d:%02.f\n${NC}" $dm $ds
echo "############################################################################"