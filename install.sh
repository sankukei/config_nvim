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

start_conf()
{
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
			sudo apt update > /dev/null && sudo apt install -y neovim > /dev/null
		elif command_exist brew; then
			brew install neovim > /dev/null
		elif command_exist pacman; then
				sudo packman -S meovim --noconfirm > /dev/null
		else
        		echo "Could not detect a supported package manager. Please install Neovim manually."
		exit 1
		fi
	fi

	command git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim > /dev/null 2>&1

	echo "Importing custom configuation..."

	command git clone https://github.com/sankukei/config_nvim.git\
	~/.config/nvim > /dev/null 2>&1

	command nvim --headless -c 'source ~/.config/nvim/lua/core/plugins.lua'\
		-c 'PackerSync' -c 'autocmd User PackerComplete quitall' > /dev/null 2>&1 

	CMD_PID=$!
	spin='-\|/'
	i=0
	while kill -0 $CMD_PID 2>/dev/null; do
    		printf "\rRunning PackerSync... %s" "${spin:i++%${#spin}:1}"
    		sleep 0.1
	done

	echo "All modules installed sucesfully"
	echo -e "${GREEN}Instalation completed :)${NC}" 
}


echo -e "${RED}This will delete all config files for neovim${NC}, please backup or abort if you care about these\n Do you want to continue ?"

read -p "(yes/no) " yesno
if [ "$yesno" == "yes" ] ; then
	start_conf
else
{
	echo "Aborting"	
	exit 1
}
fi


