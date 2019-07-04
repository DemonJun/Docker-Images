FROM logstash
LABEL maintainer=demonjun<demonjun@foxmail.com>
ADD jvm.options /usr/share/logstash/config/jvm.options
RUN logstash-plugin install --no-verify logstash-output-elasticsearch \
        && logstash-plugin install --no-verify logstash-input-kafka