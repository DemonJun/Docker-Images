FROM ubuntu

LABEL maintainer="demonjun@foxmail.com"

USER root

RUN apt update && apt install ca-certificates -y

COPY ubuntu-https-4-focal-sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
    && apt install openssh-server curl unzip zip ruby git vim -y \ 
    && apt autoremove -y \ 
    && rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt install openjdk-11-jdk -y \
    && sed -i \
    -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
    -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
    -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
    -e 's/^#*\(UsePAM\) .*/\1 no/' \
    /etc/ssh/sshd_config

EXPOSE 22

ENTRYPOINT [ "/etc/init.d/ssh", "start"]
