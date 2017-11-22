#!/usr/bin/env bash

if [ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]; then
  apt-get update
  apt-get -y install figlet
  SSH_USER=ubuntu
else
  yum install epel-release -y
  yum install figlet -y
  SSH_USER=ec2-user
fi
# Generate system banner
figlet "${welcome_message}" > /etc/motd

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/SSH_USER/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/$SSH_USER/.ssh/config
chown $SSH_USER:$SSH_USER /home/SSH_USER/.ssh/config

${user_data}
