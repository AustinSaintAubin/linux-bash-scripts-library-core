script_title="Add File Extention - 2013/12/18 - v1.0.0 - Written By: Austin Saint Aubin"
script_description=" ∟ Description: Adds File Extention to all files in nested directory if they do not meet criteria"
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/system_scripts/add_file_extention.sh"
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# [# Global Variables #]
exspected_file_extention="mp4|avi|mov"
working_directory="/volume1/Video/TED/"


# [# Included Library's & Scripts #]
source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions
#source "/volume1/active_system/system_scripts/dependencies/color_text_functions-nocolor.sh"  # Include Color Functions

# [# Functions #]
checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }

# [# Output Header #] --------------------------------------------------------------------------------------
WHT "$script_title"
WHT "$script_description"
BRK 1


#echo $(echo $filename |awk -F . '{if (NF>1) {print $NF}}')

# for file in "$working_directory"/*
# do
#     echo $file
# done

#find . -type f -exec echo "Hello, '{}'" \; 

WHT "Searching: $working_directory"

# Read though and find files with non-matching file extentions
find "$working_directory" -type f | grep -v "@eaDir" | egrep -v "$exspected_file_extention" | while read files
do
	# Output File Name
    BLK "$files"
    
    
done