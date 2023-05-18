read -p "pls input intercluster vs name:" vs
read -p "pls input intercluster lif name:" lif

cat > cli.txt << EOF
net int modify -vserver $vs -lif $lif -status-admin down 
net int delete -vserver $vs -lif $lif
EOF

./sshv2
