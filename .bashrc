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

# [[ "${PATH}" =~ "/bin" ]] || \
  PATH=/bin:$PATH

# [[ "${PATH}" =~ "/usr/bin" ]] || \
  PATH=/usr/bin:$PATH


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
HISTSIZE=10000
HISTFILESIZE=100000

# HOTFIX using vim tmux
# export TERM=xterm-256color

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

alias tm="tmux attach -t base || tmux new -s base"
alias tm-kill="tmux kill-session -t base"

alias tm-gboo='tmux attach -t gboo || ~/tm-gboo'
alias tm-gboo-kill='tmux kill-session -t gboo'

alias tm-gboo-new='tmux attach -t gboo-new || ~/tm-gboo-new'
alias tm-gboo-new-kill='tmux kill-session -t gboo-new'

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#    exec tmux
#fi


alias python=python3
alias pip=pip3

alias sitemirror='wget --mirror --convert-links --adjust-extension --page-requisites --no-parent'

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

shopt -s histappend
PROMPT_COMMAND='history -a'

# some more ls aliases
alias ll='ls -alF --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -ltsh --group-directories-first'
alias vpn='sudo openvpn --config ~/Dropbox/cert/do-vpn-server/vpn4.ovpn'
alias gboo-vpn='sudo openvpn --config /home/vit/Dropbox/cert/gboo/vit.ovpn'
alias https='http --default-scheme=https'
alias dfh='df -HT | grep -v loop'
alias duh='du -sh $(ls -A) | sort -hr'
alias duhp1gb='find . -size +1G -ls | sort -k7n'

# Convert camelCase to camel_case (cc2u) and CAMEL_CASE (cc2U) formats
alias cc2_='sed -r '\''s/([a-z0-9])([A-Z])/\1_\L\2/g'\'

alias gadd='git add'
alias gci='git ci'
alias gpush='git push'
alias gpull='git pull'
alias gco='git co'
alias gst='git st'
alias st='git st'
alias gch='git ch'

cc2u() {
	echo $1 | cc2_
}

