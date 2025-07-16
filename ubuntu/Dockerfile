FROM lscr.io/linuxserver/code-server

LABEL maintainer="demonjun@foxmail.com"

# Setup Environment
ENV LANG=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    JAVA_HOME=/usr/local/java \
    MAVEN_HOME=/usr/local/maven \
    NODE_HOME=/usr/local/nodejs
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$PATH

USER root
WORKDIR /root

# Install all dependencies, tools, and clean up in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    # System utilities
    software-properties-common python3.12 python3-pip curl wget git openssh-client sudo vim fish bash-completion rsync socat tzdata locales unzip ca-certificates gpg python-is-python3 pgcli && \
    # --- Configure locale ---
    sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    # --- Install DevOps Tools ---
    # Docker
    wget https://download.docker.com/linux/static/stable/x86_64/docker-27.1.1.tgz -O /tmp/docker.tgz && \
    tar -xzf /tmp/docker.tgz -C /tmp && \
    mv /tmp/docker/* /usr/local/bin/ && \
    rmdir /tmp/docker && \
    # k9s
    curl -sL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar xz -C /usr/local/bin k9s && \
    # kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/ && \
    # helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    # --- Install Runtimes & SDKs ---
    # Eclipse Temurin JDK 17.0.14+7
    wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.14+7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.14_7.tar.gz -O /tmp/jdk.tar.gz && \
    mkdir -p /usr/local/java && \
    tar -xzf /tmp/jdk.tar.gz -C /usr/local/java --strip-components=1 && \
    # Maven 3.9.11
    wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz -O /tmp/maven.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -xzf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    # Node.js 24.1.0
    wget https://nodejs.org/dist/v24.1.0/node-v24.1.0-linux-x64.tar.xz -O /tmp/node.tar.xz && \
    mkdir -p /usr/local/nodejs && \
    tar -xJf /tmp/node.tar.xz -C /usr/local/nodejs --strip-components=1 && \
    # --- Install Global Node Packages ---
    npm install -g @anthropic-ai/claude-code @musistudio/claude-code-router && \
    # --- Final Setup & Cleanup ---
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Set default shell to fish
SHELL ["/usr/bin/fish", "-c"]