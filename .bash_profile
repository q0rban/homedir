# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

alias la="ls -la"
alias free="free -m"
alias key="cat ~/.ssh/id_rsa.pub"

# Git Aliases
alias gst='git status'
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

# Now check for the __git_ps1 function.
if type -t __git_ps1 &> /dev/null; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  PS1='\[\033[1;36m\]\u\[\033[1;32m\]@\h\[\033[0;33m\] \w\[\033[1;32m\] $(__git_ps1 "(%s)")\[\033[00m\]: '
else
  PS1='\[\033[1;36m\]\u\[\033[1;32m\]@\h\[\033[0;33m\] \w\[\033[1;32m\]\[\033[00m\]: '
fi

export PATH
export PS1
