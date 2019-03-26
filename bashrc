set -o vi
export EDITOR=vim

alias ll='ls -laF'
alias lt='ls -laFtr'
alias la='ls -A'
alias l='ls -aF'
alias vi='vim -p'
alias rmd='rm -rf'
#alias python3='ipython3'
alias top='htop -d1'
alias updateOS='sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean && sudo apt-get -y purge'
alias updatesList='sudo apt-get -u upgrade --assume-no'
alias myGlobalIPAddress='dig +short myip.opendns.com @resolver1.opendns.com'
alias shred='shred -fuz'
