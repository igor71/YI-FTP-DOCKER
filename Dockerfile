# Ubuntu-based container for vsftpd
# VERSION               0.0
FROM ubuntu:16.04
LABEL MAINTAINER="Igor Rabkin<igor.rabkin@xiaoyi.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nano \
    lsof \
    pv \
    vsftpd && \
    apt-get install -f && \
    rm -rf /tmp/* /var/tmp/*

RUN cp /etc/vsftpd.conf /etc/vsftpd.conf.orig && \
    rm /etc/vsftpd.conf && \
    mkdir -p /var/ftp/pub && \
    chown nobody:nogroup /var/ftp/pub && \
    mkdir -p /var/run/vsftpd/empty
    
    
COPY init /
RUN chmod u+x /init
 
VOLUME ["/var/ftp"]

EXPOSE 20-21
EXPOSE 65500-65515

ENTRYPOINT ["/init"]
