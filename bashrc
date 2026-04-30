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

# PS1
_CLR_PURPLE="\[\e[0;35m\]"
_CLR_BLUE="\[\e[0;34m\]"
_CLR_WHITE="\[\e[0;37m\]"
_CLR_RESET="\[\e[0m\]"
_PROMPT_CHAR='\$'
PS1="${_CLR_PURPLE}\`is_toolbox\`${_CLR_BLUE}\u@\h:\w${_CLR_WHITE}${_PROMPT_CHAR}${_CLR_RESET} "

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"
export HELIX_RUNTIME="~/Apps/helix/runtime"

# Android toolkit
export PATH="$HOME/Utils/platform-tools:$PATH"

# Podman for Docker containers
export DOCKER_HOST=unix:///run/host/run/user/$(id -u)/podman/podman.sock

# git
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

## aliases & functions
# toolbox
function is_toolbox() {
    if [ -f "/run/.toolboxenv" ]
    then
        TOOLBOX_NAME=$(cat /run/.containerenv | grep -oP "(?<=name=\")[^\";]+")
        echo "[${TOOLBOX_NAME}]"
    fi
}
# btrfs
alias ssdbak-snap-list="sudo btrfs subvolume list /run/media/$USER/SSD_BAK"
alias ssdbak-snap-take="sudo btrfs subvolume snapshot /run/media/$USER/SSD_BAK /run/media/$USER/SSD_BAK/@snapshots/snapshot-$(date +%Y-%m-%d)"
ssdbak-snap-del() {
    sudo btrfs subvolume delete "/run/media/$USER/SSD_BAK/@snapshots/$1"
}

# display sysinfo
macchina
