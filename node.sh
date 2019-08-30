read -p "pls input ontap node name:" name
tar xzvf ontap.tar
mv ontap94 $name
virt-install --name=$name --vcpus=2 --ram=5120 --os-type=linux \
--import --disk path=/kvm/$name/disk1,bus=ide \
--import --disk path=/kvm/$name/disk2,bus=ide \
--import --disk path=/kvm/$name/disk3,bus=ide \
--import --disk path=/kvm/$name/disk4,bus=ide \
--network "bridge=br1,model=e1000" \
--network "bridge=br1,model=e1000" \
--network "bridge=br1,model=e1000" \
--network "bridge=br1,model=e1000" \
--noautoconsole --noreboot
