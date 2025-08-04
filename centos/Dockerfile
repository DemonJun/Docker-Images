# 构建阶段
FROM centos:7 AS builder

# 安装构建Python所需的依赖, 下载、编译和安装Python
RUN sed -i.bak \
    -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos|g' \
    /etc/yum.repos.d/CentOS-Base.repo && \
    yum makecache && \
    yum update -y && \
    yum install -y gcc make openssl-devel zlib-devel bzip2-devel sqlite-devel libffi-devel xz-devel wget tar binutils 

RUN wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz && \
    tar -xzf Python-3.12.2.tgz && \
    cd Python-3.12.2 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.12.2 Python-3.12.2.tgz
