#/bin/bash

# Install fish.
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt-get update -y
sudo apt-get install -y fish
echo fish > ~/.bashrc
cp config.fish ~/.config/fish/config.fish

mkdir ~/.bin

# Install anaconda3
if [[ ! -f ~/.bin/anaconda3 ]]
then
    wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
    bash Anaconda3-2019.10-Linux-x86_64.sh -b -p ~/.bin/anaconda3
    rm Anaconda3-2019.10-Linux-x86_64.sh
fi

# Copy tmux files.
cp .tmux.conf ~/.tmux.conf

# Copy vim files.
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/colors
cp solarized.vim ~/.vim/colors/
