# Clone repo and checkout release
```bash
mkdir ~/osh_demo_kubespray
cd ~/osh_demo_kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout -b release-2.25
git reset --hard v2.25.0
```

# Prepare venv
```bash
python -m venv kubespray_venv
source kubespray_venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install community.general --upgrade
```

# Deploy K8s
## Prerequisits
- 2 nodes
- Ubuntu 22.04
- 2 CPUs
- 8GB RAM
- 30GB /
- 15GB additional disk /dev/vdb

## Prepare inventory
### Copy sample inventory and define hosts
```bash
cp -rfp inventory/sample inventory/mycluster
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py <ip_1> <ip_2> <ip_3>
```
### Specify parameters
#### inventory/mycluster/group_vars/all/ssh_key.yaml
```yaml
ansible_user: root
ansible_ssh_private_key_file: /home/vlad/.ssh/id_ed25519
ansible_ssh_extra_args: -o StrictHostKeyChecking=no
```
#### inventory/mycluster/group_vars/all/all.yml
```yaml
upstream_dns_servers:
  - 8.8.8.8
```
#### inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
```yaml
kube_network_plugin: flannel
kube_service_addresses: "10.96.0.0/16"
kube_pods_subnet: "10.244.0.0/16"
```

## Run deployment playbook
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml

# Deploy Openstack
## Copy scripts to node-1
```bash
cd ~/osh_demo_kubespray
git clone https://github.com/kozhukalov/osh_kubespray.git
cd ~/osh_demo_kubespray/osh_kubespray
rsync -rlt scripts root@<ip_1>:
```

## Run scripts
Connect via ssh to node-1:
```bash
ssh root@<ip_1>
```

and run the following:
```bash
cd ~/scripts
./prepare_k8s.sh
./prepare_helm.sh
./prepare_overrides.sh
./deploy_ingress.sh
./deploy_ceph.sh
./deploy_ceph-adapter-rook.sh
./deploy_metallb.sh
./deploy_openstack.sh
./deploy_openstack_public_endpoint.sh
```
