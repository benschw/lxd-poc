#!/bin/bash

IMAGE="$1"
HOSTNAME="$2"
USERDATA="$3"

echo -e \
	"instance_id: lxd-demo-$HOSTNAME\nlocal-hostname: $HOSTNAME" \
	> /tmp/$HOSTNAME-meta-data

lxc launch "$IMAGE" "$HOSTNAME"
sleep 5
lxc exec "$HOSTNAME" -- apt-get install -y cloud-init
lxc exec "$HOSTNAME" -- /bin/mkdir -p /var/lib/cloud/seed/nocloud-net/
lxc file push "$USERDATA"  $HOSTNAME/var/lib/cloud/seed/nocloud-net/user-data
lxc file push /tmp/$HOSTNAME-meta-data $HOSTNAME/var/lib/cloud/seed/nocloud-net/meta-data

lxc exec $HOSTNAME -- /usr/bin/cloud-init init
# lxc exec node1 -- /usr/bin/cloud-init modules --mode init
# lxc exec node1 -- /usr/bin/cloud-init modules --mode config
# lxc exec node1 -- /usr/bin/cloud-init modules --mode final


