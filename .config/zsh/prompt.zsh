# prompt: "dirname git_info exit_code ❯ "

# git_info:
# ignored when not inside git repositories
# + for staged files
# * for unstaged files
# ! for untracked files

# exit_code is only present if non-zero

autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats 'on %b%c%u%m'
zstyle ':vcs_info:git:*' actionformats 'on %b|%a%c%u%m'

precmd() {
  local last=$?
  vcs_info

  local GIT_TXT=""
  if [[ -n $vcs_info_msg_0_ ]]; then
    GIT_TXT=$vcs_info_msg_0_

    if command git rev-parse --is-inside-work-tree &>/dev/null; then
      if command git ls-files --others --exclude-standard -z --directory --no-empty-directory | grep -qz .; then
        GIT_TXT+="!"
      fi
    fi

    GIT_SEG=" %B%F{yellow}${GIT_TXT}%f%b"
  else
    GIT_SEG=""
  fi

  if (( last != 0 )); then
    EXIT_SEG=" %B%F{red}${last}%f%b"
  else
    EXIT_SEG=""
  fi
}

LEAD_CHAR="❯"

PROMPT='%B%F{blue}%~%f%b${GIT_SEG}${EXIT_SEG} %B${LEAD_CHAR}%b '
