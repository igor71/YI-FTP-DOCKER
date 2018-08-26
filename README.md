# YI-FTP-DOCKER
Very light vsftpd installation based on Ubuntu

By design, it will only run the vsftpd executable, exposing the FTP standard ports. This image is meant for running something like a public read-only share. User accounts are not supported and all data access is meant to be read only via ftp anonymous login. It is very handy when you want to provide FTP access to the content of some website from another container, importing its volumes.

You can execute it with something like:
```
docker run -d --name vsftpd -p 21:21 -p 65500-65515:65500-65515 -v /media/common/DOCKER_IMAGES/Tensorflow:/var/ftp:ro yi/ftp:0.0
```
To to add any user, you may want to run another (temporary) container that imports its volumes. Run it with:
```
docker run -it --name add-user-vsftpd --volumes-from vsftpd yi-vsftpd:0.0
```
Then you can use the useradd system command to define them and having the same accounts also on the main vsftpd container.
