read -p "pls input aggr name: " aggr
read -p "pls input vs name: " vs
read -p "pls input vol name: " vol
read -p "pls input vol size[8g]: " size

cat > cli.txt << EOF
vserver create -vserver $vs -rootvolume ${vs}_root -aggregate $aggr -rootvolume-security-style unix
vol create -vserver $vs -volume $vol -size $size -aggregate $aggr -type DP
EOF

./sshv2
