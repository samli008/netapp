read -p "pls input cluster management ip: " mgmtIP
read -p "pls input cluster admin passwd: " pw

read -p "pls input aggr name: " aggr

cat > cli.txt << EOF
aggr delete $aggr
echo y

aggr show
EOF

cat > dev.txt << EOF
$mgmtIP admin $pw
EOF

./sshv2
