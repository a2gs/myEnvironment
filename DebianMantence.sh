#!/usr/bin/env bash

# Andre Augusto Giannotti Scota (https://sites.google.com/view/a2gs/)

# Script exit if a command fails:
#set -e

# Script exit if a referenced variable is not declared:
#set -u

# If one command in a pipeline fails, its exit code will be returned as the result of the whole pipeline:
#set -o pipefail

# Activate tracing:
#set -x

#trap "" SIGINT

if [ $(id -u) -ne 0 ]; then
    echo 'Run as root.' >&2
    exit 1
fi

# ---------------------------------------------

function getAppPath
{
	if [ -z "$1" ]
	then
		return 1
	fi

	retWhich=$(which "$1")
	if [ "$?" -ne 0 ]
	then
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application [$1] is mandatory!." >&2
		return 1
	fi

	[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application [$1] found as [$retWhich]" >&2

	echo "$retWhich"
	return 0
}

function deleteFile
{
	if [ -z "$1" ]
	then
		return 1
	fi

	RM_APP=`getAppPath 'rm'`
	if [ "$?" -eq 1 ]
	then
		"$DIALOG_APP"      \
			--title "ERROR" \
			--no-collapse   \
			--msgbox "Application rm doesnot exist!" 10 50
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application rm doesnot exist!" >&2
		exit 1
	fi

	if [ ! -f "$1" ] || [ -z "$1" ] || [ ! -n "$1" ]
	then
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "RM erro [$1] didnt delete." >&2
		exit 1
	fi

	"$RM_APP" -rf "$1"
	if [ "$?" -ne 0 ]
	then
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "RM erro [$1] couldnt delete." >&2
		exit 1
	fi

	[ "$DEBUG_MANTENCE" -eq 1 ] && echo "RM ok [$1] deleted." >&2
	return 0
}

DEBUG_MANTENCE=0

if [ $# -eq 1 ]
then
	if [ "$1" = "-DEBUG" ]
	then
		DEBUG_MANTENCE=1
	fi
fi

SAVE_CMD_OUTPUT=0 # TODO: pass by argv

function deleteCmdOutputFile
{
	if [ "$SAVE_CMD_OUTPUT" -eq 0 ]
	then
		deleteFile "$1"
	fi
}

function menu_network
{
	IP_APP=`getAppPath 'ip'`
	if [ "$?" -eq 1 ]
	then
		"$DIALOG_APP"      \
			--title "ERROR" \
			--no-collapse   \
			--msgbox "Application ip doesnot exist!" 10 50
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application ip doesnot exist!" >&2
			exit 1
	fi

	while true
	do

		menuNetTempFile=`"$MKTEMP_APP" -p /tmp`
		if [ "$?" -ne 0 ]
		then
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuNetTempFile]" >&2
			exit 1
		fi

		"$DIALOG_APP"                                  \
			--clear                                     \
			--cancel-label "Exit"                       \
			--title "Network Menu"                      \
			--backtitle "Debian-like mantence: Network" \
			--menu "Option:" 20 50 20                   \
			1 'List ifaces'                             \
			2 'Up/Down iface'                           \
			3 'List interface files'                    \
			4 'Show routes'                             \
			5 'ufw'                                     \
			2>$menuNetTempFile

		dialogRet=$?
		if [ "$dialogRet" -eq 1 ] || [ "$dialogRet" -eq 255 ]
		then
			deleteFile "$menuNetTempFile"
			break
		fi

		menu=`cat "$menuNetTempFile"`
		deleteFile "$menuNetTempFile"

		clear

		case $menu in
			1)
				ipaddTempFile=`"$MKTEMP_APP" -p /tmp`
				"$IP_APP" addr show > $ipaddTempFile
				"$DIALOG_APP" --no-collapse --textbox "$ipaddTempFile" 50 100
				deleteCmdOutputFile "$ipaddTempFile"
				;;
	
			2)
				true
				;;
	
			3)
				echo -e "[/etc/hostname]\n" > $cfgFilesTempFile
				cat /etc/hostname >> $cfgFilesTempFile
				echo -e "\n----------------------------------" >> $cfgFilesTempFile
	
				echo -e "[/etc/hosts]\n" >> $cfgFilesTempFile
				cat /etc/hosts >> $cfgFilesTempFile
				echo -e "\n----------------------------------" >> $cfgFilesTempFile
	
				echo -e "[/etc/networks]\n" >> $cfgFilesTempFile
				cat /etc/networks >> $cfgFilesTempFile
				echo -e "\n----------------------------------" >> $cfgFilesTempFile
	
				echo -e "[/etc/network/interfaces]\n" >> $cfgFilesTempFile
				cat /etc/network/interfaces >> $cfgFilesTempFile
	
				"$DIALOG_APP" --no-collapse --textbox "$cfgFilesTempFile" 50 100
	
				deleteCmdOutputFile "$cfgFilesTempFile"
				;;
	
			4)
				ipneighTempFile=`"$MKTEMP_APP" -p /tmp`
				echo "ROUTE TABLE:" > $ipneighTempFile
				"$IP_APP" route list >> $ipneighTempFile
	
				echo -e "\nMULTICAST:" >> $ipneighTempFile
				"$IP_APP" maddress show >> $ipneighTempFile
	
				echo -e "\nNEIGHBOUR:" >> $ipneighTempFile
				"$IP_APP" neigh show >> $ipneighTempFile
	
				"$DIALOG_APP" --no-collapse --textbox "$ipneighTempFile" 50 100
				deleteCmdOutputFile "$ipneighTempFile"
				;;
	
			5) true
				;;
	
			6) true
				;;
	
			*) echo "Unknow network menu option: $menu" >&2
				;;
		esac
	done
}

