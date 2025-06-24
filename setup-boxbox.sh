# create virtualenv
# install stuff
# create ssh keys to deploy stuff 
# configure ssh config with multiple hosts and keys

# update and install
apt update -y && sudo apt upgrade -y
apt install -y git tmux curl wget vim python3 python3-venv python3-pip python3-dev build-essential libeccodes-tools libeccodes-dev 


curl -LsSf https://astral.sh/uv/install.sh | sh

uv venv .wv-venv
source .wv-venv/bin/activate
uv pip install --upgrade pip setuptools wheel

# install all data science packages
uv pip install \
    --find-links https://girder.github.io/large_image_wheels \
    numpy pandas matplotlib seaborn scikit-learn scipy jupyterlab \
    xarray cfgrib netCDF4 eccodes pysteps GDAL pyproj zarr cartopy xeofs \
    torch torchvision

# set virtualenv as default for the user
echo "source ~/.wv-venv/bin/activate" >> ~/.bashrc
echo "export PATH=\"~/.wv-venv/bin:\$PATH\"" >> ~/.bashrc

# create ssh keys

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
mkdir -p .ssh/wv


for u in wv1 wv2 wv3 wv4 wv5 wv6 wv7; do
    user=$u

    ssh-keygen -t rsa -b 4096 -f .ssh/wv/${user}-key -N ""

    # Host git-${USER}
    #     Hostname github.com
    #     IdentityFile ~/.ssh/id_rsa.github
    #     IdentitiesOnly yes # see NOTES below
    echo "Host git-${user}" >> ~/.ssh/config
    echo "    Hostname github.com" >> ~/.ssh/config
    echo "    IdentityFile ~/.ssh/wv/${user}-key" >> ~/.ssh/config
    echo "    IdentitiesOnly yes" >> ~/.ssh/config
    echo "\n" >> ~/.ssh/config
    echo "SSH key for $user created and configured."
done


# git remote add origin git@gitserv:myrepo.git

# git remote set-url origin git@git-wv1:myrepo.git
# git remote set-url --push origin git@git-wv1:myrepo.git

