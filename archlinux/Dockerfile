FROM archlinux

LABEL maintainer="demonjun@foxmail.com"

ENV LANG=en_US.UTF-8

USER root
WORKDIR /root

RUN pacman -Syyu archlinux-keyring --noconfirm && \
    pacman-key --init && \
    pacman-key --populate 

RUN echo -e "[archlinuxcn]\nServer = https://repo.archlinuxcn.org/\$arch" >> /etc/pacman.conf && \
    pacman-key --lsign farseerfc@archlinux.org && \
    echo "Y" | pacman -Sy archlinuxcn-keyring --noconfirm && \
    pacman -Syu --noconfirm --needed base-devel curl wget git openssh sudo yay vim fish bash-completion rsync xorg xorg-xauth socat

# enable ssh
RUN groupadd demon && useradd -mg root demon && \
    echo -e "123456\n123456" | passwd root && \
    echo -e "123456\n123456" | passwd demon && \
    echo "demon ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/demon && \
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

# install docker kubectl helm k9s pgcli
RUN yay -Sy docker docker-compose docker-buildx python python-pip kubectl helm k9s pgcli --needed --noconfirm 

# install vfox
RUN curl -sSf https://raw.githubusercontent.com/version-fox/vfox/main/install.sh | bash && \
    echo 'eval "$(vfox activate bash)"' >> /root/.bashrc && \
    mkdir -p /root/.config/fish && \
    echo 'vfox activate fish | source' >> /root/.config/fish/config.fish; \
    vfox add nodejs java maven 

# install nodejs java maven using vfox
RUN vfox install nodejs@23.9.0 ; \
    vfox install maven@3.9.9 ;\    
    vfox install java@21.0.6+7-tem ; \
    vfox install java@17.0.14+7-tem ; \
    vfox install java@11.0.26+4-tem

# download vs-code-server
COPY download-vs-code-server.sh /opt/scripts/download-vs-code-server.sh
RUN chmod +x /opt/scripts/download-vs-code-server.sh; \
    /opt/scripts/download-vs-code-server.sh linux

# clean cache
RUN pacman -Scc --noconfirm && \
    rm -rf .cache    

# 设置默认 shell 为 fish
RUN chsh -s /usr/bin/fish root && \
    chsh -s /usr/bin/fish demon

COPY entrypoint.sh /opt/scripts/entrypoint.sh
COPY change_repo_to_cn.sh /opt/scripts/change_repo_to_cn.sh
RUN chmod +x /opt/scripts/*

# 设置构建时的默认 shell
SHELL ["/usr/bin/fish", "-c"]

EXPOSE 2222 8080
ENV ENABLE_SSH=false

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
