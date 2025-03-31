# Docker-Images

这个仓库包含了各种定制的Docker镜像，用于开发和部署环境。

## 镜像列表

### 1. Arch Linux 开发环境

基于Arch Linux的开发环境，预装了多种开发工具和语言运行时。

#### 特性

- 基于最新的Arch Linux
- 预配置了国内镜像源（USTC）
- 预装开发工具：
  - Git, SSH, Vim, Fish shell
  - Docker, Docker Compose, Docker Buildx
  - Kubectl, Helm, K9s
  - Python, pip
  - pgcli（PostgreSQL命令行工具）
- 预装Version Fox (vfox)版本管理工具
- 预装多个Java版本：
  - Java 21 (Temurin)
  - Java 17 (Temurin)
  - Java 11 (Temurin)
- 预装Node.js 23.9.0
- 预装Maven 3.9.9
- 预配置VS Code Server
- 支持SSH访问（可选启用）
- 支持X11转发

#### 使用方法

##### 获取镜像

从 DockerHub 拉取：
```bash
docker pull jundemon/archlinux:dev
```

##### 构建镜像

```bash
cd archlinux
docker build -t jundemon/archlinux:dev .
```

##### 运行容器

基本用法：
```bash
docker run -it --name arch-dev jundemon/archlinux:dev
```

启用SSH服务：
```bash
docker run -d -p 2222:2222 -e ENABLE_SSH=true --name arch-dev jundemon/archlinux:dev
```

SSH连接信息：
- 端口：2222
- 用户：root 或 demon
- 密码：123456

##### 环境变量

- `ENABLE_SSH`: 设置为`true`启用SSH服务，默认为`false`

### 2. Ubuntu 开发环境

基于 Ubuntu 24.10 的开发环境，预装了多种开发工具和语言运行时。

#### 特性

- 基于 Ubuntu 24.10
- 预装开发工具：
  - Git, SSH, Vim, Fish shell
  - Docker
  - Kubectl, Helm, K9s
  - Python 3.12, pip
  - pgcli（PostgreSQL命令行工具）
- 预装Version Fox (vfox)版本管理工具
- 预装多个Java版本：
  - Java 21 (Temurin)
  - Java 17 (Temurin)
  - Java 11 (Temurin)
- 预装Node.js 23.9.0
- 预装Maven 3.9.9
- 支持SSH访问（可选启用）
- 支持X11转发

#### 使用方法

##### 获取镜像

从 DockerHub 拉取：
```bash
docker pull jundemon/ubuntu:dev
```

##### 构建镜像

```bash
cd ubuntu
docker build -t jundemon/ubuntu:dev .
```

##### 运行容器

基本用法：
```bash
docker run -it --name ubuntu-dev jundemon/ubuntu:dev
```

启用SSH服务：
```bash
docker run -d -p 2222:2222 -e ENABLE_SSH=true --name ubuntu-dev jundemon/ubuntu:dev
```

SSH连接信息：
- 端口：2222
- 用户：root
- 密码：123456

##### 环境变量

- `ENABLE_SSH`: 设置为`true`启用SSH服务，默认为`false`

### 3. Apache Flink 环境

基于 Eclipse Temurin 的 Apache Flink 运行环境，提供不同版本的 Flink。

#### 特性

- 基于 Eclipse Temurin JDK 17 (Ubuntu Jammy)
- 支持 amd64 和 arm64 架构
- 预装 Apache Flink 多个版本：
  - Flink 1.20
  - Flink 2.0

#### 使用方法

##### 获取镜像

从 DockerHub 拉取特定版本：
```bash
# Flink 1.20
docker pull jundemon/flink:1.20
# 或明确指定 JDK 和系统版本
docker pull jundemon/flink:1.20-jdk-jammy

# Flink 2.0
docker pull jundemon/flink:2.0
# 或明确指定 JDK 和系统版本
docker pull jundemon/flink:2.0-jdk-jammy
```

##### 运行 JobManager

```bash
docker run -d \
    --name=jobmanager \
    --network host \
    -e JOB_MANAGER_RPC_ADDRESS=localhost \
    jundemon/flink:2.0 jobmanager
```

##### 运行 TaskManager

```bash
docker run -d \
    --name=taskmanager \
    --network host \
    -e JOB_MANAGER_RPC_ADDRESS=localhost \
    jundemon/flink:2.0 taskmanager
```

##### 使用 Docker Compose

创建 docker-compose.yml 文件：
```yaml
version: '3'
services:
  jobmanager:
    image: jundemon/flink:2.0
    ports:
      - "8081:8081"
    command: jobmanager
    environment:
      - JOB_MANAGER_RPC_ADDRESS=jobmanager
  
  taskmanager:
    image: jundemon/flink:2.0
    depends_on:
      - jobmanager
    command: taskmanager
    environment:
      - JOB_MANAGER_RPC_ADDRESS=jobmanager
```

启动集群：
```bash
docker-compose up -d
```

## 自动构建

本仓库使用 GitHub Actions 自动构建并推送 Docker 镜像。每当 `archlinux`、`ubuntu` 或 `flink` 目录中的文件发生变更并推送到 `main` 分支时，或者手动触发工作流时，都会自动构建并推送镜像到 DockerHub。

### 设置自动构建

要启用自动构建，需要在 GitHub 仓库的 Secrets 中设置以下变量：

1. `DOCKERHUB_TOKEN`: DockerHub 的访问令牌，用于推送镜像到 DockerHub

## 许可证

本项目采用 [Apache License 2.0](LICENSE) 许可证。
