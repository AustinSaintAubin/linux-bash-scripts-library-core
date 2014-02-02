ScriptInfo_files_and_folder_functions() {
SCRIPT_NAME="Files & Folders Functions"; SCRIPT_VERSION="1.2"; SCRIPT_DATE="2014/02/01"; SCRIPT_AUTHER="Austin Saint Aubin"; SCRIPT_AUTHER_CONTACT="AustinSaintAubin@gmail.com"
SCRIPT_DESCRIPTION="Script Dependency, used to help with manipulating files & folders"
SCRIPT_TITLE="Dependency: $SCRIPT_NAME - v$SCRIPT_VERSION - $SCRIPT_DATE - $SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT) \n   ⊢ Description: $SCRIPT_DESCRIPTION"
echo -e " $(YEL "▶︎") $SCRIPT_TITLE"; }
# -------------------------------------------------------------------------------------------------
# Initialisation: sh "/../dependencies/files_and_folder_functions.sh" "SCRIPTS_DEPENDENCIES_DIRECTORY (Glodal)"
# General Usage: (See Functions)
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# Check if this script is already loaded
if [ -z $script_loaded_files_and_folder_functions ]; then
	# [# Global Static Variables #]
	SCRIPT_DIRECTORY="$(dirname $0)"  # This Script Sets Specific Directory (shows root most script directory, so if a script sources this script then this script will not output its directory... )
	SCRIPTS_DEPENDENCIES_DIRECTORY="$SCRIPT_DIRECTORY"  # All Scripts Gerneral Dependencies
	#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
	OS_VERSION=$(nvram get os_version)
	OS_VERSION_UNDERSCORED=$(nvram get os_version | sed -e 's/ /_/g')
	
	# [# Read Passed Varables #] --------------------------------------------------------------------------------------
	# Set Scripts Dependencies Directory (Glodal)
	echo -ne " ⊢ Scripts Dependencies Directory (Glodal)"
	if [ -z "$1" ]; then 
		echo "  [ NOT Passed ]"
	else
		echo "  [ Passed ]"
		SCRIPTS_DEPENDENCIES_DIRECTORY="$1"
	fi
	echo "   ⊢ Using: $SCRIPTS_DEPENDENCIES_DIRECTORY"
	
	# [# Included Libraries & Scripts #] --------------------------------------------------------------------------------------
	source "$SCRIPTS_DEPENDENCIES_DIRECTORY/color_text_functions.sh" # Include Color Functions
	#source "$SCRIPTS_DEPENDENCIES_DIRECTORY/color_text_functions-nocolor.sh"  # Include Non-Color Functions
	
	# [# Functions #] --------------------------------------------------------------------------------------
	checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }
	
	# [# Main #] --------------------------------------------------------------------------------------
	# Output Script Title
	ScriptInfo_files_and_folder_functions
	
	cleanupFolder() # cleanupFolder [DIR] [number_of_folders_to_keep] [filter]
	{
		BRK 5
		CYN "Purging Old Backups for $1/"
		YEL "Num of Backups to keep: $2"
		BRK 6
		
		if [ "$(ls -p "$1" 2> /dev/null | grep "/")" ]; then  # Check if Folder Exist
			# Set Counter Varbles
			folder_count=$(ls -p "$1" | grep "/" | wc -l)
			folder_count_index=$folder_count
			#BLK "$folder_count"
			
			# Process Filtered Items
			ls -1 -c -A -p -r "$1" | grep "/" | grep -v "$3" | while read folder; do
				BLK "$(printf "%03d" $folder_count_index): $folder   $(YEL "[ Filtered ]")"
				let folder_count_index--
			done
			
			# Set Counter Varbles (For Selected/Filtered Items)
			folder_count=$(ls -p "$1" | grep "/" | grep "$3" | wc -l)
			folder_count_index=$folder_count
			
			# Procccess items
			ls -1 -c -A -p -r "$1" | grep "/" | grep "$3" | while read folder; do
				#BLK "$(printf "%03d" $folder_count_index): $folder"
				if [ $folder_count -gt $2 ]; then
					RED "$(printf "%03d" $folder_count_index): $folder   ( $folder_count > $2 )  [ Deleting ]"
					rm -fr "$1/$folder"
					
					#folder_count=$(ls -p "$1" | grep "/" | wc -l);
					let folder_count--  # Decrement here to count only when folder removed.
				else
					BLK "$(printf "%03d" $folder_count_index): $folder"
				fi
				let folder_count_index--
			done
		else
			WRN "Directory: \"$1\" is empty. Check DIR to see if it is correct."
		fi
		BRK 6
	}
	
	cleanupFile() # cleanupFile [DIR] [number_of_files_to_keep] [filter]
	{
		BRK 5
		CYN "Purging Old Backups for $1/"
		YEL "Num of Backups to keep: $2"
		BRK 6
		
		if [ "$(ls -p "$1" 2> /dev/null | grep -v "/")" ]; then  # Check if File Exist
			# Set Counter Varbles
			file_count=$(ls -p "$1" | grep -v "/" | wc -l)
			file_count_index=$file_count
			#BLK "$file_count"
			
			# Process Filtered Items
			ls -1 -c -A -p -r "$1" | grep -v "/" | grep -v "$3" | while read file; do
				BLK "$(printf "%03d" $file_count_index): $file   $(YEL "[ Filtered ]")"
				let file_count_index--
			done
			
			# Set Counter Varbles (For Selected/Filtered Items)
			file_count=$(ls -p "$1" | grep -v "/" | grep "$3" | wc -l)
			file_count_index=$file_count
			
			# Procccess items
			ls -1 -c -A -p -r "$1" | grep -v "/" | grep "$3" | while read file; do
				#BLK "$(printf "%03d" $file_count_index): $file"
				if [ $file_count -gt $2 ]; then
					RED "$(printf "%03d" $file_count_index): $file   ( $file_count > $2 )  [ Deleting ]"
					rm -f "$1/$file"
					
					#file_count=$(ls -p "$1" | grep "/" | wc -l);
					let file_count--  # Decrement here to count only when file removed.
				else
					BLK "$(printf "%03d" $file_count_index): $file"
				fi
				let file_count_index--
			done
		else
			WRN "Directory: \"$1\" is empty. Check DIR to see if it is correct."
		fi
		BRK 6
	}

	# Set Script Initialize Variable
	script_loaded_files_and_folder_functions=true
fi