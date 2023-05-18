read -p "pls input cluster peer ip[192.168.8.201]: " ip

cat > cli.txt << EOF
cluster peer policy modify -is-unauthenticated-access-permitted true
cluster peer create -address-family ipv4 -peer-addrs $ip -no-authentication
cluster peer show
EOF

./sshv2
