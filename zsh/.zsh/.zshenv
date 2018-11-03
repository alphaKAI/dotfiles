if [ -e $HOME/.zsh/.zshlocalenv ]; then
  source $HOME/.zsh/.zshlocalenv
fi

path=(
  $path
  /opt/*/(s|)bin(N-/)
  /opt/*/(s|)lib(N-/)
  /usr/local/bin/
  /usr/local/opt/*/bin
)
export path

export XDG_CONFIG_HOME=~/.config

export PATH=$PATH:$HOME/usr/bin:$HOME/usr/etc/:$HOME/usr/lib:$HOME/usr/include

export EDITOR=vim
alias cd..='cd ..'
set bell-style visible
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
alias make='make -j12'
alias rzsh='source ~/.zshrc'
