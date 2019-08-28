#!/bin/bash

# Add the graphics-driver PPA
add-apt-repository -y ppa:graphics-drivers/ppa
apt-get update

# Install the drivers that support Tesla machines (p2, g3, p3).
apt-get install -y nvidia-driver-415

# Prevent minor version upgrades.
apt-mark hold nvidia-driver-415

sudo service lightdm stop

sudo systemctl set-default multi-user.target
