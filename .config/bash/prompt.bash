BB='\[\e[1;34m\]'
YB='\[\e[1;33m\]'
RB='\[\e[1;31m\]'
BOLD='\[\e[1m\]'
RST='\[\e[0m\]'

LEAD_CHAR="❯"

shopt -s promptvars 2>/dev/null

__update_ps1() {
  local last=$?
  local GIT_SEG="" EXIT_SEG=""

  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch
    branch=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short -q HEAD 2>/dev/null) || branch=""

    local flags=""
    git diff --name-only --cached 2>/dev/null | read -r _ && flags+="+"
    git diff --name-only 2>/dev/null | read -r _ && flags+="*"
    git ls-files --others --exclude-standard -z --directory --no-empty-directory 2>/dev/null | grep -qz . && flags+="!"

    if [[ -n $branch ]]; then
      GIT_SEG=" ${YB}on ${branch}${flags}${RST}"
    fi
  fi

  if (( last != 0 )); then
    EXIT_SEG=" ${RB}${last}${RST}"
  fi

  PS1="${BB}\w${RST}${GIT_SEG}${EXIT_SEG} ${BOLD}${LEAD_CHAR}${RST} "
}

PROMPT_COMMAND="__update_ps1"
