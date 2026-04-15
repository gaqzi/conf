" tmux review mode bindings
" Loaded via -S only during tmux-review sessions

let s:target = $REVIEW_TARGET_PANE

" Scroll the pane above
execute 'nnoremap <silent> <C-d> :call system("tmux send-keys -t ' . s:target . ' -X halfpage-down")<CR>'
execute 'nnoremap <silent> <C-u> :call system("tmux send-keys -t ' . s:target . ' -X halfpage-up")<CR>'
execute 'nnoremap <silent> <C-e> :call system("tmux send-keys -t ' . s:target . ' -X scroll-down")<CR>'
execute 'nnoremap <silent> <C-y> :call system("tmux send-keys -t ' . s:target . ' -X scroll-up")<CR>'

" Resize the notes pane (shell out to tmux; vim has no internal split to resize)
nnoremap <silent> + :call system("tmux resize-pane -t " . $TMUX_PANE . " -U 3")<CR>
nnoremap <silent> - :call system("tmux resize-pane -t " . $TMUX_PANE . " -D 3")<CR>
