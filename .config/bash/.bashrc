# Mamiza's bash config

# Change prompt:
PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
stty -ixon      # Disable ctrl-s to freeze terminal.
shopt -s autocd # Automatically cd into typed directory.

# History in cache directory:
HISTSIZE=
HISTFILESIZE=
HISTFILE=~/.cache/bash/history
[ -d "$(dirname $HISTFILE)" ] || mkdir -p "$(dirname $HISTFILE)"

# Load aliases and shortcuts if existent:
# shellcheck disable=1091
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# Bash completion:
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# command_not_found:
[ -f /usr/share/doc/pkgfile/command-not-found.bash ] && source /usr/share/doc/pkgfile/command-not-found.bash

# Some keybindings:
bind '"\e[3;5": kill-word'
bind '"\C-H": backward-kill-word'
