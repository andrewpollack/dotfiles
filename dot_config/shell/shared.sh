# ~/.config/shell/shared.sh
# Shared config for bash + zsh (keep this POSIX-ish)

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
case "$-" in
  *i*)
    if [ -z "${TMUX:-}" ] && [ -t 1 ]; then
      if ! in_vscode; then
        tmux new-session -A -s "${USER}"
      fi
    fi
    ;;
esac
