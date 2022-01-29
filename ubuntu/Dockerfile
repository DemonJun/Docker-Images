FROM ubuntu

LABEL maintainer="demonjun@foxmail.com"

USER root

RUN apt update && apt install ca-certificates -y

COPY ubuntu-https-4-focal-sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y\
    && apt install openssh-server curl unzip zip ruby git vim -y \
    && apt autoremove -y \
    && sed -i \
    -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
    -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
    -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
    -e 's/^#*\(UsePAM\) .*/\1 no/' \
    /etc/ssh/sshd_config

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install sdkman mvnvm
RUN curl -s "https://get.sdkman.io" | bash \
    && echo 'source "/root/.sdkman/bin/sdkman-init.sh"' >> /root/.bash_profile \
    && curl -s https://bitbucket.org/mjensen/mvnvm/raw/master/mvn > /usr/local/bin/mvn \
    && chmod +x /usr/local/bin/mvn

# sdkman install mvnd
RUN source /root/.bash_profile && sdk install mvnd

# install jenv
RUN git clone https://github.com/jenv/jenv.git /root/.jenv \
    && echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> /root/.bash_profile \
    && ehco 'export PATH="$HOME/.jenv/shims:$PATH"' >> /root/.bash_profile \
    && echo 'eval "$(jenv init -)"' >> /root/.bash_profile

RUN apt install openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk -y

# jenv add java
RUN source /root/.bash_profile \
    && jenv add /usr/lib/jvm/java-8-openjdk-amd64 \
    && jenv add /usr/lib/jvm/java-11-openjdk-amd64 \
    && jenv add /usr/lib/jvm/java-17-openjdk-amd64 \
    && jenv global 17

RUN source /root/.bash_profile \
    && cat /root/.bash_profile\
    && jenv doctor \
    && jenv enable-plugin export \
    && jenv enable-plugin maven \
    && jenv enable-plugin springboot

EXPOSE 22

ENTRYPOINT [ "/etc/init.d/ssh", "start"]
