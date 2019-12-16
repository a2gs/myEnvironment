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

export PS1="--- [\u@\h \t \D{%d/%m/%Y}] ---------------------\n\w \$ "
export PS2="block $PS2"
export PS4="sh debug> "

alias ll='ls -laF'
alias lt='ls -laFtr'
alias la='ls -A'
alias l='ls -aF'
alias lsz='ls --human-readable --size -1 -S -laF --classify'

alias vi='vim -p'
alias top='htop -d1'
alias hexdump='hexdump -Cv'
alias dmesg='dmesg; cut -d " " -f 1 /proc/uptime'
alias topMemUsage='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -20'
alias displayoff='xset dpms force off'
alias bc='bc -lq'
alias diffc='diff -BZEwby -W $COLUMNS --strip-trailing-cr --color'
alias ip='ip -c'

alias rmd='rm -rf'
alias shredfull='shred -fuz'

alias updateOS='sudo apt-get -y update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean && sudo apt-get -y purge'
alias updateList1='sudo apt-get -u upgrade --assume-no'
alias updateList2='apt --simulate upgrade'

alias myGlobalIPAddress1='dig +short myip.opendns.com @resolver1.opendns.com'
alias myGlobalIPAddress2='host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk "{print $4}"'
alias myGlobalIPAddress3='wget -qO - icanhazip.com'
alias myGlobalIPAddress4='curl ifconfig.me'
alias myGlobalIPAddress5='curl ifconfig.co'
alias myGlobalIPAddress6='curl icanhazip.com'
alias connections1='lsof -iTCP -sTCP:ESTABLISHED'
alias connections2='ss -tulpn'
alias connections3='netstat -tupn'

alias lsblk='lsblk -ampfz'
alias findmnt='findmnt -Ae'
alias df='df -ahT'

#alias python3='ipython3'
alias actenv='source venv/bin/activate'
alias deaenv='deactivate'

function createPy()
{
	if [ -n "$1" ]; then
		echo -e "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n\n# Andre Augusto Giannotti Scota (https://sites.google.com/view/a2gs/)\n\nimport sys, os\n\ndef main(argv):\n\tpass\n\nif __name__ == '__main__':\n\tmain(sys.argv)\n\tsys.exit(0)" >> "$1".py
		chmod u+x "$1".py
	else
		echo -e 'Usage:\n\tcreatePy python_src_to_create.py'
	fi
}

function createSh()
{
	if [ -n "$1" ]; then
		echo -e '#!/usr/bin/env bash\n\n# Andre Augusto Giannotti Scota (https://sites.google.com/view/a2gs/)\n\n# Script exit if a command fails:\n#set -e\n\n# Script exit if a referenced variable is not declared:\n#set -u\n\n# If one command in a pipeline fails, its exit code will be returned as the result of the whole pipeline:\n#set -o pipefail\n\n# Activate tracing:\n#set -x\n\n' >> "$1".sh
		chmod u+x "$1".sh
	else
		echo -e 'Usage:\n\tcreateSh shellscript_to_create.sh'
	fi
}

function createC()
{
	if [ -n "$1" ]; then
		echo -e '# Andre Augusto Giannotti Scota (https://sites.google.com/view/a2gs/)' >> makefile
		echo -e '# C flags:' >> makefile
		echo -e 'CFLAGS_OPTIMIZATION = -g' >> makefile
		echo -e '#CFLAGS_OPTIMIZATION = -O3' >> makefile
		echo -e 'CFLAGS_VERSION = -std=c11' >> makefile
		echo -e 'CFLAGS_WARNINGS = -Wall -Wextra -Wno-unused-parameter -Wno-unused-but-set-parameter' >> makefile
		echo -e 'CFLAGS_DEFINES = -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L -D_POSIX_SOURCE=1 -D_DEFAULT_SOURCE=1 -D_GNU_SOURCE=1' >> makefile
		echo -e 'CFLAGS = $(CFLAGS_OPTIMIZATION) $(CFLAGS_VERSION) $(CFLAGS_WARNINGS) $(CFLAGS_DEFINES)' >> makefile
		echo -e '' >> makefile
		echo -e '# System shell utilities' >> makefile
		echo -e 'CC = gcc' >> makefile
		echo -e 'RM = rm -fr' >> makefile
		echo -e 'CP = cp' >> makefile
		echo -e 'AR = ar' >> makefile
		echo -e 'RANLIB = ranlib' >> makefile
		echo -e 'CPPCHECK = cppcheck' >> makefile
		echo -e '' >> makefile
		echo -e 'INCLUDEPATH = -I./' >> makefile
		echo -e 'LIBS = ' >> makefile
		echo -e 'LIBPATH = -L./' >> makefile
		echo -e '' >> makefile
		echo -e 'all: clean exectag' >> makefile
		echo -e '' >> makefile
		echo -e 'exectag:' >> makefile
		echo -e '\t@echo' >> makefile
		echo -e '\t@echo "=== Compiling =============="' >> makefile
		echo -e '\t$(CC) -o '$1 $1'.c $(CFLAGS) $(INCLUDEPATH) $(LIBPATH) $(LIBS)' >> makefile
		echo -e '' >> makefile
		echo -e 'clean:' >> makefile
		echo -e '\t@echo' >> makefile
		echo -e '\t@echo "=== clean_data =============="' >> makefile
		echo -e '\t-$(RM) '$1' core' >> makefile

		echo -e '/* Andre Augusto Giannotti Scota (https://sites.google.com/view/a2gs/) */' >> "$1".c
		echo -e '#include <stdio.h>' >> "$1".c
		echo -e '#include <stdlib.h>' >> "$1".c
		echo -e '#include <unistd.h>' >> "$1".c
		echo -e '#include <string.h>' >> "$1".c
		echo -e '#include <errno.h>' >> "$1".c
		echo -e '#include <signal.h>' >> "$1".c
		echo -e '#include <time.h>' >> "$1".c
		echo -e '#include <sys/types.h>' >> "$1".c
		echo -e '#include <sys/stat.h>' >> "$1".c
		echo -e '' >> "$1".c
		echo -e 'int main(int argc, char *argv[])' >> "$1".c
		echo -e '{' >> "$1".c
		echo -e '' >> "$1".c
		echo -e '' >> "$1".c
		echo -e '\treturn(0);' >> "$1".c
		echo -e '}' >> "$1".c
	else
		echo -e 'Usage:\n\tcreateC c_source_to_create'
	fi
}

function thermal(){
	for (( III=0; III<`ll -d /sys/devices/platform/coretemp.? | wc -l`; III++ ))
	do
		echo "---[THERMAL ZONE $III]--------------------------------------"
		cat /sys/class/thermal/thermal_zone"$III"/temp
		echo
		for (( JJJ=1; JJJ<=`ll /sys/devices/platform/coretemp.0/hwmon/hwmon0/temp?_label | wc -l`; JJJ++ ))
		do
			cat /sys/devices/platform/coretemp."$III"/hwmon/hwmon0/temp"$JJJ"_label
			cat /sys/devices/platform/coretemp."$III"/hwmon/hwmon0/temp"$JJJ"_input
			echo
		done
	done
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
