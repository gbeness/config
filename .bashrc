# #~/.bashrc

# This is my configuration for bash. I hope to keep it useful across
# the computers I use, without depending on bash for my custom
# functions if I need them from the outside.

# ## Basics {{{
# Include `$HOME/.bin` in `$PATH`.
export PATH=$HOME/.bin:$PATH

export PATH=$PATH:$HOME/Workspace/depot_tools

# Stop executing if this is not an interactive session.
[ -z "$PS1" ] && return

# }}}

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set prompt.
# `root` has a red prompt, others a yellow one.
# If we are connected remotely, `@<hostname>` shows first.
build_ps1() {
    local prompt_color='\[\e[33m\]'
    local host=''
    [[ $UID -eq 0 ]] && prompt_color='\[\e[1;31m\]'
    [[ $SSH_TTY ]] && host="@$HOSTNAME "
    echo "${prompt_color}${host}\w\[\e[0m\] \$ "
}
PS1=$(build_ps1)
PS2='\\ '
PS4='+ $LINENO: '

# Colorize `ls`.
alias ls='ls --color=always'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# disable caps lock
setxkbmap -option caps:none

# bind C-O to C-N
bind '"\C-o": "\C-n"'
bind '"\C-p": history-search-backward'
bind '"\C-o": history-search-forward'
# Show colors in less
alias less='less -R'

# Colorize `grep`.
export GREP_COLORS="1;33"
alias grep='grep --color=auto'

#so as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

#getting vim color schemes to work
export TERM=screen-256color

#using vim as my editor 
export VISUAL=vim
export EDITOR="$VISUAL"

# Attaches tmux to a session (example: ta portal)
alias tmuxattach='tmux a -t'

# Creates a new session
alias tmuxnew='tmux new -s'

# Lists all ongoing sessions
alias tmuxlist='tmux list-sessions'

# Don't let nautilus write recently used items here, as this seems to kill nautilus when sshfs goes down.
[ -f ~/.local/share/recently-used.xbel ] && chmod 400 ~/.local/share/recently-used.xbel

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
