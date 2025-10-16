#!/bin/zsh

# Install packages.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get update -y
    sudo apt-get install -y tmux
    sudo apt-get install -y tmate
    sudo apt-get install -y direnv
    sudo apt-get install -y zip
    sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
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
# Link zshrc.
ln -s "$PWD/.zshrc" "$HOME/.zshrc"

ZSH=~/.bin/oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc --unattended"
ln -s "$PWD/catppuccin.zsh-theme" "$ZSH/custom/themes/catppuccin.zsh-theme"

# Install neovim.
rm -rf ~/.bin/nvim
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzvf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    mv nvim-linux-x86_64 ~/.bin/nvim
elif [[ "$OSTYPE" == "darwin"* ]]; then
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
    tar xzvf nvim-macos-arm64.tar.gz
    rm nvim-macos-arm64.tar.gz
    mv nvim-macos-arm64 ~/.bin/nvim
fi

# Copy over the config for neovim.
mkdir -p ~/.config/nvim/
ln -s "$PWD/init.lua" ~/.config/nvim/init.lua

# Install node.
NVM_DIR="$HOME/.bin/nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$NVM_DIR/nvm.sh"
nvm install 22


# Install rust.
export RUSTUP_HOME="$HOME/.bin/rustup"
export CARGO_HOME="$HOME/.bin/cargo"
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | bash -s -- -y

# Install rust dependencies
# Embedded development tools.
cargo install esp-generate espflash probe-rs --locked


source ~/.zshrc
