#!/bin/bash
#Expand the disks and root FS
#sudo growpart /dev/sda 3 && sudo pvresize /dev/sda3 && sudo lvresize -l+100%FREE --resizefs /dev/mapper/ubuntu--vg-ubuntu--lv
sudo growpart /dev/sda 1 && sudo resize2fs /dev/sda1
# Resolv service
sudo systemctl disable systemd-resolved.service && sudo systemctl mask systemd-resolved.service && sudo systemctl stop systemd-resolved.service && sudo rm -f /etc/resolv.conf && echo 'search dellpc.in' | sudo tee -a /etc/resolv.conf && echo 'nameserver 192.168.1.225' | sudo tee -a /etc/resolv.conf
###

# install nfs
sudo apt-get update -qq && sudo apt-get install nfs-common -y -qq && echo '192.168.1.225:/volume2/size-4t-sub-2t1-dellpc-unixhome /home nfs rw,intr,hard,bg,vers=3 0 0' | sudo tee -a /etc/fstab && sudo mount -a

#
#NTP config
sudo apt-get install ntp -y -qq
sudo sed -i "s/server 0.ubuntu.pool.ntp.org/server 1.in.pool.ntp.org/g" /etc/ntp.conf
sudo sed -i "s/server 1.ubuntu.pool.ntp.org/server 1.asia.pool.ntp.org/g" /etc/ntp.conf
sudo sed -i "s/server 2.ubuntu.pool.ntp.org/server 2.asia.pool.ntp.org/g" /etc/ntp.conf
sudo sed -i "s/server 3.ubuntu.pool.ntp.org//g" /etc/ntp.conf
sudo service ntp restart
sudo systemctl enable ntp
#sudo shutdown -rf now

# Disable Firewall service
sudo /usr/sbin/ufw disable
#
#DIsable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab || exit 0
#
