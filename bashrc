export LANGUAGE="en_US:pt_BR"
export LC_ALL=""        
export LC_TIME="pt_BR.UTF-8"
export LC_MONETARY="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"
export LC_ADDRESS="pt_BR.UTF-8"
export LC_TELEPHONE="pt_BR.UTF-8"
export LC_NAME="pt_BR.UTF-8"
export LC_MEASUREMENT="pt_BR.UTF-8"
export LC_IDENTIFICATION="pt_BR.UTF-8"
export LC_NUMERIC="pt_BR.UTF-8"
export LC_PAPER="pt_BR.UTF-8"
export LANG=en_us_8859_1

setxkbmap -model abnt2 -layout br

set -o vi

export EDITOR=vim
export BC_ENV_ARGS=~/.bcrc
export MINICOM='-con'

alias ll='ls -laF'
alias lt='ls -laFtr'
alias la='ls -A'
alias l='ls -aF'
alias vi='vim -p'
alias rmd='rm -rf'
#alias python3='ipython3'
alias top='htop -d1'
alias updateOS='sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean && sudo apt-get -y purge'
alias updateList1='sudo apt-get -u upgrade --assume-no'
alias updateList2='apt --simulate upgrade'
alias myGlobalIPAddress1='dig +short myip.opendns.com @resolver1.opendns.com'
alias myGlobalIPAddress2='host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk "{print $4}"'
alias myGlobalIPAddress3='wget -qO - icanhazip.com'
alias myGlobalIPAddress4='curl ifconfig.me'
alias myGlobalIPAddress5='curl ifconfig.co'
alias myGlobalIPAddress6='curl icanhazip.com'
alias shred='shred -fuz'

getHWInfo()
{
	if [ $(id -u) -ne 0 ]; then
		echo "You are not root!"
	else
		echo '=== [ biosdecode ] =============================================================================='
		biosdecode
		echo '=== [ dmidecode ] ==============================================================================='
		dmidecode
		echo '=== [ lspci ] ==================================================================================='
		lspci
		echo '=== [ /proc/cpuinfo ] ==========================================================================='
		cat /proc/cpuinfo
		echo '=== [ lsblk ] ==================================================================================='
		lsblk --output-all --all
		echo '=== [ lspci ] ==================================================================================='
		lspci -vv
		echo '=== [ lshw ] ===================================================================================='
		lshw -numeric
		echo '=== [ screenfetch ] ============================================================================='
		screenfetch
	fi
}

scanForThreats()
{
	if [ $(id -u) -ne 0 ]; then
		echo "You are not root!"
	else

# Set /etc/rkhunter.conf
#PKGMGR=DPKG
#UPDATE_MIRRORS=0 to UPDATE_MIRRORS=1
#MIRRORS_MODE=1 to MIRRORS_MODE=0
#WEB_CMD="/bin/false" to WEB_CMD=""

		sudo freshclam
		sudo rkhunter --update

		sudo clamscan -r -i ./
		sudo rkhunter -c
		sudo chkrootkit
	fi
}

ulimit -c unlimited

if [ -e ~/tmp/TMP ]; then
	(rm -rf ~/tmp/TMP/* &) 2>/dev/null
else
	mkdir -p ~/tmp/TMP
fi

#PATH=$PATH:$HOME/.local/bin
#export PATH
