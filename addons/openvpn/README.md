# OPENVPN Setup Kubernetes

Create namespace called openvpn

kubectl create namespace openvpn

Create ebs volume for openvpn

kubectl apply -f openvpn-pv-claim.yaml

Then run this cmd to get vpn set up and running

helm2 install stable/openvpn -f openvpn.yaml --namespace openvpn --name openvpn

Then follow instructions in the output of above cmd to download vpn file:

## Create keys for users

Create client key .ovpn files by pasting the following into a shell:

```
  POD_NAME=$(kubectl get pods --namespace "openvpn" -l "app=openvpn,release=openvpn" -o jsonpath='{ .items[0].metadata.name }')
  SERVICE_NAME=$(kubectl get svc --namespace "openvpn" -l "app=openvpn,release=openvpn" -o jsonpath='{ .items[0].metadata.name }')
  SERVICE_IP=$(kubectl get svc --namespace "openvpn" "$SERVICE_NAME" -o go-template='{{ range $k, $v := (index .status.loadBalancer.ingress 0)}}{{ $v }}{{end}}')
  KEY_NAME=kubeVPN
  kubectl --namespace "openvpn" exec -it "$POD_NAME" /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
  kubectl --namespace "openvpn" exec -it "$POD_NAME" cat "/etc/openvpn/certs/pki/$KEY_NAME.ovpn" > "$KEY_NAME.ovpn"
```

Copy the resulting $KEY_NAME.ovpn file to your open vpn client (ex: in tunnelblick, just double click on the file).  Do this for each user that needs to connect to the VPN.  Change KEY_NAME for each additional user.


## Revoking certificates works just as easy:
```
  KEY_NAME=<name>
  POD_NAME=$(kubectl get pods -n "openvpn" -l "app=openvpn,release=openvpn" -o jsonpath='{.items[0].metadata.name}')
  kubectl -n "openvpn" exec -it "$POD_NAME" /etc/openvpn/setup/revokeClientCert.sh $KEY_NAME
```

## Related resources

https://github.com/rishabhindoria/aws-eks/tree/master/openvpn