# Synology OpenERP 7.x Database Backup Script - 2013/11/25 - v1.0.1 - Written By: Austin Saint Aubin
# Description: Backup OpenERP 7.x PostgreSQL Database to a Backup Directory.
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/system_scripts/backup/backup_openerp.sh" "/volume1/Archives/OpenERP Backups/$OpenERP" "64"
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
#   One Liner: /usr/syno/pgsql/bin/pg_dump OpenERP -Fp -U admin -h localhost -p 5432 > "/volume1/Acquired Downloads and Uploads/dbbackup2"
#   PostgreSQL Interactive Terminal: /usr/syno/pgsql/bin/psql OpenERP -Fp -U admin -h localhost -p 5432
# =================================================================================================
# [# Global Variables #]
database_name="OpenERP"  # Database to be backed-up, OPENERP7 is default
database_user="admin"
database_host_address="localhost"
database_host_port="5432"
# - - - - - - - - - - - - - - - - -
backups_directory="/volume1/Archives/OpenERP Backups/$database_name"
backup_prefix="$database_name"
backup_name="$backup_prefix""_""$(date +%Y-%m-%d_%H%M%S).dump"
backup_log_name="$backup_name.txt"
number_of_backups_to_keep=256  # Multiply the number of backups you want by 2, the logs count as a backup
# =================================

# [# Included Library's & Scripts #]
#source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions
source "/volume1/active_system/system_scripts/dependencies/color_text_functions-nocolor.sh"  # Include Color Functions

# [# Functions #]
checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }
cleanupFiles() # [DIR] [number_of_folders_to_keep] [filter]   # cleanupFiles "$backups_directory" $number_of_backups_to_keep "^$backup_prefix"
{
	BRK 4
	CYN "Purging Old Backups for $1/"
	YEL "Num of Backups to keep: $2"	
	BRK 5
	
	if [ "$(ls -p "$1" | grep -v "/")" ]; then  # Check if Folders Exist
		NumOFiles=$(ls -p "$1" | grep -v "/" | grep "$backup_prefix" | wc -l);
		i=$NumOFiles
		
		ls -1 -c -A -p -r "$1" | grep -v "/" | grep "$backup_prefix" | while read files
		do
			#BLK "$(printf "%03d" $i): $files"
			if [ $NumOFiles -gt $2 ]; then
				if [ "$(echo "$files" | grep "$3")" ]; then
					RED "$(printf "%03d" $i): $files   [ $NumOFiles > $2 ] Deleting"
					rm -f -r "$1/$files"
					
					#NumOFiles=$(ls -p "$1" | grep "/" | wc -l);
					let NumOFiles--  # Decrement here to count only when file removed.
				else
					YEL "$(printf "%03d" $i): $files   Filtered Directory"
					let NumOFiles--  # Decrement here to count when file is also in filter group.
				fi
			else
				BLK "$(printf "%03d" $i): $files"
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

# Set Database to Backup if data is passed to script
# if [ -z "$3" ]; then 
# 	YEL "No Database Name Passed"
# 	BLU "Using Database Name in Script: $(WHT "$backups_directory")"
# else
# 	database_name="$3"
# fi

# Purge/Cleanup Old Backups
cleanupFiles "$backups_directory" $number_of_backups_to_keep "^$backup_prefix"

# Create Backup Folder for This Backup
checkFolder "$backups_directory"

# Create System Information File for Backup
date >> "$backups_directory/$backup_log_name"
uname -a >> "$backups_directory/$backup_log_name"
uptime >> "$backups_directory/$backup_log_name"

# =======================================================
# Check if PostgreSQL Dump Exist in "pg_dump_location"
BRK 4
pg_dump_location="/usr/syno/pgsql/bin/pg_dump"

if [ -n "$(which pg_dump)" ]; then  # Check if we can use something from the Optware Package, if not fall back to something basic.
	WHT "Found pg_dump (Used to make PostgreSQL backup), it is installed and has environment path"
elif [ -f "$pg_dump_location" ]; then
	WHT "Found pg_dump (Used to make PostgreSQL backup): $pg_dump_location"
else
	config_file="$backups_directory/Archives/configfiles.txt"
	YEL "Did NOT find pg_dump (Used to make PostgreSQL backup), looked in: $pg_dump_location"
	quit
fi


BRK 4
# Run Backup Command
destination_file_path="$backups_directory/$backup_name"
checkFolder "$(dirname "$destination_file_path")"

BLK "Source Database: $database_name"
BLK "Destination: $destination_file_path"
WHT "Starting Backup"

if [ -n "$(which pg_dump)" ]; then  # Check if we can use something from the Optware Package, if not fall back to something basic.
	pg_dump "$database_name" -Fp -U "$database_user" -h "$database_host_address" -p "$database_host_port" > "$destination_file_path"
else
	"$pg_dump_location" "$database_name" -Fp -U "$database_user" -h "$database_host_address" -p "$database_host_port" > "$destination_file_path"
fi

