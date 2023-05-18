read -p "pls input cluster management ip: " mgmtIP
read -p "pls input cluster admin passwd: " pw
read -p "pls input aggr name: " aggr
read -p "pls input diskcount: " count
read -p "pls input raidsize: " max
read -p "pls input node name: " node

cat > cli.txt << EOF
aggr create -aggregate $aggr -diskcount $count -raidtype raid_dp -maxraidsize $max -node $node
aggr show
EOF

cat > dev.txt << EOF
$mgmtIP admin $pw
EOF

./sshv2
