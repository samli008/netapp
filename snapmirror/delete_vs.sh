read -p "pls input cluster management ip: " mgmtIP
read -p "pls input cluster admin passwd: " pw

read -p "pls input vs name: " vs
read -p "pls input vol name: " vol

cat > cli.txt << EOF
vol offline -vserver $vs -volume $vol -force
vol delete -vserver $vs -volume $vol 
echo y
vs delete -vserver $vs 
echo y

vs show
vol show
EOF

cat > dev.txt << EOF
$mgmtIP admin $pw
EOF

./sshv2
