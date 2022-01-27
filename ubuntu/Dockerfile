FROM ubuntu:20.04

LABEL maintainer="demonjun@foxmail.com"

USER root

RUN apt update && apt install ca-certificates vim -y

COPY ubuntu-https-4-focal-sources.list /etc/apt/sources.list

RUN apt update && apt upgrade -y \
    && apt install openssh-server curl unzip zip ruby git -y \
    && apt autoremove -y \
    && sed -i \
    -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
    -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
    -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
    -e 's/^#*\(UsePAM\) .*/\1 no/' \
    /etc/ssh/sshd_config

# install sdkman mvnvm
RUN curl -s "https://get.sdkman.io" | bash \
    && echo 'source "/root/.sdkman/bin/sdkman-init.sh"' >> ~/.bash_profile \
    && source ~/.bash_profile \
    && curl -s https://bitbucket.org/mjensen/mvnvm/raw/master/mvn > /usr/local/bin/mvn \
    && chmod +x /usr/local/bin/mvn

# sdkman install mvnd
RUN  sdk install mvnd

# install jenv
RUN git clone https://github.com/jenv/jenv.git ~/.jenv \
    && echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile \
    && echo 'eval "$(jenv init -)"' >> ~/.bash_profile \
    && source ~/.bash_profile

RUN apt install  openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk -y

# jenv add java
RUN  jenv add /usr/lib/jvm/java-8-openjdk-amd64 \
    && jenv add /usr/lib/jvm/java-11-openjdk-amd64 \
    && jenv add /usr/lib/jvm/java-17-openjdk-amd64 \
    && jenv global 17 \
    && jenv enable-plugin export \
    && jenv enable-plugin maven \
    && jenv enable-plugin springboot

EXPOSE 22

ENTRYPOINT [ "/etc/init.d/ssh", "start"]
