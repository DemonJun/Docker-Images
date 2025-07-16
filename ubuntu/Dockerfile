FROM lscr.io/linuxserver/code-server

LABEL maintainer="demonjun@foxmail.com"

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

USER root
WORKDIR /root

# install common tools
RUN apt-get update && apt-get install -y software-properties-common && \
    apt-get install -y python3.12 python3-pip curl wget git openssh-server sudo vim fish bash-completion rsync socat tzdata locales unzip && \
    sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

# enable ssh
RUN echo "root:123456" | chpasswd && \
    rm -f /etc/ssh/ssh_*_key &&\
    ssh-keygen -A && \
    sed -i \
    -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
    -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
    -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
    -e 's/^#*\(UsePAM\) .*/\1 no/' \
    -e 's/^#*\(X11Forwarding\) .*/\1 yes/' \
    -e 's/^#*\(X11DisplayOffset\) .*/\1 10/' \
    -e 's/^#*\(X11UseLocalhost\) .*/\1 yes/' \
    -e 's/^#*\(AllowAgentForwarding\) .*/\1 yes/' \
    -e 's/^#*\(AllowTcpForwarding\) .*/\1 yes/' \
    -e 's/^#*\(Port\) .*/\1 2222/' \
    /etc/ssh/sshd_config

# install docker pgcli k9s
RUN curl -fsSL https://get.docker.com | sh -s -- && \
    apt-get install -y python-is-python3 pgcli && \
    curl -sL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar xz -C /usr/local/bin k9s

# install kubectl helm
RUN mkdir -p /usr/local/bin && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 

# install Eclipse Temurin JDK 17
RUN apt-get install -y ca-certificates && \
    mkdir -p /etc/apt/keyrings && \
    wget -O - https://packages.eclipse.org/keys/adoptium.asc | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.eclipse.org/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" | tee /etc/apt/sources.list.d/adoptium.list > /dev/null && \
    apt-get update && \
    apt-get install -y temurin-17-jdk

# install maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xvf apache-maven-3.9.9-bin.tar.gz && \
    rm apache-maven-3.9.9-bin.tar.gz && \
    mv apache-maven-3.9.9 /usr/local/maven

# install nodejs
RUN wget https://nodejs.org/dist/v24.1.0/node-v24.1.0-linux-x64.tar.xz && \
    tar -xvf node-v24.1.0-linux-x64.tar.xz && \
    rm node-v24.1.0-linux-x64.tar.xz && \
    mv node-v24.1.0-linux-x64 /usr/local/nodejs

# set env
ENV JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
ENV MAVEN_HOME=/usr/local/maven
ENV NODE_HOME=/usr/local/nodejs
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$PATH

# install claude-code
RUN npm install -g @anthropic-ai/claude-code @musistudio/claude-code-router

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置默认 shell 为 fish
SHELL ["/usr/bin/fish", "-c"]

