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
export LC_COLLATE="pt_BR.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LANG="en_US.UTF-8"

setxkbmap -model abnt2 -layout br

set -o vi

export EDITOR=vim
export BC_ENV_ARGS=~/.bcrc
export MINICOM='-con'

export PYTHONSTARTUP="$HOME/.pystartup"

alias ll='ls -laF'
alias lt='ls -laFtr'
alias la='ls -A'
alias l='ls -aF'
alias lsz='ls --human-readable --size -1 -S -laF --classify'
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
alias shredfull='shred -fuz'
alias connections1='lsof -iTCP -sTCP:ESTABLISHED'
alias connections2='ss -tlpn'
alias dmesg='dmesg; cut -d " " -f 1 /proc/uptime'
alias displayoff='xset dpms force off'

alias actenv='source venv/bin/activate'
alias deaenv='deactivate'

function createPy()
{
	if [ -n "$1" ]; then
		echo -e '#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n\n' >> "$1".py
		chmod u+x "$1".py
	else
		echo -e 'Usage:\n\tcreatePy python_src_to_create.py'
	fi
}

function createSh()
{
	if [ -n "$1" ]; then
		echo -e '#!/usr/bin/env bash\n\n# Script exit if a command fails:\n#set -e\n\n# Script exit if a referenced variable is not declared:\n#set -u\n\n# If one command in a pipeline fails, its exit code will be returned as the result of the whole pipeline:\n#set -o pipefail\n\n# Activate tracing:\n#set -x\n\n' >> "$1".sh
		chmod u+x "$1".sh
	else
		echo -e 'Usage:\n\tcreateSh shellscript_to_create.sh'
	fi
}

function listFilesBySize()
{
	find $1 -type f -printf "%s %p\n" | sort -rn
}

function litenning()
{
	echo '===[ lsof ]==================================='
	sudo lsof -i -P -n | grep LISTEN
	echo '===[ netstat ]================================'
	sudo netstat -tulpn | grep LISTEN
	echo '===[ nmap ('`hostname -I`')]==================================='
	sudo nmap -A -T4 `hostname -I`
}

function shredall(){
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")

	for AAA in `find . -type f`
	do
		echo "Bye $AAA"
		shred -fuz "$AAA"
	done

	IFS=$SAVEIFS
}

function getHWInfo()
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

function scanForThreats()
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
		sudo lynis update info

		sudo clamscan -r -i ./
		sudo rkhunter -c --sk
		sudo chkrootkit
		lynis audit system
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
