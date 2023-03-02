#/bin/bash

# Install packages.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-add-repository -y ppa:fish-shell/release-3
    sudo apt-get update -y
    sudo apt-get install -y fish
    sudo apt-get install -y tmux
    sudo apt-get install -y tmate
    sudo apt-get install -y direnv
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install fish
    brew install wget
    brew install tmux
    brew install tmate
    brew install direnv
fi

# Install fish.
echo fish > ~/.bashrc
echo 'source ~/.bashrc' > ~/.bash_profile
cp config.fish ~/.config/fish/config.fish

mkdir -p ~/.bin

# Install anaconda3.
if [[ ! -d ~/.bin/anaconda3 ]]
then
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh -O anaconda.sh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        wget https://repo.anaconda.com/archive/Anaconda3-2022.10-MacOSX-x86_64.sh -O anaconda.sh
    fi
    bash anaconda.sh -b -p ~/.bin/anaconda3
    rm anaconda.sh
fi
conda update --yes conda
conda update --yes anaconda

# Copy tmux files.
cp .tmux.conf ~/.tmux.conf

# Install neovim.
rm -rf ~/.bin/nvim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar xzvf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    mv nvim-linux64 ~/.bin/nvim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz
    xattr -c ./nvim-macos.tar.gz
    tar xzvf nvim-macos.tar.gz
    rm nvim-macos.tar.gz
    mv nvim-macos ~/.bin/nvim
fi

# Copy over the config for neovim.
mkdir -p ~/.config/nvim/
ln -s init.lua ~/.config/nvim/init.lua
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir -p ~/.config/nvim/lua
ln -s plugins.lua ~/.config/nvim/lua/plugins.lua
