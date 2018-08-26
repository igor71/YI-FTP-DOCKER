# YI-FTP-DOCKER
Very light vsftpd installation based on Ubuntu

By design, it will only run the vsftpd executable, exposing the FTP standard ports. This image is meant for running something like a public read-only share. User accounts are not supported and all data access is meant to be read only via ftp anonymous login. It is very handy when you want to provide FTP access to the content of some website from another container, importing its volumes.

You can execute it with something like:
```
docker run -d --name vsftpd -p 21:21 -p 65500-65515:65500-65515 -v /media/common/DOCKER_IMAGES/Tensorflow:/var/ftp:ro yi/ftp:0.0
```
#### Runtime Configuration Options

There are a series of available variables you can tune at your own discretion. The defaults are most likely acceptable for most use cases.

* `ANON_ROOT` - The directory in the container which vsftpd will serve out (default: `/var/ftp`)
* `MAX_PORT` - The maximum port for pasv communiation (default: `65515`)
* `MIN_PORT` - The minimum port for pasv communication (default: `65500`)
* `MAX_PER_IP` - The maximum connections from one host (default: `2`)
* `MAX_LOGIN_FAILS` - Maximum number of login failures before kicking (default: `2`) 
* `MAX_CLIENTS` - Maximum number of simultaneously connected clients (default: `50`)
* `MAX_RATE` - Maximum bandwidth allowed per client in bytes/sec (default: `6250000`)
* `FTPD_BANNER` - An ftpd banner displayed when a client connects (default: `Welcome to an awesome public FTP Server`)


#### Notes

* Ensure you use *:ro* at the end of your bind mount declaration!
* We utilize ftp passive mode so we can define the ports we need and not have to use `--net=host`. This is the preferred way to use ftp!
* You can find some great documentation on configuration options and other vsftpd information on the [Archwiki](https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon) and in the [man page](https://security.appspot.com/vsftpd/vsftpd_conf.html)

To to add any user, you may want to run another (temporary) container that imports its volumes. Run it with:
```
docker run -it --name add-user-vsftpd --volumes-from vsftpd yi-vsftpd:0.0
```
Then you can use the useradd system command to define them and having the same accounts also on the main vsftpd container.
