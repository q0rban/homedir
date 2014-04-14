# .bash_profile

ENVIRONMENT=dev
#ENVIRONMENT=stage
#ENVIRONMENT=prod

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

alias la="ls -la"
alias free="free -m"
alias key="cat ~/.ssh/id_rsa.pub"
alias tab="~/bin/tab.sh"
alias ding="say -v Bells 'all done'"

# Git Aliases
alias gst='git status -sb'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'

# Mac git bash completion.
if hash brew 2>&- && test -f `brew --prefix`/etc/bash_completion; then
  . `brew --prefix`/etc/bash_completion
fi

# Git bash completion on other platforms. You'll need to copy
# git-completion.bash in contrib to /etc/bash_completion.d/
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# If we have private declarations, include them.
if [ -f ~/.bash_private ]; then
  . ~/.bash_private
fi

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[1;31m\]" # foreground red
FGRN="\[\033[1;32m\]" # foreground green
FYEL="\[\033[1;33m\]" # foreground yellow
FBLU="\[\033[1;34m\]" # foreground blue
FMAG="\[\033[1;35m\]" # foreground magenta
FCYN="\[\033[1;36m\]" # foreground cyan
FWHT="\[\033[1;37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLU="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white


case $ENVIRONMENT in
  prod)
    COLOR1=$BRED$FWHT
    COLOR2=$COLOR1
    COLOR3=$COLOR1
    COLOR4=$COLOR1
    DEFAULTCOLOR=$RS$FRED
    ;;
  stage)
    COLOR1=$FYEL
    COLOR2=$FYEL
    COLOR3=$FMAG
    COLOR4=$COLOR2
    DEFAULTCOLOR=$RS
    ;;
  *)
    COLOR1=$FCYN
    COLOR2=$FGRN
    COLOR3=$FYEL
    COLOR4=$FMAG
    DEFAULTCOLOR=$RS
    ;;
esac

# Now check for the __git_ps1 function.
if type -t __git_ps1 &> /dev/null; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  PS1="$COLOR1\u$COLOR2@\h $COLOR3\w $COLOR4\$(__git_ps1 '(%s)')$DEFAULTCOLOR: "
else
  PS1="$COLOR1\u$COLOR2@\h $COLOR3\w$DEFAULTCOLOR: "
fi

export PATH
export PS1
