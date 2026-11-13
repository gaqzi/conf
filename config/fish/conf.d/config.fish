set -x LANG 'en_US.UTF-8'
set -x LC_ALL 'en_US.UTF-8'
set -x LC_CTYPE 'sv_SE.UTF-8'
set -x EDITOR 'nvim'

set fish_color_autosuggestion c0c0c0  # silver
alias vim nvim
alias cat bat
alias less bat
alias ls lsd

[ -f $HOME/.local/fishrc ]; and source $HOME/.local/fishrc

set -x PATH $HOME/.local/bin $PATH

# Fish picks its word/token bindings by the OS it runs on (Darwin: option
# moves and deletes by word). When a Mac reaches this shell over rex, use
# the Mac bindings so option-backspace behaves like it does locally.
if status is-interactive; and test (uname) != Darwin; and set -q REX_SESSION
    and rex client ls --session $REX_SESSION --json 2>/dev/null | jq -e 'any(.clients[]; .info.platform == "macos")' >/dev/null
    bind alt-backspace backward-kill-word
    bind ctrl-alt-h backward-kill-word
    bind ctrl-backspace backward-kill-token
    bind alt-delete kill-word
    bind ctrl-delete kill-token
    bind alt-right nextd-or-forward-word
    bind alt-left prevd-or-backward-word
    bind ctrl-right forward-token
    bind ctrl-left backward-token
end
