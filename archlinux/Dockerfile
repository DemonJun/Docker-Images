FROM archlinux

LABEL maintainer="demonjun@foxmail.com"

ENV LANG en_US.UTF-8

USER root
WORKDIR /root

RUN echo -e "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist && \
    pacman -Syyu --noconfirm && \
    pacman-key --init && \
    pacman-key --populate 

RUN echo -e "[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf && \
    echo "Y" | pacman -Sy archlinuxcn-keyring --noconfirm && \
    pacman -Syu --noconfirm --needed base-devel curl wget git openssh sudo yay vim fish bash-completion rsync

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
    /etc/ssh/sshd_config && \
    systemctl enable sshd

# install docker kubectl helm
RUN yay --aururl "https://mirrors.ustc.edu.cn/archlinuxcn" --save && \
    yay -Sy docker docker-compose kubectl helm --needed --noconfirm 

# install asdf
RUN git clone https://github.com/asdf-vm/asdf.git /opt/asdf --branch master 

# asdf install nodejs java maven
RUN source /opt/asdf/asdf.sh && \
    asdf plugin add java && asdf plugin add maven && asdf plugin add nodejs && \
    asdf install nodejs 21.1.0 && \
    asdf install java temurin-21.0.1+12.0.LTS && \
    asdf install java temurin-17.0.9+9 && \
    asdf install java temurin-11.0.21+9 && \
    asdf install maven 3.9.5 && \
    asdf global java temurin-11.0.21+9 && \
    asdf global maven 3.9.5 && \
    asdf global nodejs 21.1.0

# config asdf in bash and fish
RUN fish ; \
    echo ". /opt/asdf/asdf.sh" >> ~/.bashrc && \
    echo "source ~/.asdf/plugins/java/set-java-home.bash" >> ~/.bashrc && \
    echo "source /opt/asdf/asdf.fish" >> ~/.config/fish/config.fish && \
    echo "source ~/.asdf/plugins/java/set-java-home.fish" >> ~/.config/fish/config.fish && \
    mkdir -p ~/.config/fish/completions && \
    ln -s /opt/asdf/completions/asdf.fish ~/.config/fish/completions/asdf.fish

# install conda
RUN yay -Sy miniconda --noconfirm

# clean cache
RUN sudo pacman -Scc --noconfirm && \
    rm -rf .cache    

COPY set-locale-utf8.sh /opt/scripts/set-locale-utf8.sh
RUN chmod +x /opt/scripts/*
COPY asdfrc ~/.asdfrc   

EXPOSE 22

ENTRYPOINT [ "sudo", "/usr/bin/sshd", "-D"]
