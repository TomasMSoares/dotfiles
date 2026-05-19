export EDITOR='nvim'
export VISUAL='nvim'
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

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

alias ff='firefox'
alias q='exit'
alias grep='grep --color=auto'
alias tum='cd ~/TUM/Master/1FS/'
alias vim='nvim'
alias nvi='nvim'
alias vi='nvim'

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  alias ls='ls -G'
  alias sd='sudo shutdown -h now'

  plugins=(
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  )
else
  # Linux
  alias ls='ls --color=auto'
  alias sd='systemctl poweroff'

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

# Check if plugin even exists
for plugin in $plugins; do
  [[ -f "$plugin" ]] && source "$plugin"
done

setopt PROMPT_SUBST
PROMPT='[%F{208}%n%f@%F{208}%m%f] %F{167}%1~%f ${vcs_info_msg_0_}%f❯ '

