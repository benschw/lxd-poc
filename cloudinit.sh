#!/bin/bash


if [ -f /.vagrant_build_done ]; then
	echo "Found, not running."
	exit
fi


rm -rf /var/lib/cloud/instance/*
rm -rf /var/lib/cloud/seed/nocloud-net/user-data


cp /vagrant/user-data /var/lib/cloud/seed/nocloud-net/user-data


/usr/bin/cloud-init init
/usr/bin/cloud-init modules --mode init
/usr/bin/cloud-init modules --mode config
/usr/bin/cloud-init modules --mode final

touch /.vagrant_build_done
