# Synology Configurations Backup Script - 2013/04/26 - v1.0.0 - Written By: Austin Saint Aubin
# Description: Backup Config File Editors Config File and linked files to a Backup Directory
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/system_scripts/backup/backup_configurations.sh" "/volume1/Projects Resources/Synology NAS/Backups/Config Files" 128
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# [# Global Variables #]
config_file="/volume1/@appstore/Config File Editor/CFE/configfiles.txt"
backups_directory="/volume1/Archives/System Configuration Files"
backup_prefix="Config Files"
backup_name="$backup_prefix - $(date +%Y-%m-%d_%H%M%S)"
number_of_backups_to_keep=128

# [# Included Library's & Scripts #]
#source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions
source "/volume1/active_system/system_scripts/dependencies/color_text_functions-nocolor.sh"  # Include Color Functions

# [# Functions #]
checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }
cleanupDir() # cleanupDir [DIR] [number_of_folders_to_keep] [filter]
{
	BRK 4
	CYN "Purging Old Backups for $1/"
	YEL "Num of Backups to keep: $2"	
	BRK 5
	
	if [ "$(ls -p "$1" | grep "/")" ]; then  # Check if Folders Exist
		NumOFiles=$(ls -p "$1" | grep "/" | grep "$backup_prefix" | wc -l);
		i=$NumOFiles
		
		ls -1 -c -A -p -r "$1" | grep "/" | grep "$backup_prefix" | while read folders
		do
			#BLK "$(printf "%03d" $i): $folders"
			if [ $NumOFiles -gt $2 ]; then
				if [ "$(echo "$folders" | grep "$3")" ]; then
					RED "$(printf "%03d" $i): $folders   [ $NumOFiles > $2 ] Deleting"
					rm -f -r "$1/$folders"
					
					#NumOFiles=$(ls -p "$1" | grep "/" | wc -l);
					let NumOFiles--  # Decrement here to count only when file removed.
				else
					YEL "$(printf "%03d" $i): $folders   Filtered Directory"
					let NumOFiles--  # Decrement here to count when file is also in filter group.
				fi
			else
				BLK "$(printf "%03d" $i): $folders"
			fi
			let i--
		done
	else
		WRN "Folder: \"$1\" is empty. Check DIR to see if it is correct."
	fi
	BRK 5
}

# [# Main #] --------------------------------------------------------------------------------------
# Set Backup Location
if [ -z "$1" ]; then 
	YEL "No Backup Path Passed"
	BLU "Using Backup Directory in Script: $(WHT "$backups_directory")"
else
	backups_directory="$1"
fi

# Set Number of Backups to Keep
if [ -z "$2" ]; then 
	YEL "No Number of Backups to Keep"
	BLU "Using Number of Backups to Keep in Script: $(WHT "$number_of_backups_to_keep")"
else
	number_of_backups_to_keep="$2"
fi

# Purge/Cleanup Old Backups
cleanupDir "$backups_directory" $number_of_backups_to_keep "^$backup_prefix"

# Create Backup Folder for This Backup
checkFolder "$backups_directory/$backup_name"

# Create System Information File for Backup
date >> "$backups_directory/$backup_name/Info.txt"
uname -a >> "$backups_directory/$backup_name/Info.txt"
uptime >> "$backups_directory/$backup_name/Info.txt"

# Check if Config File Editors Config File exist, if not use one in Backup Directory in Archive folder
BRK 4
if [ -f "$config_file" ]; then
	WHT "Found Config File Editors Config File: $config_file"
else
	config_file="$backups_directory/Archives/configfiles.txt"
	YEL "Did NOT find Config File Editors Config File, using one in: $config_file"
fi

# Copy Config File Editor Config File to Backup Directory
if [ -n "$(which pv)" ]; then  # Check if we can use something from the Optware Package, if not fall back to something basic.
	pv "$config_file" > "$backups_directory/$backup_name/$(basename "$config_file")"
else
	cp "$config_file" "$backups_directory/$backup_name/$(basename "$config_file")"
fi

# Copy Config File Editors Files inked to Config File to Backup Directory
BRK 4
cat "$config_file" | while read line; do
	YEL "Got Line: $line"
	if [ "${line:0:1}" != '#' ] && [ "$line" != "" ]; then
		#echo 'nope'
		source_file_path="$(echo "$line" | cut -d"," -f1)"
		destination_file_path="$backups_directory/$backup_name$source_file_path"
		checkFolder "$(dirname "$destination_file_path")"
		
		BLK "Source: $source_file_path"
		BLK "Destination: $destination_file_path"
		
		if [ -n "$(which pv)" ]; then  # Check if we can use something from the Optware Package, if not fall back to something basic.
			pv "$source_file_path" > "$destination_file_path"
		else
			cp "$source_file_path" "$destination_file_path"
		fi
	fi
done



