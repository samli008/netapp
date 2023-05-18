read -p "pls input dr vserver name: " dr
read -p "pls input source vserver name: " vs

cat > cli.txt << EOF
vserver peer accept -vserver $dr -peer-vserver $vs
EOF

./sshv2
