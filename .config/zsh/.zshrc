# Mamiza's zsh config

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/prompt.zsh" ]; then
	source "$HOME/.config/zsh/prompt.zsh"
else
	PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
fi

setopt autocd		# Automatically cd into typed directory.
setopt interactivecomments
stty stop undef		# Disable ctrl-s to freeze terminal.

# Better history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_APPEND

# Command and Path corrections
setopt CORRECT
setopt CORRECT_ALL

# History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.cache/zsh/history
[ -d "$(dirname $HISTFILE)" ] || mkdir -p "$(dirname $HISTFILE)"

# Use `fzf` for reverse history search and completion
source <(fzf --zsh 2>/dev/null)

# Load aliases and shortcuts if existent:
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# Hide directories and non-executable files inside PATH entries from command completion.
_path_ignored=()
for _dir in $path; do
    [[ -d "$_dir" ]] || continue

    _path_ignored+=( "$_dir"/*(/N:t) )

    for _file in "$_dir"/*(N.); do
        [[ -x "$_file" ]] || _path_ignored+=( "${_file:t}" )
    done
done

if (( $#_path_ignored )); then
    _path_ignored=( ${(u)_path_ignored} )
    zstyle ':completion:*:*:-command-:*:commands' ignored-patterns ${(b)_path_ignored}
fi

unset _path_ignored _dir _file
zstyle ':completion:*' completer _complete
# This mostly solves the issue where the directories inside '~/.local/bin' show up as executables.
# But `zsh-fast-syntax-highlighting-git` still highlights them green when written at the command line.
# TODO: Investigate to fix.

# Basic auto/tab completion:
autoload -U compinit
zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zmodload zsh/complist
compinit
_comp_options+=(globdots)	 # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use bash style word selection:
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style bash

# Use vim keys in tab completion menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v "^?" backward-delete-char

# Some more keybindings:
bindkey "^A" beginning-of-line
bindkey "^H" backward-kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Changes cursor shape for different vi modes.
function
zle-keymap-select()
{
	case $KEYMAP in
		vicmd) echo -ne "\e[1 q";;	# Block
		viins|main) echo -ne "\e[5 q";;	# beam
	esac

}
zle -N zle-keymap-select
zle-line-init()
{
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
}
zle -N zle-line-init
echo -ne "\e[5 q"		# Use beam shaped cursor on startup.
preexec()
{
	echo -ne "\e[5 q"	# Use beam shaped cursor for each new prompt.
}

# Fully expand aliases 
zmodload zsh/parameter

expand-aliases-to-history() {
    local full_buffer=$BUFFER
    local cmd=${full_buffer%% *}
    local rest=${full_buffer#$cmd}
    
    # Recursive expansion loop
    while [[ -n "$aliases[$cmd]" ]]; do
        local expansion=${aliases[$cmd]}
        
        # Prevent infinite recursion if alias points to itself
        if [[ "$expansion" == "$cmd" ]]; then break; fi

        local next_cmd=${expansion%% *}
        local next_rest=${expansion#$next_cmd}
        
        cmd=$next_cmd
        # Concatenate directly: the alias definition and the command line 
        # already contain the necessary spaces.
        rest="${next_rest}${rest}"
    done
    
    BUFFER="${cmd}${rest}"
    zle accept-line
}

# Ensure the widget is registered (if you haven't already)
zle -N expand-aliases-to-history
# Uncomment to enable
#bindkey '^M' expand-aliases-to-history

if [ -x "$(command -v lf)" ]; then
	lfcd()
	{
		tmp="$(mktemp)"
		lf -last-dir-path="$tmp" "$@"
		[ -f "$tmp" ] && {
			dir="$(cat "$tmp")"
			rm -f "$tmp" >/dev/null
			[ -d "$dir" ] && [ "$dir" != "$pwd" ] && cd "$dir"
		}
	}

	bindkey -s "^o" "lfcd\n"
fi

autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

# Load command_not_found handler.
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null || {
	source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/command-not-found.zsh" 2>/dev/null
}

# Load syntax highlighting; should be last; unless using autosuggestions.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# Load fish like autosuggestions; should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
