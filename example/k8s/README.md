# Deploying Iroha on the cluster

(This file is partial copy from [Deploying Iroha on Kubernetes cluster](https://github.com/hyperledger/iroha/blob/feature/k8s-oss/docs/source/guides/k8s-deployment.rst))

Make sure you have configuration files in deploy/ansible/roles/iroha-k8s/files. Specifically, non-empty conf directory and k8s-iroha.yaml file.

There are two options for managing k8s cluster: logging into either of master node and executing commands there or configure remote management. We will cover the second option here as the first one is trivial.

In case you set up cluster using Kubespray, you can find admin.conf file on either of master node in /etc/kubernetes directory. Copy this file on the control machine (the one you will be running kubectl command from). Make sure server parameter in this file points to external IP address or DNS name of a master node. Usually, there is a private IP address of the node (in case of AWS). Make sure kubectl utility is installed (check out the docs for instructions).

Replace the default kubectl configuration:

```
export KUBECONFIG=<PATH_TO_admin.conf>
```
We can now control the remote k8s cluster

k8s-iroha.yaml pod specification file requires to create a config-map first. This is a special resource that is mounted into each pod, and contains keys and configuration files required to run Iroha.

```
kubectl create configmap iroha-config --from-file=deploy/ansible/roles/iroha-k8s/files/conf/
```

Attention!

We store all the keys in a single config-map. This greatly simplifies the deployment, but suits only for proof-of-concept purposes as each node would have an access to private keys of others.

Deploy Iroha network pod specification:

```
kubectl create -f deploy/ansible/roles/iroha-k8s/files/k8s-iroha.yaml
```

Wait a moment before each node downloads and starts Docker containers. Executing kubectl get pods command should eventually return a list of deployed pods each in Running state.

Hint

Pods do not expose ports externally. You need to connect to Iroha instance by its hostname (iroha-0, iroha-1, etc). For that you have to have a running pod in the same network.
