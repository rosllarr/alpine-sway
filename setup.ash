#!/bin/ash


###################################
# Remark                          #
# - This script run as root only! #
###################################


###########################################
# Manually requirements                   #
# - Connect WiFi with iwd manually        #
# - Install btrfs for mount external_hdd  #
# - Add ssh key                           #
# - Install git and git clone repository  #
###########################################
### Connect WiFi with iwd ######################################
# apk add iwd                                                  #
# rc-service wpa_supplicant stop                               #
# rc-service iwd start                                         #
# iwctl device list                                            #
# iwctl station wlan0 scan && iwctl station wlan0 get-networks #
# iwctl station wlan0 connect <SSID>                           #
# rc-update add iwd boot && rc-update add dbus boot            #
# rc-service networking restart                                #
# ip a show wlan0                                              #
# apk del wpa_supplicant                                       #
################################################################
### Install btrfs ##############################
# apk add btrfs-progs                          # 
# cat <<EOT >> /etc/modules-load.d/btrfs.conf  #
# btrfs                                        #
#                                              #
# EOT                                          #
# modprobe btrfs                               #
# cat /proc/filesystems | grep btrfs           #
################################################
### Add ssh key #########################
# mount -t btrfs /dev/sdX /mnt          #
# mkdir ~/.ssh                          #
# cp /mnt/id_rsa /mnt/id_rsa.pub ~/.ssh #
# chmod 0600 ~/.ssh/id_*                #
#########################################
### Install git #############################################
# apk add git                                               #
# cd ~ && git clone git@github.com:rosllarr/alpine-sway.git #
#############################################################


## Install doas
CMD=$(apk info -vv | grep 'doas' | wc -l)
if [[ $CMD -eq 0 ]]; then
	apk add doas
    cp ./config/etc/doas.conf /etc/doas.d/doas.conf
    echo '##>> Install doas successfuly <<##'
else
    echo '##>> doas is already installed <<##'
fi


## Add user
CMD=$(cat /etc/passwd | grep tie | wc -l)
if [[ $CMD -eq 0 ]]; then
	adduser tie
	addgroup tie wheel
    echo '##>> Create user tie and Add to wheel group <<##'
else
    echo '##>> User tie is already created <<##'
fi


## Install mandoc
CMD=$(apk info -vv | grep 'mandoc' | wc -l)
if [[ $CMD -eq 0 ]]; then
	apk add mandoc man-pages mandoc-apropos
    echo '##>> Install mandoc, man-pages, mandoc-apropos successfully <<##'
else
    echo '##>> mandoc, man-pages, mandoc-apropos are already installed <<##'
fi


## Install video driver
CMD1=$(apk info -vv | grep 'mesa-dri-gallium' | wc -l)
CMD2=$(apk info -vv | grep 'mesa-va-gallium' | wc -l)
CMD3=$(apk info -vv | grep 'intel-media-driver' | wc -l)
if [[ $CMD1 -eq 0 ]] && [[ $CMD2 -eq 0 ]] && [[ $CMD3 -eq 0 ]]; then
	apk add mesa-dri-gallium mesa-va-gallium intel-media-driver
	echo '##>> Install mesa-dri-gallium, mesa-va-gallium, intel-media-driver successfully <<##'
else
	echo '##>> mesa-dri-gallium, mesa-va-gallium, intel-media-driver are already installed <<##'
fi

### Setup desktop
## seatd enable at Default
## dbus enable at Boot
# doas apk update
# doas apk add eudev
# doas setup-devd udev

# install fish
# add support esc+period 
# echo -n 'SETUVAR fish_escape_delay_ms:300' >> ~/.config/fish/fish_variables
# echo -n '' >> ~/.config/fish/fish_variables

