FROM alpine:latest

#Copy init script
COPY init.sh /init.sh

#Install Tailscale and requirements
RUN apk add curl iptables && \
    curl -fsSL https://tailscale.com/install.sh | sh && \
    #Install GO and Tailscale DERPER
    apk add go --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \
    go install tailscale.com/cmd/derper@main && \
    chmod +x /init.sh

#Derper Web Ports
EXPOSE 80
EXPOSE 9443/tcp
#STUN
EXPOSE 3478/udp

ENTRYPOINT /init.sh