#!/bin/bash

# Add the graphics-driver PPA
add-apt-repository -y ppa:graphics-drivers
apt-get update

# Install the drivers that support Tesla machines (p2, g3, p3).
apt-get install -y nvidia-390

# Prevent minor version upgrades.
apt-mark hold nvidia-390
