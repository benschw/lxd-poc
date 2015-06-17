#!/bin/bash

# add-apt-repository ppa:ubuntu-lxc/lxd-git-master
# apt-get update

apt-get install -y lxd

service lxd start
sleep 5

lxd-images import lxc ubuntu trusty amd64 --alias trusty

