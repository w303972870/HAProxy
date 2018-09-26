FROM alpine:latest
MAINTAINER Eric.wang wdc-zhy@163.com

RUN mkdir -p /data/conf/ /data/logs/  /data/haproxy/ 

ADD README.md /root/

RUN apk add --no-cache haproxy tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apk del gcc g++ openssl-dev zlib-dev perl-dev pcre-dev make git autoconf automake libtool &&  rm -rf /var/cache/apk/* && \
    mv /etc/haproxy/haproxy.cfg /data/conf/


CMD ["haproxy" , "-f" , "/data/conf/haproxy.cfg" , "-d"]

