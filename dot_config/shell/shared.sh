# ~/.config/shell/shared.sh
# Shared config for bash + zsh (keep this POSIX-ish)

path_prepend() { case ":$PATH:" in *":$1:"*) :;; *) PATH="$1:$PATH";; esac; }
path_append()  { case ":$PATH:" in *":$1:"*) :;; *) PATH="$PATH:$1";; esac; }

# Common paths (safe if they don't exist)
[ -d "$HOME/.local/bin" ] && path_prepend "$HOME/.local/bin"
[ -d "$HOME/bin" ] && path_prepend "$HOME/bin"

export GREP_COLORS="ms=01;38;5;198:mc=01;38;5;198:sl=:cx=:fn=35:ln=32:bn=32:se=36"
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

export LANG="en_US.UTF-8"

export EDITOR="vim"
export VISUAL="vim"

alias k="kubectl"
alias ll="ls -lah"
alias la="ls -A"

# Detect VS Code terminal
in_vscode() {
  [ "${TERM_PROGRAM:-}" = "vscode" ] || [ -n "${VSCODE_PID:-}" ]
}

# --- ls colors (portable: macOS + Linux) ---
case "${OSTYPE:-}" in
  darwin*)
    if command -v gls >/dev/null 2>&1; then
      alias ls='gls --color=auto --group-directories-first'
      if command -v vivid >/dev/null 2>&1; then
        export LS_COLORS="$(vivid generate molokai)"
      fi
      export LS_COLORS="${LS_COLORS}:di=38;5;45:ln=38;5;141:ex=01;38;5;118:or=01;38;5;196"
    else
      export CLICOLOR=1
      export CLICOLOR_FORCE=1
      export LSCOLORS="GxFxCxDxBxegedabagaced"
      alias ls='ls -G'
    fi
    ;;
  linux*)
    alias ls='ls --color=auto --group-directories-first'
    if command -v vivid >/dev/null 2>&1; then
      export LS_COLORS="$(vivid generate molokai)"
    elif command -v dircolors >/dev/null 2>&1; then
      eval "$(dircolors -b)"
    fi
    export LS_COLORS="${LS_COLORS}:di=38;5;45:ln=38;5;141:ex=01;38;5;118:or=01;38;5;196"
    ;;
esac

# Starship prompt (works for both shells)
if command -v starship >/dev/null 2>&1; then
  case "${SHELL##*/}" in
    zsh)  eval "$(starship init zsh)" ;;
    bash) eval "$(starship init bash)" ;;
  esac
fi

# tmux autostart (interactive only, not VS Code, not already inside tmux)
# Note: bash uses $- to detect interactive; zsh does too.
# case "$-" in
#   *i*)
#     if [ -z "${TMUX:-}" ] && [ -t 1 ]; then
#       if ! in_vscode; then
#         tmux new-session -A -s "${USER}"
#       fi
#     fi
#     ;;
# esac
