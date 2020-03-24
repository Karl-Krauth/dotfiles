#/bin/bash

# Install fish.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt-get update -y
    sudo apt-get install -y fish
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install fish
    brew install wget
    brew install vim
fi
echo fish > ~/.bashrc
echo 'source ~/.bashrc' > ~/.bash_profile
cp config.fish ~/.config/fish/config.fish

mkdir ~/.bin

# Install anaconda3
if [[ ! -d ~/.bin/anaconda3 ]]
then
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O anaconda.sh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        wget https://repo.anaconda.com/archive/Anaconda3-2020.02-MacOSX-x86_64.sh -O anaconda.sh
    fi
    bash anaconda.sh -b -p ~/.bin/anaconda3
    rm anaconda.sh
fi

# Install dependencies for CoVim
pip install twisted argparse service_identity

# Copy tmux files.
cp .tmux.conf ~/.tmux.conf

# Copy vim files.
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/colors
cp solarized.vim ~/.vim/colors/
