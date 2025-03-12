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

##### 构建镜像

```bash
cd archlinux
docker build -t archlinux-dev .
```

##### 运行容器

基本用法：
```bash
docker run -it --name arch-dev archlinux-dev
```

启用SSH服务：
```bash
docker run -d -p 2222:2222 -e ENABLE_SSH=true --name arch-dev archlinux-dev
```

SSH连接信息：
- 端口：2222
- 用户：root 或 demon
- 密码：123456

##### 环境变量

- `ENABLE_SSH`: 设置为`true`启用SSH服务，默认为`false`


## 许可证

本项目采用 [Apache License 2.0](LICENSE) 许可证。
