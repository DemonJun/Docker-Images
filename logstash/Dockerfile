FROM logstash:7.3.2
LABEL maintainer=demonjun<demonjun@foxmail.com>
ADD jvm.options /usr/share/logstash/config/jvm.options
RUN logstash-plugin install --no-verify logstash-output-elasticsearch \
        && logstash-plugin install --no-verify logstash-input-kafka
