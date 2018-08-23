# Ubuntu-based container for vsftpd
# VERSION               0.0
FROM ubuntu:16.04
LABEL MAINTAINER="Igor Rabkin<igor.rabkin@xiaoyi.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    pv \
    vsftpd && \
    apt-get install -f && \
    rm -rf /tmp/* /var/tmp/*

RUN cp /etc/vsftpd.conf /etc/vsftpd.conf.orig && \
    mkdir -p /var/ftp/pub && \
    chown nobody:nogroup /var/ftp/pub 
    
RUN sed -i "s/anonymous_enable=NO/anonymous_enable=YES/" /etc/vsftpd.conf && \
    sed -i "s/local_enable=YES/local_enable=NO/" /etc/vsftpd.conf && \
    sed -i "s/listen=NO/listen=YES/" /etc/vsftpd.conf && \
    sed -i "s/listen_ipv6=YES/listen_ipv6=NO/" /etc/vsftpd.conf && \
  
    sed -i '/anonymous_enable=YES/a # Stop prompting for a password on the command line '\\n'no_anon_password=YES' /etc/vsftpd.conf && \
    sed -i '/no_anon_password=YES/a # Point anonymous user to the ftp root directory '\\n'anon_root=/var/ftp/ '\\n'# Show the user and group as ftp:ftp, regardless of the owner' /etc/vsftpd.conf && \
    sed -i '/# Show the user and group as ftp:ftp, regardless of the owner/a hide_ids=YES '\\n'# Limit the range of ports that can be used for passive FTP' /etc/vsftpd.conf && \
    sed -i '/# Limit the range of ports that can be used for passive FTP/a pasv_min_port=40000 '\\n'pasv_max_port=50000' /etc/vsftpd.conf && \
    echo " ### Removing any trailing space and CR characters from /etc/vsftpd.conf file ###" && \
    sed -i 's,\r,,;s, *$,,' /etc/vsftpd.conf

VOLUME /etc

EXPOSE 21

CMD /usr/sbin/vsftpd
