#!/usr/bin/env bash

apt-get update
apt-get -y install figlet

# Generate system banner
figlet "${welcome_message}" > /etc/motd

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

${user_data}
