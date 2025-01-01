#!/bin/bash

command_exist()
{
	command -v "$1" >/dev/null 2>&1
}

echo "Starting setup..."

if command_exist nvim; then
	echo "Nvim installed"
else
	echo "Installing Neovim..."

	if command_exist apt; then
		sudo apt update && sudo apt install -y neovim
	elif command_exist brew; then
		brew install neovim
	elif command_exist pacman; then
		sudo packman -S meovim --noconfirm
	else
        	echo "Could not detect a supported package manager. Please install Neovim manually."
		exit 1
	fi
fi

command git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
