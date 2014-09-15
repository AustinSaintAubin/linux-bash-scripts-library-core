script_title="Synology AD Domain Homefolder Premisions Repair - 2014/07/28 - v1.0.1 - Written By: Austin Saint Aubin"
script_description=" ∟ Description: "
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/scripts/synology_ad_domain_users_homefolder_permissions_repair.sh"
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# [# Global Variables #]
FORCE_PERMISSIONS_UPDATE=false
domain_name="EAGLES"
working_directory="/volume1/homes/@DH-EAGLES/0"

# [# Included Library's & Scripts #]
source "/volume1/active_system/scripts/dependencies/color_text_functions.sh" # Include Color Functions
#source "/volume1/active_system/scripts/dependencies/color_text_functions-nocolor.sh"  # Include Color Functions

# [# Functions #]
checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }

# [# Output Header #] --------------------------------------------------------------------------------------
BRK 1
WHT "$script_title"
WHT "$script_description"
BRK 1

# Make current directory the working directory
cd "$working_directory"
WHT "Working in: $working_directory"
BRK 4

# Read though directories in home repository
ls -d * -1 | grep -v "@eaDir" | while read folder
do
	# Current Folder Varables
	username="$(echo "$folder" | cut -d "-" -f 1)"
	user_home_dir="$(synouser --get "$domain_name\\$username" | grep "User Dir" | cut -d "[" -f2 | cut -d "]" -f1)"
	user_home_folder="$(basename "$user_home_dir")"
	
	folder_access="$(stat "$folder" | grep "Access: (" )"
	folder_owner_username="$(echo "$folder_access" | cut -d ':' -f3 | cut -d '(' -f2 | cut -d ')' -f1 | cut -d '\' -f2 )"
	
	# Test if file has owner in Synology Users
	if [ "$user_home_folder" == "$folder" ]; then
		if [ $FORCE_PERMISSIONS_UPDATE == false ] && [ "$username" == "$folder_owner_username" ]; then
			GRN "$folder $(YEL ":") $domain_name/$username $(YEL ":") $user_home_dir"
			echo " ∟ $folder_access"
		else
			# Get Username ID & Group ID
			user_uid="$(synouser --get "$domain_name\\$username" | grep "User uid" | cut -d "[" -f2 | cut -d "]" -f1)"
			user_gid="$(synouser --get "$domain_name\\$username" | grep "Primary gid" | cut -d "[" -f2 | cut -d "]" -f1)"
		
			# Has matching user & is in corect location
			YEL "$folder $(YEL ":") $domain_name/$username $(YEL ":") $user_home_dir"
			echo " ∟ $folder_access"
			
			# Set owner & owner group
			MAG " ∟ Crowning User as Owner & Owner Group"
			chown -R "$user_uid":"$user_gid" "$working_directory/$folder"  # bar=${foo/ /.}
			
			# Show updated folder access
			folder_access="$(stat "$folder" | grep "Access: (" )"
			echo " ∟ $folder_access"
		fi
	else
		# NO matching user or is not correct filename
		RED "$folder $(YEL ":") $(WHT "$domain_name/$username") $(YEL ":") $(WHT "$user_home_dir")"
		echo " ∟ $(stat "$folder" | grep "Access: (" )"
	fi
done
BRK 3