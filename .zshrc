export EDITOR='nvim'
export VISUAL='nvim'
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/dotfiles/scripts"
  "$HOME/go/bin"
  $path
)
export PATH

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# Formatting for git branches 
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{208}(%b)%f '
zstyle ':vcs_info:*' enable git

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

local -a plugins=()

alias q='exit'
alias grep='grep --color=auto'

alias vim='nvim'
alias nvi='nvim'
alias vi='nvim'

alias lg='lazygit'

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  alias l='ls -G'
  alias ls='ls -G'
  alias sd='sudo shutdown -h now'

  plugins=(
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  )
else
  # Linux
  alias l='ls --color-auto'
  alias ls='ls --color=auto'
  alias sd='systemctl poweroff'
  alias set-wallpaper='awww img'  # awww caches it, so it survives reboots

  if [[ -d "/usr/share/zsh/plugins" ]]; then
    # For Arch
    plugins=(
      "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    ) 
  else
    # For Debian, Ubuntu, etc.
    plugins=(
      "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    )
  fi
fi

# Tool integrations (before plugins: syntax-highlighting must wrap their widgets)
# fzf: Ctrl-R history, Ctrl-T insert file, Alt-C cd into dir
command -v fzf >/dev/null && source <(fzf --zsh)
# zoxide: z <part-of-path>, zi for an interactive picker
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
# worktrunk: lets `wt switch` cd the current shell into the worktree
command -v wt >/dev/null && eval "$(wt config shell init zsh)"

# Check if plugin even exists
for plugin in $plugins; do
  [[ -f "$plugin" ]] && source "$plugin"
done

setopt PROMPT_SUBST
PROMPT='[%F{208}%n%f@%F{208}%m%f] %F{167}%1~%f ${vcs_info_msg_0_}%f❯ '

# Load local zsh config
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

