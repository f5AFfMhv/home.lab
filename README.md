## Proxmox Virtual Environment

Prepare to use with [terraform](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
```bash
pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```
Create vm template using cloud init [link 1](https://ochoaprojects.github.io/posts/ProxMoxCloudInitImage/) [link 2](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud_init)

```bash
wget https://cloud.debian.org/images/cloud/bookworm/20230531-1397/debian-12-genericcloud-amd64-20230531-1397.qcow2
export VM_ID=100
qm create $VM_ID --name Debian12CloudInit --net0 virtio,bridge=vmbr0
qm importdisk $VM_ID debian-12-genericcloud-amd64-20230531-1397.qcow2 local-zfs
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-$VM_ID-disk-0
qm set $VM_ID --ide2 local-zfs:cloudinit
qm set $VM_ID --boot c --bootdisk scsi0
qm set $VM_ID --serial0 socket --vga serial0
qm set $VM_ID --agent enabled=1 #optional but recommended
qm template $VM_ID
```
Export env variables with authentification information to proxmox
```bash
export PM_USER=terraform-prov@pve
export PM_PASS=<PASSWORD>
```

Run terraform code
```terraform
terraform init
terraform plan
terraform apply
```

## Modify cloud image
Instructions based on this [gist](https://gist.github.com/yuuichi-fujioka/10952389)
```bash
apt-get install qemu-utils
modprobe nbd
qemu-nbd --connect=/dev/nbd0 qcow2_inmage
mount /dev/nbd0p1 /mnt
mount -t proc proc /mnt/proc/
chroot /mnt
# check if /etc/resolv.conf is symlink. Remove it and create resolv.conf with your host dns configuration

#Make your changes
wget http://ftp.debian.org/debian/pool/main/q/qemu/qemu-guest-agent_8.0+dfsg-4_amd64.deb
dpkg -i qemu-guest-agent_8.0+dfsg-4_amd64.deb

umount /mnt/proc
sync
umount /mnt
qemu-nbd --disconnect /dev/nbd0
```

## Ansible playbooks

### k3s_provision.yml

Provisions new [K3S](https://k3s.io/) kubernetes cluster. It uses k3s quickstart script. For more information read official [documetation](https://docs.k3s.io/). Playbook is tested on debian 12 (bookworm) but should work with no or minimal modifications on other debian versions and debian based distros.

```bash
cd ansible
ansible-playbook playbooks/k3s_provision.yml
```

### docker.yml

Installs docker and docker-compose utilities. Pulls git repository configured in `ansible/group_vars/docker.yml` and runs docker-compose files from it. Docker compose environment variables are deployed from `ansible/playbooks/templates/docker.env.j2`.

```bash
cd ansible
ansible-playbook playbooks/docker.yml
# For just updating docker services
ansible-playbook playbooks/docker.yml --tags docker
```