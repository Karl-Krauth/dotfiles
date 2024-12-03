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
fi

mkdir -p ~/.bin

# Link tmux file.
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$PWD/.zshrc" "$HOME/.zshrc"

ZSH=~/.bin/oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc --unattended"
ln -s "$PWD/catppuccin.zsh-theme" "$ZSH/custom/themes/catppuccin.zsh-theme"

source ~/.zshrc
curl -fsSL https://pixi.sh/install.sh | PIXI_NO_PATH_UPDATE=1 bash
pixi global install --environment main --expose jupyter --expose ipython jupyter numpy pandas matplotlib ipython seaborn dask scikit-learn xarray napari scikit-image opencv
