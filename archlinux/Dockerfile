FROM archlinux:base-devel

LABEL maintainer="demonjun@foxmail.com"

RUN sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen && \
    sed -i '1 i\Server = https://mirrors.cloud.tencent.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist && \
    echo -e "[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf && \
    pacman-key --init && \
    pacman-key --populate && \
    echo "Y" | pacman -Sy archlinuxcn-keyring --noconfirm && \
    pacman -Syu --noconfirm --needed git openssh sudo yay 

RUN groupadd demon && useradd -mg demon demon && \
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

USER demon
WORKDIR /home/demon

RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && makepkg -sri --needed --noconfirm && \
    cd ../ && rm -rf yay && \
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save && \
    yay -Sy jdk-adoptopenjdk jdk8-adoptopenjdk --needed --noconfirm && \
    yay -Sy maven docker miniconda3 zsh vim zsh --needed --noconfirm && \
    echo "Y"| sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone https://github.com/esc/conda-zsh-completion ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/conda-zsh-completion && \
    sed -i '/^plugins=/cplugins=(git sudo docker zsh-completions zsh-history-substring-search zsh-autosuggestions zsh-syntax-highlighting conda-zsh-completion extract)' ~/.zshrc && \
    echo "autoload -U compinit && compinit" >> ~/.zshrc && \
    echo "123456" | chsh -s /bin/zsh

RUN sudo ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    sudo ln -s /opt/miniconda3/etc/profile.d/conda.zsh /etc/profile.d/conda.zsh && \
    sudo pacman -Scc --noconfirm && \
    rm -rf .cache

EXPOSE 22

ENTRYPOINT [ "sudo", "/usr/bin/sshd", "-D"]
