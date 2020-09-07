# installing k3s on pi
# beause issue https://github.com/rancher/k3s/issues/1597 | ohthehugemanatee got it
# Raspbian 10 comes with an iptables wrapper around nf_tables in the kernel. So the command iptables exists, but only as a simlink to iptables_nft. It returns version string iptables v1.8.2 (nf_tables) which seems like it should be correctly handled in check-config.sh. Still, I found firewall entries both in iptables -L (ie nf_tables) and iptables-legacy -L.
sudo apt remove iptables -y && sudo apt install nftables