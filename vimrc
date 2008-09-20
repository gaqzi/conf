" Björn Anderssons .vimrc file
"
" convert all files to unix format and set default fileformat to unix
set ffs=unix
set ff=unix
filetype on
filetype indent on
filetype plugin on
:color desert
let g:rails_level=4
" backspace at beginning of line takes you to the previous line
set backspace=2
" i tend to mess up - keep backups!
set backup
" where to store backups
set backupdir=~/tmp
" we don't want to be compatible with good old vi...
set nocompatible
" keep my sanity
set backspace=indent,eol,start
" what lazy coder can be without it?
set autoindent
set smartindent
" i don't use the history feature a lot
set history=20
" i'm torn on this... it's nice to have but messes up copying and pasting
set number
" show cursor position and position in file
set ruler
" show incomplete commands
set showcmd
" highlighting as we type in search phrase is nice
set incsearch
" don't highlight the results though... annoying sometimes
set hlsearch
" don't ignore case on search
set noignorecase
" what bracket matches what bracket?
set showmatch
" sometimes i forget if i'm in visual or editing mode...
set showmode
" beeps are annoying
set visualbell
" continue comments on next line (this *can* get annoying too)
set formatoptions=crq
" syntax highlighting... colors... feels like christmas
syntax on
" show/list special characters (tabs in this case)
"set lcs=tab:».
set lcs=tab:».,trail:·
set list
" set our tabs to 4 spaces
set tabstop=4
set softtabstop=4
" number of spaces for autoindentation
set sw=4
" i use terminals with light backgrounds
set background=dark
" keep a context when scrolling
set scrolloff=5
" use global flag by default with :%s/foo/bar/
set gdefault
" fast terminal connection
set ttyfast
" set these two if you don't like tabs and want to autoconvert
" them to spaces (edit file type)
"set et
" retab (perl, shell, python, php and ruby script) files with
" tabstops longer than 4 spaces, very nifty
au BufRead *.pl,*.sh,*.py,*.php,*.rb %retab
" quit with a single keypress ('q')
map q :q<CR>
" write a changelog entry
" map <F7> :i Björn Andersson <ba@sanitarium.se> (c) 2006 * |
autocmd FileType ruby,eruby call UseRubyIndent()
