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
    mkdir -p /var/ftp/pub && \
    chown nobody:nogroup /var/ftp/pub 
    
RUN [ -f /etc/vsftpd.conf ] || cat <<EOF > /etc/vsftpd.conf
    listen=YES
    anonymous_enable=YES
    dirmessage_enable=YES
    use_localtime=YES
    connect_from_port_20=YES
    write_enable=NO
    seccomp_sandbox=NO
    xferlog_std_format=NO
    log_ftp_protocol=YES
    anon_root=/var/ftp
    pasv_max_port=65500
    pasv_min_port=65515
    max_per_ip=5
    max_login_fails=3
    max_clients=10
    anon_max_rate=0
    ftpd_banner="Welcome to an awesome YI public FTP Server"
    EOF && \
    sed -i 's,\r,,;s, *$,,' /etc/vsftpd.conf

VOLUME ["/var/ftp"]

EXPOSE 20-21
EXPOSE 65500-65515

CMD /usr/sbin/vsftpd
