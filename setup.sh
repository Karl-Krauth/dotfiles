#!/bin/bash

# Copy tmux files.
cp .tmux.conf ~/.tmux.conf

# Copy vim files.
cp .vimrc ~/.vimrc
mkdir -p ~/.vim/colors
cp solarized.vim ~/.vim/colors/
