#!/bin/bash

SSHKEYGEN=/usr/bin/ssh-keygen
if [ ! -s /etc/ssh/ssh-keys/ssh_host_rsa_key -o ! -s /etc/ssh/ssh-keys/ssh_host_rsa_key.pub ]; then
    if [ -f /etc/ssh/ssh-keys/ssh_host_rsa_key ]; then
	rm /etc/ssh/ssh-keys/ssh_host_rsa_key
    fi
    if [ -f /etc/ssh/ssh-keys/ssh_host_rsa_key.pub ]; then
	rm /etc/ssh/ssh-keys/ssh_host_rsa_key.pub
    fi
    $SSHKEYGEN -q -t rsa  -f /etc/ssh/ssh-keys/ssh_host_rsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh/ssh-keys/ssh_host_rsa_key"
fi

if [ ! -s /etc/ssh/ssh-keys/ssh_host_ecdsa_key -o ! -s /etc/ssh/ssh-keys/ssh_host_ecdsa_key.pub ]; then
    if [ -f /etc/ssh/ssh-keys/ssh_host_ecdsa_key ]; then
	rm /etc/ssh/ssh-keys/ssh_host_ecdsa_key
    fi
    if [ -f /etc/ssh/ssh-keys/ssh_host_ecdsa_key.pub ]; then
	rm /etc/ssh/ssh-keys/ssh_host_ecdsa_key.pub
    fi
    $SSHKEYGEN -q -t ecdsa -f /etc/ssh/ssh-keys/ssh_host_ecdsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh/ssh-keys/ssh_host_ecdsa_key"
fi

if [ ! -s /etc/ssh/ssh-keys/ssh_host_ed25519_key -o ! -s /etc/ssh/ssh-keys/ssh_host_ed25519_key.pub ]; then
    if [ -f /etc/ssh/ssh-keys/ssh_host_ed25519_key ]; then
	rm /etc/ssh/ssh-keys/ssh_host_ed25519_key
    fi
    if [ -f /etc/ssh/ssh-keys/ssh_host_ed25519_key.pub ]; then
	rm /etc/ssh/ssh-keys/ssh_host_ed25519_key.pub
    fi
    $SSHKEYGEN -q -t ed25519 -f /etc/ssh/ssh-keys/ssh_host_ed25519_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh/ssh-keys/ssh_host_ed25519_key"
fi

for i in /etc/ssh/ssh-keys/*; do
    ln -s $i /etc/ssh 1>/dev/null 2>&1 
done

ln -s /etc/ssh/ssh-keys/root/ /root/.ssh 2> /dev/null
if [[ -n ${AUTHORIZED_KEY} ]]; then 
    echo "Overwriting /root/authorized_keys2"
    mkdir /etc/ssh/ssh-keys/root/ 2> /dev/null
    chmod 600 /etc/ssh/ssh-keys/root/ 2> /dev/null
    echo ${AUTHORIZED_KEY} > /root/.ssh/authorized_keys2
fi

/usr/sbin/sshd -D "$@"
