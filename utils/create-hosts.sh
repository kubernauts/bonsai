#!/bin/bash

MASTER=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES+=$MASTER
NODES+=" "
NODES+=$WORKERS

cp /etc/hosts hosts.backup
cp /etc/hosts hosts.local
rm hosts.cleanup.backup

# make new hosts file for multipase vms
touch hosts.vm

FILES=('hosts.vm' 'hosts.local')
for f in "${FILES[@]}"
do
  # seach for existing multipass config
  exists=$(grep -n "####### multipass hosts start ##########" ${f} | awk -F: '{print $1}' | head -1)
  # check if var is empty
  if test -z "$exists" 
  then
    exists=0
  fi

  # cut existing config
  if (("$exists" > "0")) ; then
    start=$(grep -n "####### multipass hosts start ##########" ${f} | awk -F: '{print $1}' | head -1)
    ((start=start-1))
    end=$(grep -n "####### multipass hosts end   ##########" ${f} | awk -F: '{print $1}' | head -1)
    sed -i '' ${start},${end}d ${f}
  fi
  
  # replace with new config
  echo "" >> ${f}
  echo "####### multipass hosts start ##########" >> ${f}

  for NODE in ${NODES}; do
    multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)`' >> ${f}
  done

  echo "####### multipass hosts end   ##########" >> ${f}
done