function menu_services
{
# systemctl list-unit-files --type service --state enabled,generated
# systemctl list-units --type service --state running
# systemctl list-units --type service --state failed
# systemctl list-units --type service --state 
	true
}

function menu_hd
{

	LSBLK_APP=`getAppPath 'lsblk'`
	if [ "$?" -eq 1 ]
	then
		"$DIALOG_APP"      \
			--title "ERROR" \
			--no-collapse   \
			--msgbox "Application lsblk doesnot exist!" 10 50
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application lsblk doesnot exist!" >&2
			exit 1
	fi

	menuHDTempFile=`"$MKTEMP_APP" -p /tmp`
	if [ "$?" -ne 0 ]
	then
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuHDTempFile]" >&2
		exit 1
	fi

	"$LSBLK_APP" -ampfz > $menuHDTempFile
	
	"$DIALOG_APP" --no-collapse --textbox "$menuHDTempFile" 20 100
	
	deleteCmdOutputFile "$menuHDTempFile"

	true
}

function menu_memory
{
	true
}

function menu_sekurity
{
#		# Set /etc/rkhunter.conf
#		#PKGMGR=DPKG
#		#UPDATE_MIRRORS=0 to UPDATE_MIRRORS=1
#		#MIRRORS_MODE=1 to MIRRORS_MODE=0
#		#WEB_CMD="/bin/false" to WEB_CMD=""

	while true
	do

		menuSekTempFile=`"$MKTEMP_APP" -p /tmp`
		if [ "$?" -ne 0 ]
		then
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuSekTempFile]" >&2
			exit 1
		fi

		"$DIALOG_APP"                                   \
			--clear                                      \
			--cancel-label "Exit"                        \
			--title "Sekurity Menu"                      \
			--backtitle "Debian-like mantence: Sekutiry" \
			--menu "Option:" 20 50 20                    \
			1 "Update and run clamscan"                  \
			2 "Update and run rkhunter"                  \
			3 "Update and run lynis"                     \
			4 "Run chkrootkit"                           \
			2>$menuSekTempFile

		dialogRet=$?
		if [ "$dialogRet" -eq 1 ] || [ "$dialogRet" -eq 255 ]
		then
			deleteFile "$menuSekTempFile"
			break
		fi

		menu=`cat "$menuSekTempFile"`
		deleteFile "$menuSekTempFile"

		clear

		case $menu in
			1)
				FRESHCLAM_APP=`getAppPath 'freshclam'`
				if [ "$?" -eq 1 ]
				then
					"$DIALOG_APP"      \
						--title "ERROR" \
						--no-collapse   \
						--msgbox "Application freshclam doesnot exist!" 10 50
					[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application freshclam doesnot exist!" >&2
					continue
				fi

				CLAMSCAN_APP=`getAppPath 'clamscan'`
				if [ "$?" -eq 1 ]
				then
					"$DIALOG_APP"      \
						--title "ERROR" \
						--no-collapse   \
						--msgbox "Application clamscan doesnot exist!" 10 50
					[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application clamscan doesnot exist!" >&2
					continue
				fi

				"$FRESHCLAM_APP"
				"$CLAMSCAN_APP" -r -i /

				echo 'Pause. Press [ENTER].'; read
				;;

			2)
				RKHUNTER_APP=`getAppPath 'rkhunter'`
				if [ "$?" -eq 1 ]
				then
					"$DIALOG_APP"      \
						--title "ERROR" \
						--no-collapse   \
						--msgbox "Application rkhunter doesnot exist!" 10 50
					[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application rkhunter doesnot exist!" >&2
					continue
				fi

				"$RKHUNTER_APP" --update
				"$RKHUNTER_APP" -c --sk

				echo 'Pause. Press [ENTER].'; read
				;;

			3)
				LYNIS_APP=`getAppPath 'lynis'`
				if [ "$?" -eq 1 ]
				then
					"$DIALOG_APP"      \
						--title "ERROR" \
						--no-collapse   \
						--msgbox "Application lynis doesnot exist!" 10 50
					[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application lynis doesnot exist!" >&2
					continue
				fi

				"$LYNIS_APP" update info
				"$LYNIS_APP" audit system

				echo 'Pause. Press [ENTER].'; read
				;;

			4)
				CHKROOTKIT_APP=`getAppPath 'chkrootkit'`
				if [ "$?" -eq 1 ]
				then
					"$DIALOG_APP"      \
						--title "ERROR" \
						--no-collapse   \
						--msgbox "Application chkrootkit doesnot exist!" 10 50
					[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application chkrootkit doesnot exist!" >&2
					break
				fi

				"$CHKROOTKIT_APP"

				echo 'Pause. Press [ENTER].'; read
				;;

			*)
				echo "Unknow sekurity option: $menu" >&2
				;;
		esac
	done
}

