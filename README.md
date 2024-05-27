# RKE2 HA Stack

## Ansible Playbooks for High Availability Kubernetes with RKE2

This repository provides Ansible playbooks to automate the deployment of a highly available (HA) Kubernetes cluster using RKE2 (Rancher Kubernetes Engine 2). The stack integrates essential components for load balancing, service discovery, and certificate management.



-   **Load Balancing:** High availability with either MetalLB or kube-vip.
-   **Service Discovery:** Ensures consistent service access within the cluster.
-   **Certificate Management:** Automates SSL/TLS certificate issuance for secure communication.

## Features

-   **RKE2 Deployment:** Automated installation and configuration of an HA RKE2 cluster.
-   **kube-vip (Optional):** Provides a virtual IP address for the Kubernetes API server.
-   **MetalLB:** Adds load balancing functionality for external traffic.
-   **Cilium (Optional):** Offers advanced networking, observability, and security.
-   **Traefik (Optional):** Acts as an ingress controller for managing external access to services.
-   **Cert-Manager:** Automates certificate management and issuance for your cluster.

## Components

-   **RKE2:** A lightweight Kubernetes distribution by Rancher.
-   **kube-vip (Optional):** A virtual IP solution for high availability of the control plane.
-   **MetalLB:** A network load balancer implementation for Kubernetes using standard routing protocols.
-   **Cilium (Optional):** Provides networking, observability, and security using eBPF technology.
-   **Traefik (Optional):** A dynamic edge router for managing ingress traffic.
-   **Cert-Manager:** A native Kubernetes certificate management controller.

## System Requirements

-   **Control Node:** The machine running Ansible commands must have Ansible 2.11 or later installed.
-   **Ansible Collections:** Install required collections using:

### Clone this repository
```
git clone https://github.com/yourusername/rke2-ha-stack.git
cd rke2-ha-stack
```
### Install Ansible Collections

```
ansible-galaxy collection install -r ./collections/requirements.yml
```

-   **`netaddr` Package:** Ensure it's available to Ansible (usually included with apt installations). If using pip for Ansible, install `netaddr` in the virtual environment:


```
pip install netaddr
```

-   **Passwordless SSH:** Set up passwordless SSH access between the control node and server/agent nodes. Alternatively, provide credentials using `--ask-pass --ask-become-pass` when running Ansible commands.

## Getting Started

### Preparation

1.  **Create a new directory:**


```
cp -R inventory/sample inventory/my-cluster
```

2.  **Edit `inventory/my-cluster/hosts.ini`:** Configure your environment details (server/agent node IPs). Here's an example with HA RKE2 on three master nodes:

```
[masters]
master1 ansible_host=192.168.10.31
master2 ansible_host=192.168.10.32
master3 ansible_host=192.168.10.33

[rke2_cluster:children]
masters
```

3.  **Copy and configure `ansible.cfg`:**


```
cp ansible.example.cfg ansible.cfg
```

-   Update the inventory path within `ansible.cfg` to point to your newly created directory.

4.  **Optional:** Edit `inventory/my-cluster/group_vars/all.yml` to customize variables for your deployment.

### Create Cluster

Deploy the cluster using the following command, replacing `inventory/my-cluster/hosts.ini` with your actual inventory file path:

```
ansible-playbook site.yml -i inventory/my-cluster/hosts.ini
```

After deployment, the control plane will be accessible via the virtual IP address defined in `inventory/group_vars/all.yml` (usually under `apiserver_endpoint`).

### Remove RKE2 Cluster

To remove the deployed RKE2 cluster, run:

```
ansible-playbook reset.yml -i inventory/my-cluster/hosts.ini
```

**Important:** It's recommended to reboot the nodes after removing the cluster due to the VIP not being automatically destroyed.

### Kube Config

Copy your kubeconfig locally for accessing the Kubernetes cluster:

```
scp ubuntu@master_ip:/etc/rancher/rke2/rke2.yaml ~/.kube/config
```

**Permission Issues:**

If you encounter permission errors, temporarily grant read permissions:



```
sudo chmod 777 /etc/rancher/rke2/rke2.yaml
```
Copy the file again and then reset the permissions:

```
sudo chmod 600 /etc/rancher/rke2/rke2.yaml
```

Modify the config to point to the master IP:
```
sudo nano ~/.kube/config
```
Change server: https://127.0.0.1:6443 to match your master IP: server: https://192.168.10.111:6443.

Testing Your Cluster

Testing the Playbook Using Molecule

This playbook includes a Molecule-based test setup. It is run automatically in CI, but you can also run the tests locally. This might be helpful for quick feedback in a few cases. You can find more information about it here.

Pre-commit Hooks

This repo uses pre-commit and pre-commit-hooks to lint and fix common style and syntax errors. Be sure to install Python packages and then run pre-commit install. For more information, see pre-commit.

Ansible Galaxy

This collection can now be used in larger Ansible projects.

Instructions:

Create or modify a file collections/requirements.yml in your project:

```
collections:
  - name: ansible.utils
  - name: community.general
  - name: ansible.posix
  - name: kubernetes.core
  - name: https://github.com/imaginestack/collections/rke2-ha-stack
    type: git
    version: master
```

Install via 
```
ansible-galaxy collection install -r ./collections/requirements.yml
```


Thanks! Special thanks to the contributors and the community for their valuable input and support.