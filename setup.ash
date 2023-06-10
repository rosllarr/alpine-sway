#!/bin/ash


####################################
# Remark                           #
# - This script run as normal user #
####################################


ln -sf ./config/home/sway_config ~/.config/sway/config
ln -sf ./config/home/alacritty_alacritty.yml ~/.config/alacritty/alacritty.yml

# Make esc+. to get last command parameter
echo -n 'SETUVAR fish_escape_delay_ms:300' >> ~/.config/fish/fish_variables
echo -n '' >> ~/.config/fish/fish_variables