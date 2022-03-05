#!/bin/bash

# Variables
#HOSTNAME="pi4-2"

# Init
FILE="/tmp/out.$$"
GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt update && apt full-upgrade -y

# Some Basic Raspi config to be sure
#raspi-config nonint do_hostname $HOSTNAME
raspi-config nonint do_boot_splash 0
raspi-config nonint do_overscan 1
raspi-config nonint do_pixdub 0
raspi-config nonint do_memory_split 256
raspi-config nonint do_boot_wait 0
raspi-config nonint do_change_timezone Europe/Berlin 
# raspi-config nonint do_resolution %d %d

# Expand Filesystem
raspi-config nonint do_expand_rootfs

echo -e "\033[31m--raspi-config done, installing mc\033[0m"
sleep 2

# Install mc as it should be in every install
apt install mc git -y


echo -e "\033[31m--mc install done, installing pi-power-button\033[0m"
sleep 2

# Install Power Button Script
cd /home/pi
rm -rf /home/pi/pi_video_looper_config
rm -rf /home/pi/pi_video_looper
rm -rf /home/pi/pi-power-button
git clone https://github.com/Howchoo/pi-power-button.git
/home/pi/pi-power-button/script/install

echo -e "\033[31m--pi-power-button install done, installing pi_video_looper\033[0m"
sleep 2

# Install pi_video_looper
git clone https://github.com/adafruit/pi_video_looper
/home/pi/pi_video_looper/install.sh no_hello_video

echo -e "\033[31m--pi_video_looper install done, loading config\033[0m"
sleep 2

# Deploy the config for videolooper
git clone https://github.com/theleiko/pi_video_looper_config
cp /home/pi/pi_video_looper_config/video_looper.conf /etc/supervisor/conf.d/
cp /home/pi/pi_video_looper_config/video_looper.ini /boot/


# Update the Bootloader
sudo rpi-eeprom-update -a


# Final Reboot
reboot now

#raspi-config nonint enable_bootro


