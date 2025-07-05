FROM metacubex/mihomo

LABEL maintainer="demonjun@foxmail.com"

ENV url ""
ENV filter "*"
ENV ipv6 true
ENV udp true

COPY clash.yaml /clash.yaml
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 7890 9090

ENTRYPOINT ["/docker-entrypoint.sh"]
