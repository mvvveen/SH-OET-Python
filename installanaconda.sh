#!/bin/bash

# This script installs Python 2.7.6 3.3.5 and Anaconda3
# My Anaconda don't want none unless you got buns hun


clear
echo "This script will install and configure anaconda software for your system"

# Check whether you are root

if [ "$(whoami)" == "root" ]; then
        echo "Sorry, you are running with root, please run without sudo rights"
        exit 1
fi

# Let's download pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv

# Let's install some dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libpq-dev python-dev  pkg-config libpng-dev libfreetype6-dev

# Let's set some of those environment variables and make sure them suckers stick after a reboot (needs some checks)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Here we install the actual python versions
pyenv install 3.3.5
pyenv rehash
pyenv install 2.7.6
pyenv rehash

git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# Let's install some demo stuff
pyenv virtualenv 2.7.6 venv_2.7.6_deformdemo
pyenv virtualenv 3.3.5 venv_3.3.5_deformdemo
# Created venv in ~/.pyenv/versions/venv_3.3.5_deformdemo

git clone https://github.com/Pylons/deformdemo.git ~/deformdemo
cd ~/deformdemo
pyenv activate venv_2.7.6_deformdemo
pip install setuptools --upgrade
python setup.py develop

pyenv activate venv_3.3.5_deformdemo
pip install setuptools --upgrade
pip install gunicorn
python setup.py develop

# Here we download that snake if it is not there already
if [ ! -f  "./Anaconda3-4.3.0-Linux-x86_64.sh" ]; then
wget https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
fi

# Let's start the sucker
bash Anaconda3-4.3.0-Linux-x86_64.sh

# More environment variables to set
export PATH="~/anaconda3/bin:$PATH"
echo export PATH="~/anaconda3/bin:$PATH" >> ~/.bashrc

# Stuff used to make the websites work 
conda install pandas -y
conda install jupyter -y
conda/pip install pyjade
conda/pip install numpy
pip install geoalchemy2
pip install sqlalchemy_utils
pip install transaction
pip install pyramid
pip install geojson
pip install gunicorn

# This one is need to connect python to postgresql
sudo apt-get build-dep -y python-psycopg2

# This one is a conveniant way to start the website (look into changing this to systemctl services)
sudo apt-get install -y supervisor
sudo systemctl enable supervisor
