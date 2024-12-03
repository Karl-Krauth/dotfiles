#!/bin/zsh

# Install packages.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get update -y
    sudo apt-get install -y tmux
    sudo apt-get install -y tmate
    sudo apt-get install -y direnv
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew install wget
    brew install tmux
    brew install tmate
    brew install direnv
    brew install font-fira-code
    brew install node
    echo 'export PATH="/opt/homebrew/opt/node@22/bin:$PATH"' >> .zshrc
fi

mkdir -p ~/.bin

# Link tmux file.
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$PWD/.zshrc" "$HOME/.zshrc"

ZSH=~/.bin/oh-my-zsh
PIXI_HOME="$HOME/.bin/pixi"
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc --unattended"
ln -s "$PWD/catppuccin.zsh-theme" "$ZSH/custom/themes/catppuccin.zsh-theme"

curl -fsSL https://pixi.sh/install.sh | PIXI_NO_PATH_UPDATE=1 bash
pixi global install --environment main --expose jupyter --expose ipython jupyter numpy pandas matplotlib ipython seaborn dask scikit-learn xarray napari scikit-image opencv

# Install neovim.
rm -rf ~/.bin/nvim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar xzvf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    mv nvim-linux64 ~/.bin/nvim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
    tar xzvf nvim-macos-arm64.tar.gz
    rm nvim-macos-arm64.tar.gz
    mv nvim-macos-arm64 ~/.bin/nvim
fi

# Copy over the config for neovim.
mkdir -p ~/.config/nvim/
ln -s "$PWD/init.lua" ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua
ln -s "$PWD/plugins.lua" ~/.config/nvim/lua/plugins.lua

source ~/.zshrc

