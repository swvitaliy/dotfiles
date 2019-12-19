# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Коды для установки цвета фона.
COLOR_BLACK='0;30'
COLOR_BLUE='0;34'
COLOR_GREEN='0;32'
COLOR_CYAN='0;36'
COLOR_RED='0;31'
COLOR_PURPLE='0;35'
COLOR_BROWN='0;33'
COLOR_LIGHTGRAY='0;37'
COLOR_DARKGRAY='1;30'
COLOR_LIGHTBLUE='1;34'
COLOR_LIGHTGREEN='1;32'
COLOR_LIGHTCYAN='1;36'
COLOR_LIGHTRED='1;31'
COLOR_LIGHTPURPLE='1;35'
COLOR_YELLOW='1;33'
COLOR_WHITE='1;37'
COLOR_NOCOLOR='0'

blue(){ tput setaf 4; echo $@; tput sgr0; } 


# Формируем коды для переключения цвета в двух вариантах: для подстановки в приглашение PS1 и для подстановки в обычный echo.
for i in ${!COLOR_*} ; do export PS_$i="\[\033[${!i}m\]" ; export CODE_$i="\033[${!i}m" ; done

# Раскрашиваем приглашение.
#PS1="\
#$PS_COLOR_YELLOW\
#\u@\h\
#$PS_COLOR_NOCOLOR\
#:\
PS1="\
$PS_COLOR_LIGHTGREEN\
\w\
$PS_COLOR_NOCOLOR\$ \
"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vpn='sudo openvpn --config ~/Dropbox/cert/do-vpn-server/vpn4.ovpn'
alias https='http --default-scheme=https'
if [ -f /home/vit/.bashrc.in ]; then
	. /home/vit/.bashrc.in
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# php tools in docker container
# . /opt/Projects/docker/images/php-essentials/bin/essentials.bashrc

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source ~/bash_completion.sh

#export GOROOT=/home/vit/go
#export GOPATH=$HOME/Projects/crac

#pc() {
#  [ -d .git ] && git name-rev --name-only @
#}

git_branch() {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}

#export PS1="\[\033[32m\]\w|\[\033[33m\]\$(git_branch)\[\033[00m\]$ "
export PS1="\[\033[33m\]\w|\[\033[36m\]\$(git_branch)\[\033[00m\]$ "

export PATH=$HOME/bin:$HOME/go/bin:$HOME/.composer/vendor/bin/:/usr/share/dotnet/sdk/2.1.4/:$PATH

export MARKPATH=$HOME/.marks

export LC_COLLATE=ru_RU.UTF-8
export LC_CTYPE=ru_RU.UTF-8

function jump {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

function unmark {
  rm -i "$MARKPATH/$1"
}

function marks {
  ls -l "$MARKPATH" | sed 's/ / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
   local curw=${COMP_WORDS[COMP_CWORD]}
   local wordlist=$(find $MARKPATH -type l -printf "%f\n")
   COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
   return 0
}

complete -F _completemarks jump unmark

export NVM_DIR="/home/vit/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# nvm use v8.11 %1> /dev/null
#export PATH=/home/vit/Projects/depot_tools:"$PATH"
