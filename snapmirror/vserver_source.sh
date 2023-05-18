read -p "pls input source vserver name: " vs
read -p "pls input peer vserver name: " dr
read -p "pls input peer cluster name: " cluster

cat > cli.txt << EOF
vserver peer create -vserver $vs -peer-vserver $dr -applications snapmirror -peer-cluster $cluster
EOF

./sshv2