function menu_packages
{
	APTGET_APP=`getAppPath 'apt'`
	if [ "$?" -eq 1 ]
	then
		"$DIALOG_APP"      \
			--title "ERROR" \
			--no-collapse   \
			--msgbox "Application apt doesnot exist!" 10 50
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application apt lsblk doesnot exist!" >&2
			break
	fi

	while true
	do
		menuPackTempFile=`"$MKTEMP_APP" -p /tmp`
		if [ "$?" -ne 0 ]
		then
			[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuPackTempFile]" >&2
			exit 1
		fi

		"$DIALOG_APP"                                   \
			--clear                                      \
			--title "Packages Menu"                      \
			--backtitle "Debian-like mantence: Packages" \
			--cancel-label "Exit"                        \
			--menu "Option:" 20 50 20                    \
			1 'Update'                                   \
			2 'Simulate'                                 \
			3 'Upgrade'                                  \
			4 'Distro upgrade'                           \
			6 'Release info'                             \
			7 'Remove, purge and clean'                  \
			8 'List/search installed'                    \
			9 'Search'                                   \
			2>$menuPackTempFile

		dialogRet=$?
		if [ "$dialogRet" -eq 1 ] || [ "$dialogRet" -eq 255 ]
		then
			deleteFile "$menuPackTempFile"
			break
		fi
	
		menu=`cat "$menuPackTempFile"`
		deleteFile "$menuPackTempFile"

		clear
	
		case $menu in
			1)
				"$APTGET_APP" -y update
				if [ "$?" -ne 0 ]
				then
					echo "apt-get update error."
					exit 1
				fi
				;;
	
			2)
				"$APTGET_APP" --simulate upgrade
				echo 'Pause. Press [ENTER].'; read
				;;
	
			3)
				"$APTGET_APP" -y upgrade
				if [ "$?" -ne 0 ]
				then
					echo "apt-get upgrade error."
					exit 1
				fi
				;;
	
			4)
				"$APTGET_APP" -y dist-upgrade
				if [ "$?" -ne 0 ]
				then
					echo "apt-get dist-upgrade error."
					exit 1
				fi
				;;
	
			5)
				true
				;;
	
			6)
				"$APTGET_APP" -y autoremove
				"$APTGET_APP" -y autoclean
				"$APTGET_APP" -y clean
				"$APTGET_APP" -y purge
				"$APTGET_APP" -y check
				;;
	
			7)
				true
				;;

			8)
				true
				;;

			9)
				true
				;;

			*) echo "Unknow package option: $menu" >&2
				;;
	
		esac
	done
}

# ---------------------------------------------

