if [ -e $HOME/.zsh/.zshlocalenv ]; then
  source $HOME/.zsh/.zshlocalenv
fi

export XDG_CONFIG_HOME=~/.config

export EDITOR=vim
alias cd..='cd ..'
setopt no_beep
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
alias make='make -j12'
alias rzsh='source ~/.zshrc'
