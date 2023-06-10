#!/bin/ash


####################################
# Remark                           #
# - This script run as normal user #
####################################


# Global variables
ME=tie
MY_HOME=/home/$ME
HOME_CONF=$MY_HOME/.config
HOME_LOCAL=$MY_HOME/.local
GIT_HOME_CONF=$(pwd)/config/home


# Create/Update symlink
ln -sf $GIT_HOME_CONF/dot_profile $MY_HOME/.profile
ln -sf $GIT_HOME_CONF/sway_config $HOME_CONF/sway/config
ln -sf $GIT_HOME_CONF/alacritty_alacritty.yml $HOME_CONF/alacritty/alacritty.yml


# Install oh-my-fish
if [ ! -d "$HOME_CONF/omf" ]; then
    echo '##>> Install oh-my-fish <<##'
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    omf install bang-bang
fi


# Setup fish
if [ -d "$HOME_CONF/fish" ]; then
    # Make esc+. to get last command parameter
    CMD=$(cat $HOME_CONF/fish/fish_variables | grep fish_escape_delay_ms:300 | wc -l)
    if [[ $CMD -ne 1 ]]; then
        echo 'SETUVAR fish_escape_delay_ms:300' >> $HOME_CONF/fish/fish_variables
        echo '' >> ~/.config/fish/fish_variables
    fi
    # Add fish aliases
    ln -sf $GIT_HOME_CONF/fish_config.fish $HOME_CONF/fish/config.fish
fi


# Setup flatpak repo
if [ ! -s "$HOME_LOCAL/share/flatpak/repo/config" ]; then
    mkdir -p $HOME_LOCAL/share/flatpak/repo/objects
    mkdir -p $HOME_LOCAL/share/flatpak/repo/tmp
    touch $HOME_LOCAL/share/flatpak/repo/config
    echo -e "[core]\nrepo_version=1\nmode=bare-user-only" > $HOME_LOCAL/share/flatpak/repo/config
    flatpak --user remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
fi