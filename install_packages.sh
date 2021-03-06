## TODO Change ownership of folders created by sudo
## TODO Git config


#!/bin/bash

# Update/Upgrade
apt-get update
apt-get upgrade

# General packages
apt-get install -y \
    build-essential curl vim \
    tree git tmux gnome-tweak-tool \
    apt-transport-https ca-certificates \
    software-properties-common rename
echo 'set -g default-terminal "screen-256color"' >> $HOME/.tmux.conf

# VS Code
wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O vscode_stable.deb
dpkg -i vscode_stable.deb
rm -f vscode_stable.deb

# VS Code extensions
code --install-extension dbaeumer.vscode-eslint
code --install-extension EditorConfig.EditorConfig
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.csharp
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension PeterJausovec.vscode-docker
code --install-extension PKief.material-icon-theme


# Configure settings for VS Code
mkdir -p "$HOME/.config/Code/User"
cat << EOF > $HOME/.config/Code/User/settings.json
{
    "window.zoomLevel": 0.8,
    "workbench.iconTheme": "material-icon-theme"
}
EOF

cat << EOF > $HOME/.config/Code/User/keybindings.json
[
    {
        "key": "ctrl+t",
        "command": "workbench.action.terminal.focus"
    },
    {
        "key": "ctrl+t",
        "command": "-workbench.action.showAllSymbols"
    },
    {
        "key": "ctrl+shift+numpad_add",
        "command": "git.stageAll"
    },
    {
        "key": "ctrl+alt+numpad2",
        "command": "editor.action.copyLinesDownAction",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+shift+alt+down",
        "command": "-editor.action.copyLinesDownAction",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+alt+numpad8",
        "command": "editor.action.copyLinesUpAction",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+shift+alt+up",
        "command": "-editor.action.copyLinesUpAction",
        "when": "editorTextFocus && !editorReadonly"
    }
]
EOF


# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
apt-get update
apt-get install -y spotify-client

# Nodejs
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt install -y nodejs

# NPM packages
npm i -g eslint

# Docker
apt update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt-cache policy docker-ce
apt install -y docker-ce
usermod -aG docker ${USER}
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Workrave
add-apt-repository -u ppa:rob-caelers/workrave
apt update
apt install -y workrave-gnome

# Redshift
apt-get install -y redshift-gtk

# .bashrc aliases, settings
cat << EOF >> $HOME/.bashrc

alias cls="clear"

alias gs="git status"
alias gd="git diff"
alias gdc="git diff --cached"

alias dp="docker ps"
alias dpa="docker ps -a"

export PROMPT_COMMAND='history -a' # append history when multiple terminals
EOF

# Git config
cat << EOF >> $HOME/.gitconfig

[alias]
        ls = log --pretty --date='short' --format='%C(auto)%h - %<(16)%an - %<(10)%cd - %<(14)%ar -%m %s%d'
EOF

# Unlimited history size
sed -i.bak 's/HISTSIZE=1000/HISTSIZE=/g' $HOME/.bashrc
sed -i.bak 's/HISTFILESIZE=2000/HISTFILESIZE=/g' $HOME/.bashrc

# Rename default home folders
sed -i.bak 's/\(\w*\)"$/\L\1/' $HOME/.config/user-dirs.dirs

# Rename all folders to lowercase
# cd $HOME
# rename 'y/A-Z/a-z/' *

# Remove Ctrl+Alt+Down and Ctrl+Alt+Up workspace shortcuts from gnome keybindigs
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up  "['']"