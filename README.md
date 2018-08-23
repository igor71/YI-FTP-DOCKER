# YI-FTP-DOCKER
Very light vsftpd installation based on Ubuntu

By design, it will only run the vsftpd executable, exposing the FTP standard port and exporting /etc as a volume for both the configuration files and the local users database, allowing you to add any account. It is very handy when you want to provide FTP access to the content of some website from another container, importing its volumes.

You can execute it with something like:
```
docker run -d -P --name vsftpd --volumes-from YOUR-WEB-SERVER yi-vsftpd:0.0
```
To to add any user, you may want to run another (temporary) container that imports its volumes. Run it with:
```
docker run -i -t --name config.vsftpd --volumes-from vsftpd yi-vsftpd:0.0
```
Then you can use the useradd system command to define them and having the same accounts also on the main vsftpd container.
