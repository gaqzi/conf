[ -z $ZSH ] && export ZSH=$HOME/code/conf/zshrc/
fpath=($ZSH/functions $fpath)

export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

for file ($ZSH/lib/*.zsh) source $file
for file ($ZSH/plugins/*.zsh) source $file

# Enable auto-execution of functions
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

setopt MULTIOS # multiple output redirections
setopt ALWAYS_TO_END
setopt NO_AUTO_MENU
setopt NO_CORRECT
setopt NO_BEEP
setopt EMACS
setopt EXTENDED_GLOB

export BLOCKSIZE=K
export LANG=en_US.UTF-8
export LC_CTYPE=sv_SE.UTF-8
export TZ=Asia/Singapore
export PAGER=less
export EDITOR=vim
export RSPEC=true
export WORDCHARS="${WORDCHARS:s#/#}" # Remove / from WORDCHARS, leave the rest

source $ZSH/prompt.zsh
