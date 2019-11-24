#!/bin/bash

## Note on customizations:
# creates user
# copies skel to user's home dir
# sets pass
# enables fw
# 

# umask 077

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

#### alter timezone to your liking
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

usermod -s /usr/bin/bash root

## copy skel files to root 
# cp -aT /etc/skel/root /root/

chmod 700 /root

## lock root acct
usermod -L root

#### first sed invokation sets Berkeley OCF as package mirror
sed -i "/berkeley/s/#Server/Server/g" /etc/pacman.d/mirrorlist

sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service ufw.service sshd.socket
systemctl set-default multi-user.target

### CUSTOMIZATIONS

## create sudo group
groupadd sudo

## create user "arch" and add to useful groups (esp. sudo since we locked root above)
## sets default password to "live"
! id arch && useradd -m -p '$6$Q8xieUdz1yfagtkx$/XI9UB6VFk4KTDP9FSk62ftN6UhBfa0BQl3m4uKpC5w0pNj7TMNgrnLlMM1nrfkjTxi7rbXGmsojIP0.tr.MQ0' -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel,sudo" -s /usr/bin/zsh arch
## copy skel files to new home
cp -aT /etc/skel/ /home/arch/
chown -R arch: /home/arch/

## uncomment %sudo group in sudoers file to give permission
sed -i '/%sudo/s/^#//' /etc/sudoers

#ufw allow in on ens3 from 192.168.122.1 to any app ssh
#sed -i '/icmp/s/ACCEPT/DROP/' /etc/ufw/before.rules
ufw enable

#sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config


## ecryptfs
