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
ovs-vsctl show
```
