FROM archlinux

LABEL maintainer="demonjun@foxmail.com"

USER root
WORKDIR /root

RUN sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen && \
    echo -e "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist && \
    echo -e "[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf && \
    pacman-key --init && \
    pacman-key --populate && \
    echo "Y" | pacman -Sy archlinuxcn-keyring --noconfirm && \
    pacman -Syu --noconfirm --needed base-devel curl wget git openssh sudo yay vim fish bash-completion && \
    chsh -s /usr/bin/fish

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

# install asdf
RUN git clone https://ghproxy.com/https://github.com/asdf-vm/asdf.git /opt/asdf --branch master && \
    echo ". /opt/asdf/asdf.sh" >> ~/.bashrc && \
    echo "source /opt/asdf/plugins/java/set-java-home.bash" >> ~/.bashrc && \
    echo "source /opt/asdf/asdf.fish" >> ~/.config/fish/config.fish && \
    echo "source /opt/asdf/plugins/java/set-java-home.fish" >> ~/.config/fish/config.fish && \
    mkdir -p ~/.config/fish/completions; and ln -s /opt/asdf/completions/asdf.fish ~/.config/fish/completions
 
COPY asdfrc ~/.asdfrc   

# asdf install nodejs java maven
RUN asdf plugin add java; asdf plugin add maven; asdf plugin add nodejs; \
    asdf install nodejs 21.1.0; \
    asdf install java temurin-21.0.1+12.0.LTS; \
    asdf install java temurin-17.0.9+9; \
    asdf install java temurin-11.0.21+9; \
    asdf install maven 3.9.5; \
    asdf global java temurin-11.0.21+9; \
    asdf global maven 3.9.5; \
    asdf global nodejs 21.1.0

# install docker 
RUN yay --aururl "https://mirrors.ustc.edu.cn/archlinuxcn" --save && \
    yay -Sy docker docker-compose --needed --noconfirm && \
    sudo pacman -Scc --noconfirm && \
    rm -rf .cache

EXPOSE 22

ENTRYPOINT [ "sudo", "/usr/bin/sshd", "-D"]
