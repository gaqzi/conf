# $FreeBSD: src/share/skel/dot.cshrc,v 1.13 2001/01/10 17:35:28 archie Exp $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
#

# I'm *not* abusing aliases :P
alias h		history 25
alias j		jobs -l
alias la	ls -a
alias lf	ls -FA
alias ll	ls -lA
alias ls	ls -G
alias ssu	ssh ba@sanitarium.se
alias ssc	ssh ba@cell.sanitarium.se
alias amplayer mplayer -aid 1 -sid 0


# A righteous umask
umask 22

set path = (/opt/local/bin /opt/local/sbin /usr/local/mysql-5.0.41-osx10.4-i686/bin/ /opt/local/lib/postgresql82/bin /sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin /var/lib/gems/1.8/bin $HOME/bin)

setenv	EDITOR	vim
setenv	PAGER	less
setenv	BLOCKSIZE	K
setenv LC_CTYPE sv_SE.UTF-8
#setenv LC_CTYPE sv_SE.UTF-8
#setenv LC_CTYPE "sv_SE.UTF-8 xterm \
	#	fn '-Misc-Fixed-Medium-R-SemiCondensed--13-120-75-75-C-60-ISO10646-1'"
setenv TZ Europe/Stockholm
#setenv LC_ALL sv_SE.ISO_8859-1
setenv RSPEC true

# WMII
setenv WMII_SELCOLORS '#eeeeee #506070 #708090'
setenv WMII_NORMCOLORS '#bbbbbb #222222 #000000'
setenv WMII_FONT '-artwiz-snap.de-*-*-*-*-*-*-*-*-*-*-*-*'

# Some sane defauls for different systems
# Always show colors with ls and use cyan for folders
#  http://mipsisrisc.com/ - lscolors generator
if($OSTYPE != "bsd") then
	setenv LS_COLORS 'di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
	alias ls ls --color=always
else
	setenv LSCOLORS gxfxcxdxbxegedabagacad
	alias ls ls -G
endif

limit coredumpsize 0

if ($?prompt) then
	set nobeep
	# An interactive shell -- set some stuff up
	if ($TERM != "cons25" || $TERM != "dumb") then
		set ellipsis set prompt='%{^[]0;%n@%m, %.03, %P, CODE=%?^G%}%B%n%b@%m: %.02%# '
	else
		set prompt='%B%n%b@%m: %.02%# '
	endif
	set filec
	set autolist
	set color
	set colorcat
	set nobeep
	set fignore = (.o \~)
	set rmstar
	set savehist=(1000 merge)
	set history = 100
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
#		bindkey ^I complete-word-fwd
	endif
endif
