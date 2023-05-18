read -p "pls input cluster management ip: " mgmtIP
read -p "pls input cluster admin passwd: " pw
read -p "pls input aggr name: " aggr
read -p "pls input vs name: " vs
read -p "pls input vol name: " vol
read -p "pls input lif name: " lif
read -p "pls input vol size[8g]: " size
read -p "pls input vs lif ipaddr[192.168.8.175]: " ip
read -p "pls input vs route gateway: " gw
read -p "pls input home-node[cluster100-01]: " node
read -p "pls input home-port[e0a]: " port

cat > cli.txt << EOF
vserver create -vserver $vs -rootvolume ${vs}_root -aggregate $aggr -rootvolume-security-style unix
vol create -vserver $vs -volume $vol -size $size -aggregate $aggr -junction-path /$vol
net int create -vserver $vs -lif $lif -home-node $node -home-port $port -service-policy default-data-files -address $ip -netmask 255.255.255.0
route create -vserver $vs -destination 0.0.0.0/0 -gateway $gw
vserver nfs create -access true -v3 enabled -v4.0 disabled -v4.1 disabled -tcp enabled -vserver $vs
vserver nfs modify -showmount enabled
export-policy rule create -vserver $vs -policyname default -protocol nfs3 -clientmatch 0.0.0.0/0 -rorule any -rwrule any -superuser any
vol modify -volume $vol -policy default

vs show
vol show
net int show -role data
route show
vs nfs show
export-policy rule show
EOF

cat > dev.txt << EOF
$mgmtIP admin $pw
EOF

./sshv2
