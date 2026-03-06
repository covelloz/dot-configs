# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# PS1 color change to blue
PS1='\[\e[0;34m\]\u@\h:\w\[\e[0m\]\[\e[0;37m\]\$\[\e[0m\] '

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
. "$HOME/.cargo/env"
export PATH="$PATH:$HOME/.cargo/bin"

# PHP
export PATH="/home/covelloz/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/covelloz/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Android toolkit
export PATH="$HOME/Utils/platform-tools:$PATH"

# Podman for Docker containers
export DOCKER_HOST=unix:///run/host/run/user/$(id -u)/podman/podman.sock

# git
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

# If NOT in a Toolbox container
if [ -z "$TOOLBOX_PATH" ]; then
    # Add aliases for Flatpaks
    alias hx='flatpak run com.helix_editor.Helix'
fi

# Display system information
macchina
