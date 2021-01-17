## deploy vm
```
virt-install --name=deploy-kvm --vcpus=2 --ram=4096 \
--os-type=linux --controller=scsi,model=virtio-scsi \
--disk path=/kvm/ONTAPdeploy.raw,device=disk,bus=scsi,format=raw \
--network network=br100,portgroup=vlan6,model=virtio \
--console=pty --import --wait 0

virsh console deploy
deploy network show
host show
cluster show
node show
```
## install kvm on each select nodes
```
yum -y install qemu-kvm qemu-kvm-tools libvirt virt-install bridge-utils virt-manager libguestfs-tools createrepo lrzsz net-tools lshw

systemctl start libvirtd
systemctl enable libvirtd

grep -c vmx /proc/cpuinfo
```
## config profile
```
cat >> /root/.bash_profile << EOF
alias re='systemctl restart'
alias list='virsh list --all'
alias start='virsh start'
alias del='virsh undefine'
alias stop='virsh destroy'
alias shutdown='virsh shutdown'
alias sl='virsh snapshot-list'
alias sc='virsh snapshot-create-as'
alias sr='virsh snapshot-revert'
alias sd='virsh snapshot-delete'
alias vnc='virsh vncdisplay'
alias hi='history -c'
alias li='virsh list'
alias nic='virsh domiflist'
alias disk='virsh domblklist'
alias fd='fdisk -l|grep sd'
EOF
```
## delete default bridge
```
virsh net-destroy default
virsh net-undefine default
```
## install openvswitch
```
yum -y install openvswitch.rpm
systemctl enable openvswitch
systemctl start openvswitch
```
## basic setup openvswitch
```
ovs-vsctl add-br br100
ovs-vsctl add-port br100 eth1
ovs-vsctl set port eth1 trunks=6,8
ovs-vsctl clear port eth1 trunks
ovs-vsctl show
```
## two nodes select HA openvswitch setup must two bridge for select role vm
```
ovs-vsctl add-br br100
ovs-vsctl add-br br101
ovs-vsctl add-port br100 ens224
ovs-vsctl add-port br101 ens256

ip link set ens224 mtu 9000 up
ip link set ens256 mtu 9000 up
ip link set br100 mtu 9000 up
ip link set br101 mtu 9000 up

ovs-vsctl set port ens256 tag=256
ovs-vsctl set port br101 trunks=256
ovs-vsctl set port ens224 tag=224
ovs-vsctl set port br100 trunks=224
```
## setup kvm network only deploy role vm need
```
cat > net.xml << EOF
<network>
      <name>br100</name>
      <forward mode='bridge'/>
      <bridge name='br100'/>
      <virtualport type='openvswitch'/>
      <portgroup name='vlan6'>
       <vlan>
        <tag id='6'/>
       </vlan>
      </portgroup>
      <portgroup name='vlan8'>
       <vlan>
        <tag id='8'/>
       </vlan>
      </portgroup>
</network>
EOF

virsh net-define net.xml
virsh net-start br100
virsh net-autostart br100
virsh net-dumpxml br100
virsh net-list

virsh net-undefine br100
virsh net-destroy br100
```
## setup storage pool on kvm host
```
virsh pool-define-as select_pool logical --source-dev /dev/sdb --target=/dev/select_pool

virsh pool-build select_pool
virsh pool-start select_pool
virsh pool-autostart select_pool
virsh pool-list

virsh pool-destroy select_pool
virsh pool-undefine select_pool
```
## aggr create on select
```
aggr create -aggregate aggr1 -diskcount 2 -node liyang-01 -mirror true
aggr create -aggregate aggr2 -diskcount 2 -node liyang-02 -mirror true
```
## nfs demo
### aggr-->vserver-->volume-->lif-->nfs_service-->export_policy-->map_vol_policy
```
aggr create -aggregate aggr1 -diskcount 2 -node liyang-01 -mirror true
vserver create -vserver nfs
vol create -vserver nfs -volume nfs01 -size 100g -aggregate aggr1 -junction-path /nfs
net int create -vserver nfs -lif nfs -home-node liyang-01 -home-port e0a -role data -data-protocol nfs -address 192.168.6.106 -netmask 255.255.255.0
route add -vserver nfs -destination 0.0.0.0/0 -gateway 192.168.6.1

vserver nfs create -access true -v3 enabled -v4.0 disabled -tcp enabled -vserver nfs
vserver nfs modify -showmount enabled
vserver nfs show 

export-policy create -policyname liyang -vserver nfs
export-policy rule create -vserver nfs -policyname default -protocol nfs3 -clientmatch 0.0.0.0/0 -rorule  none -rwrule none -superuser none
export-policy rule create -vserver nfs -policyname liyang -protocol nfs3 -clientmatch 0.0.0.0/0 -rorule any -rwrule any -superuser any

vol modify -volume nfs01 -policy liyang
export-policy rule show -policyname liyang -instance
vol show -fields policy
net int show -role data
```
