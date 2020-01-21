alias ls='lsd'
alias ll='lsd -lh'
alias la='lsd -lha'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias dl="~/Downloads"
alias pic="~/Pictures"
alias doc="~/Documents"
alias sc="~/.scripts"
alias cfg="~/.config"
alias g="~/git"
alias b="cd .."
alias bb="cd ../.."
alias bbb="cd ../../.."
alias bbbb="cd ../../../.."
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias mkdir='mkdir -pv'
alias vim='nvim'
alias p='sudo pacman -Syu'
alias ga='git ls-files -mo | fzf -m | xargs -r git add; git status'
alias gr='git diff --cached --name-only | fzf -m | xargs -r git reset HEAD; git status'
alias gs='git status'
alias notes='vim ~/Documents/notes.txt'
alias ec=$'vim $(du -a ~/.config/* | awk \'{print $2}\' | fzf)'
alias es=$'vim $(du -a ~/.scripts/ | awk \'{print $2}\' | fzf)'
alias ev='vim ~/.config/nvim/init.vim'
alias psg='ps aux | grep'
alias icdiff='icdiff --color-map="add:green,change:yellow_bold,description:magenta_bold,meta:magenta,separator:magenta_bold,subtract:red_bold,line-numbers:white_bold"'
alias redshift='redshift -PO'
