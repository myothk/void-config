# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias
alias ls='ls --color=auto'
alias lf='lf -single'
alias ssh='TERM=linux ssh'
alias update='sudo xbps-install -Suv'

PS1='\u \W$(git_branch=$(git branch --show-current 2> /dev/null) && echo " ( $git_branch ) " || echo " ")\$ '
