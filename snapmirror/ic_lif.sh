read -p "pls input cluster vserver: " vs
read -p "pls input intercluster lif name: " lif
read -p "pls input intercluster lif ipaddr[192.168.8.201]: " ip
read -p "pls input home-node[cluster100-01]: " node
read -p "pls input home-port[e0a]: " port

cat > cli.txt << EOF
net int create -vserver $vs -lif $lif -home-node $node -home-port $port -role intercluster -address $ip -netmask 255.255.255.0
net int show -role intercluster
EOF

./sshv2
