#!/bin/bash
echo -e "Setting up WSL dotfiles"
cat > ~/.tmux.conf <<EOF
# Colored tmux
set -g default-terminal "screen-256color"
set -g history-limit 5000
set -g set-titles on
set-option -g status-position bottom
set-option -g status on
set-option -g status-interval 1
EOF
echo -e ".tmux.conf created."
cat > ~/.vimrc <<EOF
vmap <C-c> y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!cat ~/.vimbuffer \| clip.exe <CR><CR>
map <C-v> :r ~/.vimbuffer<CR>
syntax enable
filetype on
filetype indent on
filetype plugin on
set smartindent
set encoding=utf8
set number
set noswapfile
set smarttab
set shiftwidth=2
set tabstop=2
set expandtab
set wrap
set incsearch
set smartcase
set ignorecase
EOF
echo -e ".vimrc created."
echo -e "Setting up Docker."
sudo apt-get update -y
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce
sudo usermod -aG docker dan
sudo apt install docker-compose
echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc
source ~/.bashrc
sudo cat > /etc/wsl.conf <<EOF
[automount]
root = /
options = "metadata"
EOF
echo "sudo mount --bind /mnt/c /c" >> ~/.bashrc
source ~/.bashrc
echo -e "Created wsl.conf."
echo -e "FINISHED"
echo -e "Don't forget to run: sudo visudo"
echo -e "Add this line: dan ALL=(root) NOPASSWD: /bin/mount"
docker info
docker-compose --version
echo -e "FINISHED"
