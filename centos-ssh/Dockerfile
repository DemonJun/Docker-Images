FROM centos:7

LABEL author="fanjx@weipaitang.com"

RUN sed -i "s/#baseurl/baseurl/g" /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i "s/mirrorlist=http/#mirrorlist=http/g" /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i "s@http://mirror.centos.org@https://mirrors.huaweicloud.com@g" /etc/yum.repos.d/CentOS-Base.repo && \
    yum update -y && \
    yum install epel-release -y && \
    yum install openssh-server openssh-client supervisor vim wget net-tools lrzsz git unzip zip gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel p7zip p7zip-plugins -y && \
    yum clean all

COPY ssh.ini /etc/supervisord.d
COPY change_root_passwd.sh /root
COPY ssh_* /etc/ssh

RUN sh /root/change_root_passwd.sh && \
    sed -i "s/UsePAM yes/#UsePAM no/g" /etc/ssh/sshd_config && \
    sed -i "s/nodaemon=false/nodaemon=true/" /etc/supervisord.conf

EXPOSE 22 

ENTRYPOINT [ "supervisord","-c","/etc/supervisord.conf" ]
