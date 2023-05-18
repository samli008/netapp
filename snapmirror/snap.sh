read -p "pls input source vserver: " vs1
read -p "pls input dr vserver: " vs2
read -p "pls input source vol: " vol1
read -p "pls input dr vol: " vol2

cat > cli.txt << EOF
snapmirror create -source-path ${vs1}:${vol1} -destination-path ${vs2}:${vol2} -vserver $vs2 -throttle unlimited -type XDP -schedule 5min
snapmirror initialize -destination-path ${vs2}:${vol2}
snapmirror show
EOF

./sshv2
