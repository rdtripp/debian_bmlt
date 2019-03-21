#!/bin/bash

#Fixes a bug that sets wrong permissions on /tmp 
chown root:root /tmp
chmod ugo+rwXt /tmp

#export DEBIAN_FRONTEND=noninteractive

#Updates base system
apt-get update && apt-get -y update

#Sets correct time and date, edit to reflect your timezone
#sudo timedatectl set-timezone America/Chicago

#Downloads Virtualmin install script
wget http://software.virtualmin.com/gpl/scripts/install.sh

#Installs full Virtualmin
sh ./install.sh -f -v

#Installs Virtualmin Minimum (default)
#sh ./install.sh -f -v -m

DOMAIN = "bmlt.bmlt"

virtualmin create-domain --domain $DOMAIN --pass bmlt --desc "The server for bmlt" --unix --dir --webmin --web --ssl --mysql --dns --mail --limits-from-plan

# create database for wordpress
virtualmin create-database --domain bmlt.bmlt --name wp_bmlt --type mysql

#Install WordPress
virtualmin install-script --domain bmlt.bmlt --type wordpress --version latest --path /wordpress --db mysql wp_bmlt
    
#sudo mail -s "Test Subject" vagrant@localhost < /dev/null

# installs Desktop Environment
apt-get -y install x-window-system lxdm leafpad synaptic lxterminal

#Allows autologin to LXDE as vagrant
sed -i -- 's/# autologin=dgod/autologin=vagrant/g' /etc/lxdm/lxdm.conf

#Adds Google Chrome web browser
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get update && apt-get -y install google-chrome-stable

#Reboots system
reboot
