# YI-FTP-DOCKER
Very light vsftpd installation based on Ubuntu

By design, it will only run the vsftpd executable, exposing the FTP standard ports. This image is meant for running something like a public read-only share. User accounts are not supported and all data access is meant to be read only via ftp anonymous login. It is very handy when you want to provide FTP access to the content of some website from another container, importing its volumes.

### Up-&-Running
FTP docker created by default using Jenkins Pipeline job. You can execute it with something like:
```
docker run -d --name vsftpd -p 21:21 -p 65500-65515:65500-65515 -v /media/common/DOCKER_IMAGES/Tensorflow:/var/ftp:ro yi/ftp:0.0
```
It is posible to create & run docker using yml file:

* Make sure docker-compose is installed:
`sudo pip install docker-compose`
* Clone the repository:
`git clone --branch=master --depth=1 https://github.com/igor71/YI-FTP-DOCKER`
* cd to YI-FTP-DOCKER directory
`cd YI-FTP-DOCKER`
* Run following command: 
`sudo docker-compose up -d`
* (`-d` option will run docker container detached)

### Accessinf ftp folder

* Open in browser `ftp://<IP_Address>`
* Form CLI:
```
ftp://<IP_Address>
220 Welcome To YI Public FTP Server
Name (192.168.1.110:irabkin): anonymous
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
```

#### Runtime Configuration Options

There are a series of available variables you can tune at your own discretion. The defaults are most likely acceptable for most use cases.

* `ANON_ROOT` - The directory in the container which vsftpd will serve out (default: `/var/ftp/pub`)
* `MAX_PORT` - The maximum port for pasv communiation (default: `65515`)
* `MIN_PORT` - The minimum port for pasv communication (default: `65500`)
* `MAX_PER_IP` - The maximum connections from one host (default: `2`)
* `MAX_LOGIN_FAILS` - Maximum number of login failures before kicking (default: `2`) 
* `MAX_CLIENTS` - Maximum number of simultaneously connected clients (default: `50`)
* `MAX_RATE` - Maximum bandwidth allowed per client in bytes/sec (default: `6250000`)
* `FTPD_BANNER` - An ftpd banner displayed when a client connects (default: `Welcome to an awesome public FTP Server`)


#### Notes

* Ensure you use *:ro* at the end of your bind mount declaration!
* In current configuration we're utilize ftp passive mode so we can define the ports we need and not have to use `--net=host`. This is the preferred way to use ftp!
* You can find some great documentation on configuration options and other vsftpd information on the [Archwiki](https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon) and in the [man page](https://security.appspot.com/vsftpd/vsftpd_conf.html)

