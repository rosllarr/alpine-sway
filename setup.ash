#!/bin/ash


####################################
# Remark                           #
# - This script run as normal user #
####################################


# Global variables
ME=tie
MY_HOME=/home/$ME
HOME_CONF=$MYHOME/.config
GIT_HOME_CONF=$(pwd)/config/home


# Make symlink
ln -sf $GIT_HOME_CONF/dot_profile $MY_HOME/.profile
ln -sf $GIT_HOME_CONF/sway_config $HOME_CONF/sway/config
ln -sf $GIT_HOME_CONF/alacritty_alacritty.yml $HOME_CONF/alacritty/alacritty.yml


# Install oh-my-fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish


# Make esc+. to get last command parameter
echo -n 'SETUVAR fish_escape_delay_ms:300' >> $MY_HOME/.config/fish/fish_variables
echo -n '' >> ~/.config/fish/fish_variables