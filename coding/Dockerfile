FROM ubuntu:24.04

LABEL maintainer="demonjun@foxmail.com"
ENV ENABLE_SSH true
# Setup Environment
ENV LANG=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  TZ=Asia/Shanghai \
  JAVA_HOME=/usr/local/java \
  MAVEN_HOME=/usr/local/maven \
  NODE_HOME=/usr/local/nodejs

ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$PATH

# Tool versions (bump these to update)
ARG DOCKER_VERSION=29.4.3
ARG JDK17_VERSION=17.0.19+10
ARG JDK17_VERSION_UNDERSCORE=17.0.19_10
ARG MAVEN_VERSION=3.9.15
ARG NODE_VERSION=24.15.0

USER root
WORKDIR /root

# Install all dependencies, tools, and clean up in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends  \
  # System utilities    \
  software-properties-common python3.12 python3-pip curl wget git openssh-client sudo vim fish bash-completion rsync socat tzdata locales unzip ca-certificates gpg python-is-python3 pgcli xz-utils openssh-server gcc make && \
  # --- Final Setup & Cleanup ---
  apt-get clean -y&& \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN echo 'root:root' | chpasswd && \
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
  sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
  mkdir -p /run/sshd && chmod 0755 /run/sshd && \
  # --- Configure locale ---
  sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
  locale-gen && \
  # --- Install DevOps Tools ---
  ARCH="$(uname -m)" && \
      case "$ARCH" in \
        x86_64|amd64) ASSET="herdr-linux-x86_64" ;; \
        aarch64|arm64) ASSET="herdr-linux-aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
      esac && \
      wget -O /usr/local/bin/herdr \
        "https://github.com/herdrdev/herdr/releases/latest/download/${ASSET}" && \
      chmod +x /usr/local/bin/herdr \
  # --- Install Runtimes & SDKs ---
  # Eclipse Temurin JDK ${JDK17_VERSION}
  wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JDK17_VERSION}/OpenJDK17U-jdk_x64_linux_hotspot_${JDK17_VERSION_UNDERSCORE}.tar.gz -O /tmp/jdk.tar.gz && \
  mkdir -p /usr/local/java && \
  tar -xzf /tmp/jdk.tar.gz -C /usr/local/java --strip-components=1 && \
  # Maven ${MAVEN_VERSION}
  wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
  mkdir -p /usr/local/maven && \
  tar -xzf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
  # Node.js ${NODE_VERSION}
  wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz -O /tmp/node.tar.xz && \
  mkdir -p /usr/local/nodejs && \
  tar -xJf /tmp/node.tar.xz -C /usr/local/nodejs --strip-components=1 && \
  npm install -g npm@latest && \
  # --- Install Global Node Packages ---
  npm install -g @oh-my-pi/pi-coding-agent && \
  omp plugin install context-mode && \
  omp plugin install omp-cache-optimizer && \
  omp install npm:pi-rtk-optimizer && \
  omp install git:github.com/DietrichGebert/ponytail

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
  # Configure PATH for bash
  echo 'export JAVA_HOME=/usr/local/java' >> /root/.bashrc && \
  echo 'export MAVEN_HOME=/usr/local/maven' >> /root/.bashrc && \
  echo 'export NODE_HOME=/usr/local/nodejs' >> /root/.bashrc && \
  echo 'export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$PATH' >> /root/.bashrc && \
  # Configure PATH for fish
  mkdir -p /root/.config/fish && \
  echo 'set -gx JAVA_HOME /usr/local/java' >> /root/.config/fish/config.fish && \
  echo 'set -gx MAVEN_HOME /usr/local/maven' >> /root/.config/fish/config.fish && \
  echo 'set -gx NODE_HOME /usr/local/nodejs' >> /root/.config/fish/config.fish && \
  echo 'fish_add_path $JAVA_HOME/bin $MAVEN_HOME/bin $NODE_HOME/bin' >> /root/.config/fish/config.fish

# Set default shell to fish
SHELL ["/usr/bin/fish"]
# Set default working directory
WORKDIR /root

# Expose port
EXPOSE 2222 8080
ENTRYPOINT ["/entrypoint.sh"]
