#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

command_exist()
{
	command -v "$1" >/dev/null 2>&1
}

echo "Deleting neovim and all config files"

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

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

 echo "Importing custom configuation..."

 command git clone https://github.com/sankukei/config_nvim.git\
 ~/.config/nvim

command nvim --headless -c 'source ~/.config/nvim/lua/core/plugins.lua' -c 'PackerSync' -c 'autocmd User PackerComplete quitall'

echo "All modules installed sucesfully"
echo -e "${GREEN}Instalation completed :)${NC}" 
