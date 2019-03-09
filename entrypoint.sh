#!/bin/bash
echo "generating authorized_keys file"
rm -rf /home/bkp/.ssh/authorized_keys
mkdir -p /home/bkp/.ssh/
touch /home/bkp/.ssh/authorized_keys

if [ -z "$KEYS" ]
then
    echo "Please define the \$KEYS environment variable"
    echo "Example:"
    echo "ecdsa-sha2-nistp256 AAB45[...]DEQ3="
    echo "ssh-rsa EOD4353[...]9302="
    exit 1
fi

while read -r key; do
    echo "command=\"borg serve --restrict-to-path /borg\",no-pty,no-agent-forwarding,no-port-forwarding,no-X11-forwarding,no-user-rc $key" >> /home/bkp/.ssh/authorized_keys
done <<< "$KEYS"

cat /home/bkp/.ssh/authorized_keys
echo
echo "Generating host key"
ssh-keygen -t rsa -f /home/bkp/ssh_host_rsa_key -N ''
echo 
echo "starting sshd"
/usr/sbin/sshd -f /home/bkp/sshd_config -D &
while true; do  true; done