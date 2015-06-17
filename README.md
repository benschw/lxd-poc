Description of problem:


From VirtualBox host:

`docker version`:

	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	Server version: 1.6.0
	Server API version: 1.18
	Go version (server): go1.4.2
	Git commit (server): 4749651
	OS/Arch (server): linux/amd64


`docker info`:

	Containers: 0
	Images: 0
	Storage Driver: aufs
	 Root Dir: /var/lib/docker/aufs
	 Backing Filesystem: extfs
	 Dirs: 0
	 Dirperm1 Supported: true
	Execution Driver: native-0.2
	Kernel Version: 3.19.0-15-generic
	Operating System: Ubuntu 15.04
	CPUs: 1
	Total Memory: 489.1 MiB
	Name: vagrant-ubuntu-vivid-64
	ID: LF2T:DNN2:JF5H:IMQS:S7LK:7WDA:CETE:ABRV:LLKH:APKY:75UI:AT2B
	WARNING: No swap limit support


`uname -a`:

	Linux vagrant-ubuntu-vivid-64 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

From `lxc` container

`docker version`:

	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	FATA[0000] Get http:///var/run/docker.sock/v1.18/version: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS? 


`docker info`:

	FATA[0000] Get http:///var/run/docker.sock/v1.18/info: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS? 


`uname -a`:

	Linux test 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux


Environment details (AWS, VirtualBox, physical, etc.):

- VirtualBox host (Ubuntu Vivid from cloud-images.ubuntu.com) running `lxd` 
- the `lxc` guest is running Ubuntu Trusty


How reproducible:


Steps to Reproduce:
1. Boot ubuntu vivid vm in VirtualBox
2. Install Docker on host (to make sure kernel has everything)
	1. wget -qO- https://get.docker.com/ | sh
3. Install Lxd Container 
	1. sudo apt-get install -y lxd
	2. sudo service lxd start
	3. sudo lxd-images import lxc ubuntu trusty amd64 --alias trusty
	4. sudo lxc launch trusty test
	5. sudo lxc exec test -- /bin/bash
4. Install Docker on lxc guest
	1. apt-get install wget
	2. wget -qO- https://get.docker.com/ | sh
5. Try to start Docker
	1. service docker start (fails)
	2. docker -d --exec-driver=lxc (fails)
	3. docker -d (fails)

	docker -d --exec-driver=lxc
	INFO[0000] +job serveapi(unix:///var/run/docker.sock)   
	INFO[0000] Listening for HTTP on unix (/var/run/docker.sock) 
	FATA[0000] Shutting down daemon due to errors: error intializing graphdriver: permission denied


Actual Results:


Expected Results:
	
	docker -d --exec-driver=lxc
	...
	INFO[0000] Daemon has completed initialization          


Additional info:

	docker -d --exec-driver=lxc
	INFO[0000] +job serveapi(unix:///var/run/docker.sock)   
	INFO[0000] Listening for HTTP on unix (/var/run/docker.sock) 
	FATA[0000] Shutting down daemon due to errors: error intializing graphdriver: permission denied



When trying to run Docker in an ubuntu trusty lxc container created with lxd (cli, not openstack) on an ubuntu vivid host (created with vagrant from a cloud-images.ubuntu.com image) I get the following error:

	# docker -d --exec-driver=lxc
	INFO[0000] +job serveapi(unix:///var/run/docker.sock)   
	INFO[0000] Listening for HTTP on unix (/var/run/docker.sock) 
	FATA[0000] Shutting down daemon due to errors: error intializing graphdriver: permission denied 

Following is a more complete log of what I tried:

(from the vivid host vm)

	$ wget -qO- https://get.docker.com/ | sh
	$ sudo docker version
	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	Server version: 1.6.0
	Server API version: 1.18
	Go version (server): go1.4.2
	Git commit (server): 4749651
	OS/Arch (server): linux/amd64
	$ sudo docker info
	Containers: 0
	Images: 0
	Storage Driver: aufs
	 Root Dir: /var/lib/docker/aufs
	 Backing Filesystem: extfs
	 Dirs: 0
	 Dirperm1 Supported: true
	Execution Driver: native-0.2
	Kernel Version: 3.19.0-15-generic
	Operating System: Ubuntu 15.04
	CPUs: 1
	Total Memory: 489.1 MiB
	Name: vagrant-ubuntu-vivid-64
	ID: LF2T:DNN2:JF5H:IMQS:S7LK:7WDA:CETE:ABRV:LLKH:APKY:75UI:AT2B
	WARNING: No swap limit support
	$ uname -a
	Linux vagrant-ubuntu-vivid-64 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

	$ sudo apt-get install -y lxd
	$ sudo service lxd start
	$ sudo lxd-images import lxc ubuntu trusty amd64 --alias trusty
	$ sudo lxc launch trusty test
	$ sudo lxc exec test -- /bin/bash

(on the trusty lxc guest)

	# apt-get install -y wget
	# wget -qO- https://get.docker.com/ | sh
	# service docker status
	docker stop/waiting
	# docker version
	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	FATA[0000] Get http:///var/run/docker.sock/v1.18/version: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS? 
	# docker info
	FATA[0000] Get http:///var/run/docker.sock/v1.18/info: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS? 
	# uname -a
	Linux test 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

	# docker -d --exec-driver=lxc
	INFO[0000] +job serveapi(unix:///var/run/docker.sock)   
	INFO[0000] Listening for HTTP on unix (/var/run/docker.sock) 
	FATA[0000] Shutting down daemon due to errors: error intializing graphdriver: permission denied 

 

	vagrant up
	vagrant ssh

	sudo lxd-images import lxc ubuntu vivid amd64 --alias vivid

	cd /vagrant
	sudo ./lxc-init.sh vivid node1 ./user-data

	sudo lxc exec node1 -- /bin/bash


	### On clean Trusty vm created with vagrant

	$ wget -qO- https://get.docker.com/ | sh
	$ sudo docker version
	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	Server version: 1.6.0
	Server API version: 1.18
	Go version (server): go1.4.2
	Git commit (server): 4749651
	OS/Arch (server): linux/amd64
	$ uname -a
	Linux vagrant-ubuntu-vivid-64 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

	$ sudo apt-get install -y lxd
	$ sudo service lxd start
	$ sudo lxd-images import lxc ubuntu trusty amd64 --alias trusty
	$ sudo lxc launch trusty test
	$ sudo lxc exec test -- /bin/bash

	### On LXC guest VM (Trusty also)

	# apt-get install -y wget
	# wget -qO- https://get.docker.com/ | sh
	# service docker status
	docker stop/waiting
	# docker version
	Client version: 1.6.0
	Client API version: 1.18
	Go version (client): go1.4.2
	Git commit (client): 4749651
	OS/Arch (client): linux/amd64
	FATA[0000] Get http:///var/run/docker.sock/v1.18/version: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS? 
	# uname -a
	Linux test 3.19.0-15-generic #15-Ubuntu SMP Thu Apr 16 23:32:37 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

	# docker -d --exec-driver=lxc
	INFO[0000] +job serveapi(unix:///var/run/docker.sock)   
	INFO[0000] Listening for HTTP on unix (/var/run/docker.sock) 
	FATA[0000] Shutting down daemon due to errors: error intializing graphdriver: permission denied 



	wget -qO- https://get.docker.com/ | sh
	docker run -d -p 8090 benschw/anvilmgr


	apt-get install apt-transport-https

	echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
	apt-get update
	apt-get install -y --force-yes -q lxc-docker

	docker -d --exec-driver=lxc
