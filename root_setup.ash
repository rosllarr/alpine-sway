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


## Global variables
ME=tie
MYHOME=/home/$ME


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


## Install essential softwares
apk add curl pciutils


setup_env () {
    if [ ! -s "$MYHOME/.config/sway/config" ]; then
        mkdir -p $MYHOME/.config/sway
        mkdir -p $MYHOME/.config/alacritty
        cp -a ~/.ssh $MYHOME/.ssh
        chown -R $ME:$ME $MYHOME/.config
        chown -R $ME:$ME $MYHOME/.ssh
        cp ./config/home/dot_profile $MYHOME/.profile
        cp ./config/home/sway_config $MYHOME/.config/sway/config
        cp ./config/home/alacritty_alacritty.yml $MYHOME/.config/alacritty/alacritty.yml
        chown $ME:$ME $MYHOME/.profile
        chown $ME:$ME $MYHOME/.config/sway/config
        chown $ME:$ME $MYHOME/.config/alacritty/alacritty.yml
    fi
}


## Install Sway
CMD1=$(apk info -vv | grep 'sway' | wc -l)
CMD2=$(apk info -vv | grep 'bemenu' | wc -l)
CMD3=$(apk info -vv | grep 'seatd' | wc -l)
CMD4=$(apk info -vv | grep 'alacritty' | wc -l)
CMD5=$(apk info -vv | grep 'fish' | wc -l)
if [[ $CMD1 -eq 0 ]] && [[ $CMD2 -eq 0 ]] && [[ $CMD3 -eq 0 ]] && [[ $CMD4 -eq 0 ]] && [[ $CMD5 -eq 0 ]]; then
    apk add seatd alacritty fish bemenu sway sway-doc swaylock swaylockd swaybg swayidle wl-clipboard font-dejavu
    addgroup $ME seat
    addgroup $ME video
    addgroup $ME input
    setup-devd udev
    rc-update add seatd && rc-service seatd start
    setup_env
    echo '##>> Install Sway successfully, Plese logout and login as normal user <<##'
else
    setup_env
    echo '##>> Sway is already Installed <<##'
fi
