ScriptInfo_backup_router() {
SCRIPT_NAME="Tomato Router Backup Script"; SCRIPT_VERSION="2.2"; SCRIPT_DATE="2014/02/02"; SCRIPT_AUTHER="Austin Saint Aubin"; SCRIPT_AUTHER_CONTACT="AustinSaintAubin@gmail.com"
SCRIPT_DESCRIPTION="Selctively backup everything on your tomato router"
SCRIPT_TITLE="$SCRIPT_NAME - v$SCRIPT_VERSION - $SCRIPT_DATE - $SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT) \n   ⊢ Description: $SCRIPT_DESCRIPTION"
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
main_backup_destination_directory_root="$(dirname "$SCRIPTS_DIRECTORY")/backups"
main_backup_destination_directory_path="$main_backup_destination_directory_root/$main_backup_destination_directory_name_prefix"_"$(date +%Y-%m-%d_%H%M%S)"_"($OS_VERSION_UNDERSCORED)" # _$(date +%Y-%m-%d_%H%M%S)_($OS_VERSION_UNDERSCORED)"
main_backup_retention_number=30  # Number of backups to keep
main_backup_note="$OS_VERSION_UNDERSCORED"

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

# [# Read Passed Varables #] --------------------------------------------------------------------------------------

WHT "[# Running Main #]" # --------------------------------------------------------------------------------------
# Output Script Title
ScriptInfo_backup_router

# Purge/Cleanup Old Backups
cleanupFolder "$main_backup_destination_directory_root" $main_backup_retention_number ".*$main_backup_destination_directory_name_prefix.*$main_backup_destination_directory_name_suffix"

WHT "[# Starting Backups #]" # --------------------------------------------------------------------------------------
backupSysinfo "Backup System Information" "$main_backup_destination_directory_path" "sysinfo_" "$main_backup_note" ".txt" "$main_backup_retention_number"

backupNVRamRAW "NVRam RAW Configuration" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_raw_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number"
backupNVRamEcapsulated "NVRam (Encapsulated)" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_encapsulated_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number" "" ""
backupNVRamEcapsulated "NVRam (Encapsulated) Filtered" "$main_backup_destination_directory_path/NVRam" "tomato_nvram_encapsulated_filtered_" "$main_backup_note" "_sufix.cfg" "$main_backup_retention_number" "NC|clkfreq|ddnsx|dhcpd|ftp|http|lan_hostname|lan_ipaddr|lan_netmask|lan_proto|log|ntp|qos|rstats|sch|script|sesx|smbd|snmp|sshd|telnetd|tm|usb|vpn_server_|vpn_server1|wan_dns|wan_hostname|web|wl0_" ""

backupFile "System Log" "/tmp/var/log/messages" "$main_backup_destination_directory_path" "syslog_" "$main_backup_note" ".log" "$main_backup_retention_number"
backupFile "Web Usage Domains" "/proc/webmon_recent_domains" "$main_backup_destination_directory_path" "webmon_recent_domains_" "$main_backup_note" ".txt" "$main_backup_retention_number"
backupFile "Web Usage Searches" "/proc/webmon_recent_searches" "$main_backup_destination_directory_path" "webmon_recent_searches_" "$main_backup_note" ".txt" "$main_backup_retention_number"
backupFolder "Scripts Backup (Temp)" "/tmp/*.sh" "" "$main_backup_destination_directory_path" "scripts_backups_tmp_" "" "" "$main_backup_retention_number"

SCRIPTS_DIRECTORY="$(dirname "$SCRIPT_DIRECTORY")"  # Scripts Root Directory
backupFolder "Scripts Backup" "-r" "$SCRIPTS_DIRECTORY/" "$main_backup_destination_directory_path" "scripts_backups_" "" "" "$main_backup_retention_number"

backupArchive "Optware" "/opt" "$main_backup_destination_directory_path" "optware_" "$main_backup_note" "" "$main_backup_retention_number"

# if [ "Sun" == "$(date +%a)" ] && [ "1" == "$(date +%H)" ] ; then
# 	BLK "Today is: $(date +%a) at 1:xx"
# 	backThisUp "Archive Optware" ark "czf" "/opt" "$BackupsLocation/Optware-Archive" "Optware" "tar.gz" 8
# 	### To Extract the Optware Archive:		http://www.dd-wrt.com/wiki/index.php/Optware#.2Fopt_backup
# 	# cd /; tar xvzf "$(nvram get usb_disk_main)/Tomato/Optware-Archive/Optware_2011-05-01_181510.tar.gz"
# else
# 	say "Today is ($(date +%a) at $(date +%H):xx) NOT: (Sun at 1:xx), waiting untell then to backing up Optware."
# fi

# ==============================================================









# backThisUp "Router Configuration" nvram backup "$BackupsLocation/Configurations" "tomato_($OS_VERSION_UNDERSCORED)" cfg $NumOfBackupsToKeep
# ## backThisUp "System Log" sh "cat /tmp/var/log/messages" "$BackupsLocation/SysLogs" "syslog" txt $NumOfBackupsToKeep
# backThisUp "System Log" cp file "/tmp/var/log/messages" "$BackupsLocation/SysLogs" "syslog" txt $NumOfBackupsToKeep
# backThisUp SysInfo sh "sysinfo" "$BackupsLocation/SysInfo" "sysInfo" txt $NumOfBackupsToKeep
# backThisUp "NVRam Full List (Show-Raw)" nvram show "$BackupsLocation/NVRam/Show-Raw" "NVRam_($OS_VERSION_UNDERSCORED)" txt $NumOfBackupsToKeep
# backThisUp "NVRam Full List (Quote)" nvram quote "$BackupsLocation/NVRam/Quote" "NVRam_($OS_VERSION_UNDERSCORED)" txt $NumOfBackupsToKeep
# backThisUp "NVRam Full List (Quote Filtered)" nvram quote "$BackupsLocation/NVRam/Quote Filtered - Cross Importable" "NVRam_($OS_VERSION_UNDERSCORED)" txt $NumOfBackupsToKeep "NC|clkfreq|ddnsx|dhcpd|ftp|http|lan_hostname|lan_ipaddr|lan_netmask|lan_proto|log|ntp|qos|rstats|sch|script|sesx|smbd|snmp|sshd|telnetd|tm|usb|vpn_server_|vpn_server1|wan_dns|wan_hostname|web|wl0_" "Remove-NOTHING"
# backThisUp "NVRam Full List (Set)" nvram set "$BackupsLocation/NVRam/Set" "NVRam_($OS_VERSION_UNDERSCORED)" txt $NumOfBackupsToKeep
# backThisUp "Web Domains" cp file "/proc/webmon_recent_searches" "$BackupsLocation/WebUsage/Domains" WebDomains txt $NumOfBackupsToKeep
# backThisUp "Web Searches" cp file "/proc/webmon_recent_searches" "$BackupsLocation/WebUsage/Searches" WebSearches txt $NumOfBackupsToKeep
# backThisUp "Scripts Backup" cp folder "/tmp/*.sh" "$BackupsLocation/Scripts-Backup" "Tomato-Scripts" $NumOfBackupsToKeep