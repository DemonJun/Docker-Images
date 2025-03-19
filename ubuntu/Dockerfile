FROM ubuntu:24.10

LABEL maintainer="demonjun@foxmail.com"

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

USER root
WORKDIR /root

# install common tools
RUN apt-get update && apt-get install -y software-properties-common && \
    apt-get install -y python3.12 python3-pip curl wget git openssh-server sudo vim fish bash-completion rsync socat tzdata locales && \
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

# install vfox
RUN curl -sSf https://raw.githubusercontent.com/version-fox/vfox/main/install.sh | bash && \
    echo 'eval "$(vfox activate bash)"' >> /root/.bashrc && \
    mkdir -p /root/.config/fish && \
    echo 'vfox activate fish | source' >> /root/.config/fish/config.fish; \
    vfox add nodejs java maven 

# install nodejs java maven using vfox
RUN vfox install nodejs@23.9.0 ; \
    vfox install java@21.0.6+7-tem ; \
    vfox install java@17.0.14+7-tem ; \
    vfox install java@11.0.26+4-tem ; \
    vfox install maven@3.9.9 

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置默认 shell 为 fish
RUN chsh -s /usr/bin/fish root

COPY entrypoint.sh /opt/scripts/entrypoint.sh
RUN chmod +x /opt/scripts/*

# 设置构建时的默认 shell
SHELL ["/usr/bin/fish", "-c"]

EXPOSE 2222 8080
ENV ENABLE_SSH=false

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
