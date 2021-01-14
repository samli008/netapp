## install kvm
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
## setup openvswitch
```
ovs-vsctl add-br br100
ovs-vsctl add-port br100 eth1
ovs-vsctl set port eth1 trunks=6,8
ovs-vsctl clear port eth1 trunks
ovs-vsctl show
```
## setup kvm network
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
