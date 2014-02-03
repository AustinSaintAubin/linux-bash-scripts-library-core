ScriptInfo_backup_router() {
SCRIPT_NAME="Tomato Router Backup Script"; SCRIPT_VERSION="2.6"; SCRIPT_DATE="2014/02/02"; SCRIPT_AUTHER="Austin Saint Aubin"; SCRIPT_AUTHER_CONTACT="AustinSaintAubin@gmail.com"
SCRIPT_DESCRIPTION="Selctively backup everything on your tomato router"
SCRIPT_TITLE="$SCRIPT_NAME - v$SCRIPT_VERSION - $SCRIPT_DATE - $SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT) \n   ∟ Description: $SCRIPT_DESCRIPTION"
echo -e " $(YEL "▶︎") $SCRIPT_TITLE"; }
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/mnt/usb8gb/active_system/scripts/backup/backup_router_tomato.sh"
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# [# Global Static Variables #]
SCRIPT_FILENAME="$(basename $0)"
SCRIPT_DIRECTORY="$(dirname $0)"
SCRIPT_DEPENDENCIES_DIRECTORY="$SCRIPT_DIRECTORY/dependencies"  # This Scripts Specific Dependencies
#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
SCRIPTS_DIRECTORY="$(dirname "$SCRIPT_DIRECTORY")"  # Scripts Root Directory
SCRIPTS_DEPENDENCIES_DIRECTORY="$SCRIPTS_DIRECTORY/dependencies"  # All Scripts Gerneral Dependencies
#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
OS_VERSION=$(nvram get os_version)
OS_VERSION_UNDERSCORED=$(nvram get os_version | sed -e 's/ /_/g')

# [# Passed Variables Defaults #]
main_backup_destination_directory_name_prefix="tomato_router_backup"
main_backup_destination_directory_root="$(dirname "$(dirname "$SCRIPTS_DIRECTORY")")/backups"
main_backup_destination_directory_path="$main_backup_destination_directory_root/$main_backup_destination_directory_name_prefix"_"$(date +%Y-%m-%d_%H%M%S)"_"($OS_VERSION_UNDERSCORED)" # _$(date +%Y-%m-%d_%H%M%S)_($OS_VERSION_UNDERSCORED)"
main_backup_retention_number=30  # Number of backups to keep
main_backup_note="$OS_VERSION_UNDERSCORED"
main_backup_type="2"  # Backup Type ( limited(1)|default(2)|full(3) )

echo "[# Loading Dependencies & Source Scripts #]" # --------------------------------------------------------------------------------------
source "$SCRIPTS_DEPENDENCIES_DIRECTORY/color_text_functions.sh"  # Include Color Functions
#source "$SCRIPTS_DEPENDENCIES_DIRECTORY/color_text_functions.sh" disabled  # Include Color Functions (Disabled)
#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_file_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup Files Dependency
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_folder_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup Folders Dependency
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_folder_archive_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup Folders Dependency
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_nvram_encapsulated_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup NVRam Encapsulated Dependency
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_nvram_raw_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup NVRam RAW Dependency
source "$SCRIPT_DEPENDENCIES_DIRECTORY/backup_sysinfo_functions.sh" "$SCRIPTS_DEPENDENCIES_DIRECTORY" "$SCRIPT_DEPENDENCIES_DIRECTORY"  # Include Backup NVRam RAW Dependency

# [# Functions #] --------------------------------------------------------------------------------------

WHT "[# Running Main #]" # --------------------------------------------------------------------------------------
# Output Script Title
ScriptInfo_backup_router

# [# Read Passed Varables #] --------------------------------------------------------------------------------------
# Set Scripts Dependencies Directory (Glodal)
echo -ne " ∟ Backup Type (default|limited|full)"
if [ -z "$1" ]; then 
	echo "  [ NOT Passed ]"
else
	echo "  [ Passed ]"
	case $1 in  # Proccess Passed Input
		limit|Limit|LIMIT|limited|Limited|LIMITED|1) # Limited Backup
			main_backup_type=1;;
		full|Full|FULL|3)  # Full Backup
			main_backup_type=3;;
		*) # catch all (default)
			main_backup_type=2;;
	esac
fi
echo -ne "   ∟ Using: ($main_backup_type) = "
case $main_backup_type in
	1)  # Limited Backup
		MAG "Limited Backup";;
	2) # Standard (Default) Backup
		GRN "Standard (Default) Backup";;
	3) # Full Backup
		RED "Full Backup";;
	*) # catch all
		WRN "ERROR";;
esac


WHT "[# Running Backups #]" # --------------------------------------------------------------------------------------
# Output Script Title
ScriptInfo_backup_router

# Purge/Cleanup Old Backups
cleanupFolder "$main_backup_destination_directory_root" $main_backup_retention_number ".*$main_backup_destination_directory_name_prefix.*$main_backup_destination_directory_name_suffix"

WHT "[# Starting Backups #]" # --------------------------------------------------------------------------------------
backupSysinfo "Backup System Information" "$main_backup_destination_directory_path" "sysinfo_" "$main_backup_note" ".txt" "$main_backup_retention_number"

# Limited (just the basics) Backup
# This part of the backup will run no matter what
backupNVRamRAW "NVRam RAW Configuration" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_raw_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number"

# Standard (Default) Backup
if [ $main_backup_type -ge 2 ]; then
	backupNVRamEcapsulated "NVRam (Encapsulated)" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_encapsulated_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number" "" ""
	backupNVRamEcapsulated "NVRam (Encapsulated) Filtered" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_encapsulated_filtered_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number" "NC|clkfreq|ddnsx|dhcpd|ftp|http|lan_hostname|lan_ipaddr|lan_netmask|lan_proto|log|ntp|qos|rstats|sch|script|sesx|smbd|snmp|sshd|telnetd|tm|usb|vpn_server_|vpn_server1|wan_dns|wan_hostname|web|wl0_" ""
	
	backupFile "System Log" "/tmp/var/log/messages" "$main_backup_destination_directory_path" "syslog_" "$main_backup_note" ".log" "$main_backup_retention_number"
	backupFile "Web Usage Domains" "/proc/webmon_recent_domains" "$main_backup_destination_directory_path" "webmon_recent_domains_" "$main_backup_note" ".txt" "$main_backup_retention_number"
	backupFile "Web Usage Searches" "/proc/webmon_recent_searches" "$main_backup_destination_directory_path" "webmon_recent_searches_" "$main_backup_note" ".txt" "$main_backup_retention_number"
	backupFolder "Scripts Backup (Temp)" "/tmp/*.sh" "" "$main_backup_destination_directory_path" "scripts_backups_tmp_" "" "" "$main_backup_retention_number"
fi

# Full Backup
if [ $main_backup_type -ge 3 ]; then
	backupFolder "Active System Backup" "-r" "$(dirname "$(dirname "$SCRIPT_DIRECTORY")")/" "$main_backup_destination_directory_path" "active_system_backup_" "" "" "$main_backup_retention_number"

	backupArchive "Optware" "/opt" "$main_backup_destination_directory_path" "optware_" "$main_backup_note" "" "$main_backup_retention_number"
	### To Extract the Optware Archive:		http://www.dd-wrt.com/wiki/index.php/Optware#.2Fopt_backup
	# cd /; tar xvzf "$(nvram get usb_disk_main)/Tomato/Optware-Archive/Optware_2011-05-01_181510.tar.gz"
fi