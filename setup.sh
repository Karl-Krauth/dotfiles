#!/bin/zsh

# Install packages.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get update -y
    sudo apt install -y cmake
    sudo apt-get install -y direnv
    sudo apt install -y git
    sudo apt install -y libudev-dev
    sudo apt install -y pkg-config
    sudo apt-get install -y tmate
    sudo apt-get install -y tmux
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
    wget -O nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
elif [[ "$OSTYPE" == "darwin"* ]]; then
    wget -O nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
fi
tar xzvf nvim.tar.gz
rm nvim.tar.gz
mv nvim-* ~/.bin/nvim

# Copy over the config for neovim.
mkdir -p ~/.config/nvim/
ln -s "$PWD/init.lua" ~/.config/nvim/init.lua

# Install Python.
wget -O miniforge.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash miniforge.sh -b -p "${HOME}/.bin/miniforge3"
rm miniforge.sh
# Install python dependencies.
# Core data science tools.
mamba install -y ipython jupyter matplotlib numba numpy pandas scikit-learn seaborn scipy
# Xarray stack.
mamba install -y bottleneck dask netCDF4 xarray zarr
# Devtools
pip install uv
uv tool install pre-commit@latest --with pre-commit-uv
uv tool install ruff@latest
# Microscopy
pip install magnify

# Install node.
NVM_DIR="$HOME/.bin/nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$NVM_DIR/nvm.sh"
nvm install 22
# Install node tools.
npm install -g @anthropic-ai/claude-code


# Install rust.
export RUSTUP_HOME="$HOME/.bin/rustup"
export CARGO_HOME="$HOME/.bin/cargo"
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | bash -s -- -y

# Install rust tools.
# Embedded development tools.
cargo install espup esp-generate espflash probe-rs --locked
espup install

source ~/.zshrc
