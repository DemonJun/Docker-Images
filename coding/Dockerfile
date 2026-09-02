FROM ubuntu:24.04

LABEL maintainer="demonjun@foxmail.com"

ENV ENABLE_SSH=true \
    LANG=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    JAVA_HOME=/usr/local/java \
    MAVEN_HOME=/usr/local/maven \
    NODE_HOME=/usr/local/nodejs \
    BUN_INSTALL=/usr/local/bun \
    BUN_INSTALL_BIN=/usr/local/bun/bin \
    HOME=/root

ENV PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${NODE_HOME}/bin:${BUN_INSTALL}/bin:/usr/local/bin:${PATH}"

USER root
WORKDIR /root

# ============================================================
# Ubuntu 24.04 APT 源
#
# 使用 USTC HTTP 源。
#
# 这里不要直接使用 HTTPS：
# Ubuntu 最小镜像在 ca-certificates 未安装/不可用时，
# HTTPS APT 源可能因为证书验证失败导致 apt-get update 失败。
#
# APT 软件包本身仍然通过 Ubuntu 仓库的 GPG/InRelease
# 签名进行完整性和来源校验。
# ============================================================

RUN cat > /etc/apt/sources.list.d/ubuntu.sources <<'EOF'
Types: deb
URIs: http://mirrors.ustc.edu.cn/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://mirrors.ustc.edu.cn/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

# ============================================================
# 基础软件
# ============================================================

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common \
      python3.12 \
      python3.12-dev \
      python3-pip \
      python-is-python3 \
      curl \
      wget \
      git \
      openssh-client \
      openssh-server \
      sudo \
      vim \
      fish \
      bash-completion \
      rsync \
      socat \
      tzdata \
      locales \
      unzip \
      ca-certificates \
      gpg \
      pgcli \
      xz-utils \
      gcc \
      g++ \
      make \
      pkg-config \
      build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ============================================================
# Python / node-gyp
# ============================================================

ENV PYTHON=/usr/bin/python3 \
    npm_config_python=/usr/bin/python3

RUN python3 --version && \
    python --version && \
    pip3 --version

# ============================================================
# SSH + locale
# ============================================================

RUN echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    mkdir -p /run/sshd && \
    chmod 0755 /run/sshd && \
    sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

# ============================================================
# Versions
# ============================================================

ARG DOCKER_VERSION=29.4.3

ARG JDK17_VERSION=17.0.19+10
ARG JDK17_VERSION_UNDERSCORE=17.0.19_10

ARG MAVEN_VERSION=3.9.16

ARG NODE_VERSION=24.15.0

# ============================================================
# herdr
# ============================================================

RUN ARCH="$(uname -m)" && \
    case "$ARCH" in \
      x86_64|amd64) \
        ASSET="herdr-linux-x86_64" \
        ;; \
      aarch64|arm64) \
        ASSET="herdr-linux-aarch64" \
        ;; \
      *) \
        echo "Unsupported architecture: $ARCH" && \
        exit 1 \
        ;; \
    esac && \
    wget \
      -O /usr/local/bin/herdr \
      "https://github.com/herdrdev/herdr/releases/latest/download/${ASSET}" && \
    chmod +x /usr/local/bin/herdr && \
    herdr --version || true

# ============================================================
# JDK 17
# ============================================================

RUN wget \
      "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JDK17_VERSION}/OpenJDK17U-jdk_x64_linux_hotspot_${JDK17_VERSION_UNDERSCORE}.tar.gz" \
      -O /tmp/jdk.tar.gz && \
    mkdir -p "${JAVA_HOME}" && \
    tar -xzf /tmp/jdk.tar.gz \
      -C "${JAVA_HOME}" \
      --strip-components=1 && \
    rm -f /tmp/jdk.tar.gz && \
    java -version && \
    javac -version

# ============================================================
# Maven
# ============================================================

RUN wget \
      "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
      -O /tmp/maven.tar.gz && \
    mkdir -p "${MAVEN_HOME}" && \
    tar -xzf /tmp/maven.tar.gz \
      -C "${MAVEN_HOME}" \
      --strip-components=1 && \
    rm -f /tmp/maven.tar.gz && \
    mvn --version

# ============================================================
# Node.js
# ============================================================

RUN wget \
      "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
      -O /tmp/node.tar.xz && \
    mkdir -p "${NODE_HOME}" && \
    tar -xJf /tmp/node.tar.xz \
      -C "${NODE_HOME}" \
      --strip-components=1 && \
    rm -f /tmp/node.tar.xz && \
    node --version && \
    npm --version

# ============================================================
# npm
# ============================================================

RUN npm install -g npm@latest && \
    npm --version

# ============================================================
# Bun
# ============================================================

RUN mkdir -p "${BUN_INSTALL}" "${BUN_INSTALL}/bin" && \
    curl -fsSL https://bun.sh/install | \
      bash -s -- "bun-v1.4.0" && \
    command -v bun && \
    bun --version && \
    /usr/bin/env bun --version

# ============================================================
# OMP
# ============================================================

RUN bun install -g @oh-my-pi/pi-coding-agent && \
    command -v omp && \
    omp --version

# ============================================================
# OMP 依赖信任
# ============================================================

RUN bun pm -g untrusted || true

RUN bun pm -g trust --all && \
    /usr/bin/env bun --version && \
    omp --version

# ============================================================
# OMP plugins
# ============================================================

RUN mkdir -p /root/.omp && \
    omp plugin install context-mode && \
    omp plugin install omp-cache-optimizer && \
    omp plugin install npm:pi-rtk-optimizer && \
    omp plugin install git:github.com/DietrichGebert/ponytail

# ============================================================
# Entrypoint
# ============================================================

COPY entrypoint.sh /entrypoint.sh

# ============================================================
# Bash / Fish 环境变量
# ============================================================

RUN chmod +x /entrypoint.sh && \
    printf '%s\n' \
      '' \
      '# Java' \
      'export JAVA_HOME=/usr/local/java' \
      '' \
      '# Maven' \
      'export MAVEN_HOME=/usr/local/maven' \
      '' \
      '# Node.js' \
      'export NODE_HOME=/usr/local/nodejs' \
      '' \
      '# Bun' \
      'export BUN_INSTALL=/usr/local/bun' \
      'export BUN_INSTALL_BIN=/usr/local/bun/bin' \
      '' \
      '# PATH' \
      'export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$BUN_INSTALL/bin:/usr/local/bin:$PATH' \
      >> /root/.bashrc && \
    mkdir -p /root/.config/fish && \
    printf '%s\n' \
      '' \
      '# Java' \
      'set -gx JAVA_HOME /usr/local/java' \
      '' \
      '# Maven' \
      'set -gx MAVEN_HOME /usr/local/maven' \
      '' \
      '# Node.js' \
      'set -gx NODE_HOME /usr/local/nodejs' \
      '' \
      '# Bun' \
      'set -gx BUN_INSTALL /usr/local/bun' \
      'set -gx BUN_INSTALL_BIN /usr/local/bun/bin' \
      '' \
      '# PATH' \
      'fish_add_path /usr/local/bin' \
      'fish_add_path $BUN_INSTALL/bin' \
      'fish_add_path $NODE_HOME/bin' \
      'fish_add_path $MAVEN_HOME/bin' \
      'fish_add_path $JAVA_HOME/bin' \
      >> /root/.config/fish/config.fish

# ============================================================
# Runtime
# ============================================================

SHELL ["/usr/bin/fish"]

WORKDIR /root

EXPOSE 2222 8080

ENTRYPOINT ["/entrypoint.sh"]
