# Proxmox Virtual Environment

## Preparations for terraform

Create user for terraform.

```bash
# Create role
pveum role add TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit SDN.Use"
# Create user
pveum user add terraform-prov@pve --password <password>
# Assign role to user
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

## Cloud images

Download cloud image.

```bash
# This example is for debian cloud image.
# Check https://cloud.debian.org/images/cloud for newer versions
wget https://cloud.debian.org/images/cloud/bookworm/20240102-1614/debian-12-genericcloud-amd64-20240102-1614.qcow2
```

Modify cloud image if needed. Instructions are based on this [gist](https://gist.github.com/yuuichi-fujioka/10952389).
Example for adding `qemu-guest-agent`.

```bash
apt-get install qemu-utils
modprobe nbd
qemu-nbd --connect=/dev/nbd0 /full/path/to/qcow2/image/file
mount /dev/nbd0p1 /mnt
mount -t proc proc /mnt/proc/
chroot /mnt
rm -f /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

# Make your changes
wget http://ftp.debian.org/debian/pool/main/q/qemu/qemu-guest-agent_7.2+dfsg-7+deb12u3_amd64.deb
dpkg -i qemu-guest-agent_7.2+dfsg-7+deb12u3_amd64.deb
rm -f qemu-guest-agent_7.2+dfsg-7+deb12u3_amd64.deb

exit
umount /mnt/proc
sync
umount /mnt
qemu-nbd --disconnect /dev/nbd0
```

Create new VM template.

```bash
export VM_ID=100          # VM ID that is not taken
export STORAGE=ZFS-mirror # Storage name in PVE that has disk image content enabled
export IMAGE=debian-12-genericcloud-amd64-20240102-1614.qcow2 # Downloaded image name
export NAME=Debian12CloudInit # Template name

qm create ${VM_ID} --name ${NAME} --net0 virtio,bridge=vmbr0
qm importdisk ${VM_ID} ${IMAGE} ${STORAGE}
qm set ${VM_ID} --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-$VM_ID-disk-0
qm set ${VM_ID} --ide2 ${STORAGE}:cloudinit
qm set ${VM_ID} --boot c --bootdisk scsi0
qm set ${VM_ID} --serial0 socket --vga serial0
qm set ${VM_ID} --agent enabled=1 # Optional but recommended
qm template ${VM_ID}
```

# Terraform

Got to terraform directory. Export env variables with authentification information for proxmox. Look into `env_example.sh`.

```bash
export PM_USER=terraform-prov@pve
export PM_PASS=<PASSWORD>
```

Run terraform code.

```terraform
terraform init
terraform plan
terraform apply
```

# Ansible playbooks

## k3s_provision.yml

Provisions new [K3S](https://k3s.io/) kubernetes cluster. It uses k3s quickstart script. For more information read official [documetation](https://docs.k3s.io/). Playbook is tested on debian 12 (bookworm) but should work with no or minimal modifications on other debian versions and debian based distros.

```bash
cd ansible
ansible-playbook playbooks/k3s_provision.yml
```

## docker.yml

Installs docker and docker-compose utilities. Pulls git repository configured in `ansible/group_vars/docker.yml` and runs docker-compose files from it. Docker compose environment variables are deployed from `ansible/playbooks/templates/docker.env.j2`.

Caddy container is used as reverse proxy for other services, so there are no need to expose ports. Caddy file is generated by ansible from jinja template. Self-signed wild card certificate is generated for caddy.

```bash
cd ansible
ansible-playbook playbooks/docker.yml
# For just updating docker services
ansible-playbook playbooks/docker.yml --tags docker
```

## pve_sysprep.yml

Apply basic system preparation changes for proxmox installations.

```bash
# Install ansible prometheus collection.
ansible-galaxy collection install prometheus.prometheus
cd ansible
ansible-playbook playbooks/pve_sysprep.yml
```

## os_update.yml

Update all debian inventory hosts.

```bash
cd ansible
ansible-playbook playbooks/os_update.yml
```
