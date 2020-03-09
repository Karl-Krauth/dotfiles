#/bin/bash

# Install fish.
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish
echo fish > ~/.bashrc
cp config.fish ~/.config/fish/config.fish

# Install anaconda3
mkdir ~/bin
wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh -b -p ~/bin/anaconda3

# Copy tmux files.
cp .tmux.conf ~/.tmux.conf

# Copy vim files.
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/colors
cp solarized.vim ~/.vim/colors/