MKTEMP_APP=`getAppPath 'mktemp'`
if [ "$?" -eq 1 ]
then
	"$DIALOG_APP"      \
		--title "ERROR" \
		--no-collapse   \
		--msgbox "Application mktemp doesnot exist!" 10 50
	[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application mktemp doesnot exist!" >&2
	exit 1
fi

DIALOG_APP=`getAppPath 'dialog'`
if [ "$?" -eq 1 ]
then
	echo "Application dialog doesnot exist!" >&2
	exit 1
fi

while true
do
	menuTempFile=`"$MKTEMP_APP" -p /tmp`
	if [ "$?" -ne 0 ]
	then
		[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuTempFile]" >&2
		exit 1
	fi

	"$DIALOG_APP"                         \
		--clear                            \
		--title "Main Menu"                \
		--backtitle "Debian-like mantence" \
		--cancel-label "Exit"              \
		--menu "Option:"                   \
		20 50 20                           \
		1 'Network'                        \
		2 'HD'                             \
		3 'Memory'                         \
		4 'Packages'                       \
		5 'Services'                       \
		6 'LKM'                            \
		7 'Sekurity'                       \
		9 'System info'                    \
		t 'top'                            \
		m 'mc'                             \
		d 'dmesg'                          \
		2>$menuTempFile

	dialogRet=$?
	if [ "$dialogRet" -eq 1 ] || [ "$dialogRet" -eq 255 ]
	then
		deleteFile "$menuTempFile"
		break
	fi

	menu=`cat "$menuTempFile"`
	deleteFile "$menuTempFile"

	clear

	case $menu in
		1)
			menu_network
			;;

		2)
			menu_hd
			;;

		3)
			menu_memory
			;;

		4)
			menu_packages
			;;

		5)
			menu_services
			;;

		6)
			true
			;;

		7)
			menu_sekurity 
			;;

		9)
			menuGetInfoTemFile=`"$MKTEMP_APP" -p /tmp`
			if [ "$?" -ne 0 ]
			then
				[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Cannot create [$menuGetInfoTemFile]" >&2
				exit 1
			fi

			echo -e "OPERATION SYSTEM:" > $menuGetInfoTemFile
			uname -a >> $menuGetInfoTemFile
	
			cat /etc/debian_version >> $menuGetInfoTemFile
			lsb_release -a >> $menuGetInfoTemFile
	
			echo -e "\n\nHARDWARE:" >> $menuGetInfoTemFile
	
			echo '=== [ biosdecode ] ==============================================================================' >> $menuGetInfoTemFile
			biosdecode >> $menuGetInfoTemFile
			echo '=== [ dmidecode ] ===============================================================================' >> $menuGetInfoTemFile
			dmidecode >> $menuGetInfoTemFile
			echo '=== [ lspci ] ===================================================================================' >> $menuGetInfoTemFile
			lspci >> $menuGetInfoTemFile
			echo '=== [ /proc/cpuinfo ] ===========================================================================' >> $menuGetInfoTemFile
			cat /proc/cpuinfo >> $menuGetInfoTemFile
			echo '=== [ lsblk ] ===================================================================================' >> $menuGetInfoTemFile
			lsblk --output-all --all >> $menuGetInfoTemFile
			echo '=== [ lspci ] ===================================================================================' >> $menuGetInfoTemFile
			lspci -vv >> $menuGetInfoTemFile
			echo '=== [ lshw ] ====================================================================================' >> $menuGetInfoTemFile
			lshw -numeric  >> $menuGetInfoTemFile

			"$DIALOG_APP" --no-collapse --textbox "$menuGetInfoTemFile" 50 100

			deleteCmdOutputFile "$menuGetInfoTemFile"
			;;

		t)
			top
			;;

		m)
			mc
			;;

		d)
			dmesgOutputTempFile=`"$MKTEMP_APP" -p /tmp`
			if [ ! -f "$dmesgOutputTempFile" ]
			then
				[ "$DEBUG_MANTENCE" -eq 1 ] && echo "$dmesgOutputTempFile error." >&2
				exit 1
			fi

			DMESG_APP=`getAppPath 'dmesg'`
			if [ "$?" -eq 1 ]
			then
				"$DIALOG_APP"             \
					--title "ERROR" \
					--no-collapse   \
					--msgbox "Application dmesg doesnot exist!" 10 50
				[ "$DEBUG_MANTENCE" -eq 1 ] && echo "Application dmesg doesnot exist!" >&2
				deleteCmdOutputFile "$dmesgOutputTempFile"
				exit 1
			fi

			"$DMESG_APP" -P > $dmesgOutputTempFile
			if [ "$?" -ne "0" ]
			then
				[ "$DEBUG_MANTENCE" -eq 1 ] && echo "dmesg return error." >&2
				deleteCmdOutputFile "$dmesgOutputTempFile"
				exit 1
			fi

			"$DIALOG_APP" --no-collapse --textbox "$dmesgOutputTempFile" 50 100

			deleteCmdOutputFile "$dmesgOutputTempFile"
			;;

		*)
			echo "Unknow main menu option: $menu" >&2
			;;
	esac

done

clear
exit 0
