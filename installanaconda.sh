#!/bin/bash

# This script installs and sets up Postgresql 9.6 with Postgis extension 2.3 fo$

# Set variables

clear
echo "This script will install and configure anaconda software for your system"
# Check whether you are root

if [ "$(whoami)" == "root" ]; then
        echo "Sorry, you are suposed to run with root, please run without sudo rights"
        exit 1
fi


git clone https://github.com/yyuu/pyenv.git ~/.pyenv

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libpq-dev python-dev  pkg-config libpng-dev libfreetype6-dev
#echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
#echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
#echo 'eval "$(pyenv init -)"' >> ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 3.3.5
pyenv rehash
pyenv install 2.7.6
pyenv rehash

git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
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


if [ ! -f  "./Anaconda3-4.3.0-Linux-x86_64.sh" ]; then
wget https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
fi

bash Anaconda3-4.3.0-Linux-x86_64.sh

export PATH="~/anaconda3/bin:$PATH"
echo export PATH="~/anaconda3/bin:$PATH" >> ~/.bashrc

conda install pandas -y
conda install jupyter -y
pip install pyjade
pip install numpy
pip install geoalchemy2
pip install sqlalchemy_utils
pip install transaction
pip install pyramid
pip install geojson
pip install gunicorn
sudo apt-get build-dep -y python-psycopg2
sudo apt-get install -y supervisor
sudo systemctl enable supervisor

