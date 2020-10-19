set -x LANG 'en_US.UTF-8'
set -x LC_ALL 'en_US.UTF-8'
set -x LC_CTYPE 'sv_SE.UTF-8'
set -x EDITOR 'nvim'

set fish_color_autosuggestion c0c0c0  # silver
alias vim nvim
alias cat bat
alias ls lsd

[ -f $HOME/.fishrc_local ]; and source $HOME/.fishrc_local
