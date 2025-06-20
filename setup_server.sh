#!/bin/env bash

PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDavgwylkIv1ZGajyMYOt4qPInWotcN1M89ONjvlDPXGkAECLr9ENx0S/xZG+8Z/RRCiWdfj+VczMC4JFtn3b320S66XOYQIN3wXs54pUahBzfXao0NZGkHbtFaxe4Yvhpy0uOyprRWj/vdwfIDQI9c/Ep/8lE8seToWquVsa0pBl05nuxUf/NIERKWeqdQj2atfDOyW0Pk3M88hZVgg3xJMG4By8qLqlt2ndofoMjyzSyIis7O/xXtB/PaiSZDC7TwiagJCAC0R4Khvm0Pi9xAnkvk93jr8/7Jt2wEb637ByrjAH1Bv+B0oomuZXOHkvw1dlQoVhREuQ//P/yqBjiZBeeUezx2bJ11DV3iK43bjucHI3qHstbkdESyKgTjLz4bNHhyAwdR+n+VrVBqTfEGxqN58bIqqh0GIk2d22NvlF3dpOl/4E4QQgtEzIs0HVMztlCUUSgbIb9/L212ZL2FFvgF6AlIg4gFelrCOQKLz/clVKJPDOoHtswGLXc7sHzk3/ajHVn8HJbYCY15pMcCndvnQAuD7JkVET3hXlzs7dQ3PIE229037KYwBvBb1uo/3CVETc6rjKq+SB9ofXp5hUQQY1q0+mGP7kGkwQu/XUk/4wZbGD1xcfTigH2gD4XujbZ1YNeNiJxYxOrhmU8PhTDfSo2kZ4VVhvbB8vI3rQ== covix@cajatambo.local"

# when running this script, exit on error, undefined variable, or pipe failure
set -euo pipefail

# Usage: Run this script as root or with sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges." 1>&2
    exit 1
fi

# Update and upgrade the system packages
apt update -y && sudo apt upgrade -y
apt install -y git tmux curl wget vim python3 python3-venv python3-pip python3-dev build-essential libeccodes-tools libeccodes-dev 

# create a group named 'wv' and a 'shared' directory in /home/wv
groupadd -f wv
mkdir -p /home/wv
chown :wv /home/wv
chmod 2775 /home/wv

# create 4 users without sudo access and add them to the 'wv' group
# add key.pub to the authorized_keys file for each user
for user in wv1 wv2 wv3 wv4 wv5; do
    echo "Creating user: $user"
    useradd -m -G wv $user
    usermod -s /bin/bash $user
    echo "$user:Webvalley2025" | chpasswd
    mkdir -p /home/$user/.ssh
    echo "$PUBKEY" > /home/$user/.ssh/authorized_keys
    chown -R $user:wv /home/$user/.ssh
    chmod 700 /home/$user/.ssh
    chmod 600 /home/$user/.ssh/authorized_keys
done

# create a python virtual environment using uv and install data science packages
for user in wv1 wv2 wv3 wv4 wv5; do
    echo "Setting up Python virtual environment for user: $user"
    sudo -u $user python3 -m venv /home/$user/.venv
    sudo -u $user /home/$user/.venv/bin/pip install --upgrade pip setuptools wheel
    # install all data science packages
    sudo -u $user /home/$user/.venv/bin/pip install \
        --find-links https://girder.github.io/large_image_wheels \
        numpy pandas matplotlib seaborn scikit-learn scipy jupyterlab \
        xarray cfgrib netCDF4 eccodes pysteps GDAL pyproj zarr cartopy xeofs torch
    # set virtualenv as default for the user
    echo "source /home/$user/.venv/bin/activate" >> /home/$user/.bashrc
    echo "export PATH=\"/home/$user/.venv/bin:\$PATH\"" >> /home/$user/.bashrc
done

# create ssh config
for user in wv1 wv2 wv3 wv4 wv5; do
    # create a key with empty passphrase in default location
    echo "Creating SSH config for user: $user"
    sudo -u $user mkdir -p /home/$user/.ssh
    sudo -u $user ssh-keygen -t rsa -b 4096 -f /home/$user/.ssh/id_rsa -N ""
done
