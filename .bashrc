#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\n\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\n\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true


if ${use_color} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi

  alias ls='ls --color=auto'
  alias grep='grep --colour=auto'
  alias egrep='egrep --colour=auto'
  alias fgrep='fgrep --colour=auto'
fi

# Sets the PS1 prompt, loud and proper. Has git integrations and previous
# command status
__ps1() {
  local exit_code="$?"
  local branch=$(git branch --show-current 2>/dev/null)

  if ${use_color}; then
    local q='\[\e[0;35m\]'
    local g='\[\e[0;32m\]'
    local h='\[\e[0;34m\]'
    local w='\[\e[1;33m\]'
    local b='\[\e[1;31m\]'
    local u='\[\e[0;33m\]'
    local x='\[\e[0m\]'
    local s='\[\e[0;31m\]'

    local user="$u\u"
    local host="$h\h"
    local dir="$w\W"
    [[ ${EUID} == 0 ]] && user="${u}root"
    [[ -n "$branch" ]] && branch="$g(⎇ $b$branch$g)"
    [[ $exit_code != 0 ]] && exit_code="⚠️  ${s}$exit_code" || exit_code=""

    PS1="$q[$user$g@$host$g:$dir$branch$q] $exit_code\n$q\$$x "
  else
    local user="\u"
    local host="\h"
    local dir="\W"
    [[ ${EUID} == 0 ]] && user="root"
    [[ -n "$branch" ]] && branch="(⎇ $branch)"

    PS1="[$user@$host:$dir$branch]\n\$"
  fi
}  
PROMPT_COMMAND="__ps1"

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# The above lines were added by default on Manjaro

# Personal Options

CDPATH="."
CDPATH+=":~/.local/bin"
CDPATH+=":~/repos"
CDPATH+=":~/repos/github.com/deyloop"

export SCRIPTS_DIR="$HOME/.local/bin/scripts"

PATH="$HOME/tools/flutter/bin:$PATH"
PATH="$HOME/.config/emacs/bin/:$PATH"
PATH="$HOME/tools/:$PATH"
PATH="$HOME/go/bin:$PATH"
PATH="$SCRIPTS_DIR:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH"


alias dotfiles='/usr/bin/git --git-dir=/home/dac/.dotfiles --work-tree=/home/dac'

alias scripts='cd ~/.local/bin/scripts'

alias emacs-restart='systemctl --user restart emacs'
alias emacs-start='systemctl --user start emacs'
alias emacs-stop='systemctl --user stop emacs'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

. cdl.sh

# vi keybindings for terminal
set -o vi
