#!/bin/ash


###################################
# Remark                          #
# - This script run as root only! #
###################################


###########################################
# Manually requirement steps              #
# - Connect WiFi with iwd manually        #
# - Add ssh key                           #
# - Install git and git clone repository  #
###########################################


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
    echo '##>> mandoc is already installed <<##'
fi


## Install video driver
CMD1=$(apk info -vv | grep 'mesa-dri-gallium' | wc -l)
CMD2=$(apk info -vv | grep 'mesa-va-gallium' | wc -l)
CMD3=$(apk info -vv | grep 'intel-media-driver' | wc -l)
if [[ $CMD1 -eq 0 ]] && [[ $CMD2 -eq 0 ]] && [[ $CMD3 -eq 0 ]]; then
	doas apk add mesa-dri-gallium mesa-va-gallium intel-media-driver
	echo '##>> Install mesa-dri-gallium, mesa-va-gallium, intel-media-driver successfully <<##'
else
	echo '##>> mesa-dri-gallium, mesa-va-gallium, intel-media-driver are already installed <<##'
fi

## Install sway
# seatd enable at Default
# dbus enable at Default

