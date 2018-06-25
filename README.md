### Kubernetes Cluster 

#### 1. Pre installation

##### 系统环境

- Linux内核:4.11
- Linux发行版: Centos7.3
- Docker data FS: XFS
- Docker: 17.3
- Docker storage driver: overlay2
- kubernetes: 1.9.1
- flannel: 0.9.1
- etcd: 3.1.10
- TLS: True
- RBAC: True

##### 环境准备

- 安装epel源

```shell
yum install epel-release -y
```
- 安装python-pip

```shell
yum install python-pip -y
```

- 安装ansible

```shell
pip install ansible==2.5.1 -i https://pypi.douban.com/simple
```

- 环境配置

本环境所有环境配置变量均在inventory/group_vars/all.yaml配置文件中.

**1. 下载依赖包到本地**

   部署前deploy-local.sh 下载包及解压,kubernetes及etcd版本可通过inventory/group_vars/all.yaml# downloads修改
   
#### 2. 部署k8s基础环境

1 生成集群TLS证书

  更新inventory/inventory文件,修改正确的可ssh连接的master、node、etcd的IP地址.
  执行scripts/deploy-ssl.sh,会生成集群SSL文件存放在.ssl目录中.用于kubernetes以及etc大集群TLS认证通信.

```shell
bash deploy-ssl.sh
```

3 部署ETCD集群

   目前是etcd和maste节点混部。scripts/deploy-etd.sh脚本即可部署。此过程会安装etcd集群、同步TLS证书及etcd配置文件。。

```shell
bash deploy-etcd.sh
```
   测试部署是否成功,查看etcd集群状态信息

```shell
bash deploy-etcd.sh --tags status 
```
   
4 部署master

   scripts/deploy-master.sh 脚本部署master.此过程会安装flanneld、master相关组件。会同步TLS证书、master配置文件.部署完之后观察ELB后台实例是否健康检查成功

```shell
bash deploy-master.sh
```

   测试部署是否成功,查看kubernetes控制节点状态信息

```shell
bash deploy-master.sh --tags status 
```
   
5 部署node

   scripts/deploy-node.sh 脚本部署node节点.此过程会安装依赖、docker、flanneld、kubelet、kube-proxy.
```shell
bash deploy-master.sh
```
   测试部署是否成功,查看node节点是够加入集群

```shell
bash deploy-master.sh --tags status 
```
   
6 部署flannel

   由于master和node节点都依赖flannel。所以在master和node role中已经添加在dependency中.

   测试部署是否成功,可分别在两台机器分别启动两个容器，互相ping操作即可.

```shell
docker run -it --rm busybox /bin/sh
# #ping对端容器IP
/ #ping 172.30.104.2
/ # ping 172.30.104.2
PING 172.30.104.2 (172.30.104.2): 56 data bytes
64 bytes from 172.30.104.2: seq=0 ttl=62 time=1.101 ms
64 bytes from 172.30.104.2: seq=1 ttl=62 time=0.675 ms
64 bytes from 172.30.104.2: seq=2 ttl=62 time=0.546 ms
^C
--- 172.30.104.2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.546/0.774/1.101 ms
```

部署完毕


#### 3. 添加1个Node机器

1. 将新添加的机器IP更新到 inventory文件nodes group中，开始部署。

    ```shell
    bash deploy-node.sh
    ```
2. 检查确认是否加入成功

    ```shell
    bash deploy-node.sh --tags status
    ```



#### 4. 下架一台机器

1. 将服务器调度状态变更为不可调度，避免在驱逐pod过程中，新的pod被调度进来

    ```shell
    kubectl cordon node $node
    ```
2. 驱逐当前Node节点上面运行的pod到其他节点

    ```shell
    kubectl drain $node [--ignore-daemonsets=true|--delete-local-data=true|--force=|true]
    ```
3. 从集群中移除
    ```shell
    kubectl delete node $node
    ```
    
    