cc2U() {
	v=$(cc2u $1)
	echo ${v^^}
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias dockps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias dockports='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"'
alias dockip='docker inspect -f '\''{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\'
alias dconf_gterm_dump='dconf dump /org/gnome/terminal/legacy/ > ~/.gnome-terminal-dconf-dump.txt'
alias dconf_gterm_load='dconf load /org/gnome/terminal/legacy/ < ~/.gnome-terminal-dconf-dump.txt'

alias v=vim
alias yget='yt-dlp -o "~/Videos/YouTube/%(title)s.%(ext)s"'

cd_fzf() {
  d=$(fd --no-ignore-vcs -E node_modules -E bower_components -E dist -E backups -E Android -E snap -t d | fzf --preview 'ls -lh {}' -q "${1}")
  [[ "${d}" != "" ]] && cd "${d}" && pwd
}
alias cf='cd_fzf'

git_fzf() {
  local f
  local stat
  if [[ "${1}" == "--stat" ]]; then
    f="${2}"
    stat="--stat"
  else
    f="${1}"
  fi
  git logp | fzf --preview "git show ${stat} {1}" -q "${f}"
}
alias gz='git_fzf'
alias gf='git_fzf --stat'

# Adding new exit node:
# mkdir $HOME/.tailscale
# echo -n 100..... > $HOME/.tailscale/exit_node1
# tl --- Start vpn WO exit node
# tl 1 --- Start vpn with exit node 1
tl() {
  n=$1
  if [[ "$n" == "" ]];
  then
    (set -x; sudo tailscale up --reset)
  else
    if [[ "$n" == "s" ]];
    then
      (set -x; tailscale status)
    else
      exn=$(cat "$HOME/.tailscale/exit_node$n")
      (set -x; sudo tailscale up --exit-node=$exn)
    fi
  fi
}

alias tl0=tl
alias tls='tl s'
alias tl1='tl 1'
alias tl2='tl 2'
alias tl3='tl 3'
alias tl4='tl 4'
alias tl5='tl 5'
alias tl6='tl 6'

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

#export GOROOT=/home/vit/go
#export GOPATH=$HOME/Projects/crac

#pc() {
#  [ -d .git ] && git name-rev --name-only @
#}

git_branch() {
  echo $(__git_ps1) | sed -re 's/\(([^)]+)\)/\1/'
}

#export PS1="\[\033[32m\]\w|\[\033[33m\]\$(git_branch)\[\033[00m\]$ "
export PS1="\[\033[33m\]\W|\[\033[36m\]\$(git_branch)\[\033[00m\]$ "
#export PS1="\[\033[33m\]\W\[\033[00m\]$ "

#export PS1='[\[\033[01;34m\]`/bin/date +"%T"`\[\033[00m\]] \w`__git_ps1 " [\[\033[01;31m\]%s\[\033[00m\]"]`\$ '
export PATH=/usr/local/go/bin:$HOME/bin:$HOME/go/bin:$HOME/.composer/vendor/bin/:$HOME/.dotnet:$HOME/.dotnet/tools:$HOME/.local/bin:$HOME/Apps:$HOME/.dotnet:$PATH:$HOME/flutter/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

if [[ -d "$HOME/Android" ]];
then
	export PATH=$HOME/Android/Sdk/platform-tools:$PATH
fi

if [[ -d /home/linuxbrew/.linuxbrew ]];
then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
fi

if [[ -d /home/vit/.dotnet ]];
then
  export DOTNET_ROOT=/home/vit/.dotnet
fi

bind -f ~/.inputrc

export MARKPATH=$HOME/.marks

export LC_COLLATE=ru_RU.UTF-8
export LC_CTYPE=ru_RU.UTF-8

function jump {
  if [[ "${1}" == "" ]]; then
    marks
  else
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
  fi
}

function mark {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

function unmark {
  rm -i "$MARKPATH/$1"
}

function marks {
  if [[ "${1}" != "" ]]; then
    mark "${1}"
  else
    PS3="goto> "
    MARKLIST=$(ls -ltr "$MARKPATH" | sed 's/ / /g' | awk -F' ' '{if (NR > 1) print $9" -> "$11;}')
    options=()
    while read -r line
    do
      options+=("$line")
    done < <(printf '%s\n' "$MARKLIST")
    COLUMNS=12
    select ma in "${options[@]}";
    do
      mm=$(echo "${ma}" | cut -d' ' -f1 -)
      jump "${mm}"
      break;
    done
  fi
}

alias j='jump'
alias um='unmark'
alias m='marks'

_completemarks() {
   local curw=${COMP_WORDS[COMP_CWORD]}
   local wordlist=$(find $MARKPATH -type l -printf "%f\n")
   COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
   return 0
}

complete -F _completemarks jump unmark

export NVM_DIR="/home/vit/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use 14 > /dev/null
#export PATH=/home/vit/Projects/depot_tools:"$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


use_cpp_vim_templates() {
	for I in ~/.vim_templates/*.cpp; do J=${I##*/}; K=${J%.cpp}; ln -s "$I" "${HOME}/.vim_templates/${K}";  done
}

unuse_vim_templates () {
	find "${HOME}/.vim_templates" -maxdepth 1 -type l -delete
}

alias weechat="ssh root@188.226.139.136 -t screen -x"
alias tb="nc termbin.com 9999"


if [ -d $HOME/Android/Sdk ];
then
	export ANDROID_SDK=$HOME/Android/Sdk
	export ANDROID_SDK_ROOT=$HOME/Android/Sdk
	export PATH=$HOME/Android/Sdk/emulator:$PATH

fi

if [ -d $HOME/.cargo/bin ];
then
  export PATH=$HOME/.cargo/bin:$PATH
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/vit/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/vit/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/vit/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/vit/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

export PATH=$PATH:~/Bin
alias k=kubectl
complete -F __start_kubectl k
. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/home/vit/yandex-cloud/path.bash.inc' ]; then source '/home/vit/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/vit/yandex-cloud/completion.bash.inc' ]; then source '/home/vit/yandex-cloud/completion.bash.inc'; fi

export BORG_REMOTE_PATH=/usr/local/bin/borg1/borg1

alias _ssh=$(which ssh)
if [ "${TMUX}" != "" ]; then
ssh() {
  tmux rename-window "ssh";
 # tmux select-pane -T "[ssh $@]";
 printf "\033]2;[ssh $@]\033\\"
 tmux set pane-border-format "#{pane_index} #T"
  _ssh $@;
  tmux select-pane -T "bash";
}
fi

# complete -o default -F __start_kubectl k
