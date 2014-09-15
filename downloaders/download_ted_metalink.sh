script_title="Synology TED Videos Downloader using Metalink - 2013/12/18 - v1.0.3 - Written By: Austin Saint Aubin"
script_description=" ∟ Description: Download Files from inside of a Metalink file"
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/system_scripts/downloaders/download_ted_metalink.sh" "http://metated.petarmaric.com/metalinks/TED-talks-grouped-by-event-in-high-quality.en.metalink" "/volume1/Video/TED/TEDTalks (HD)" "yes" "256" "yes"
# =================================================================================================
# Notes:
#	Uses Color Functions Script (source /.../color_text_functions.sh)
# =================================================================================================
# [# Global Variables #]
metalink="http://metated.petarmaric.com/metalinks/TED-talks-grouped-by-event-in-high-quality.en.metalink"
download_destination_directory="/volume1/Video/TED/TEDTalks (HD)"
check_file_size="yes"  # Set Check File Size Boolean, will compaire file size before/when downloading
download_size_min=256  # Set Download Size Min ( if lower will use alternate link )
send_terminal_message="yes"  # Set Send Terminal Message Boolean (Synology)


# [# Included Library's & Scripts #]
source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions
#source "/volume1/active_system/system_scripts/dependencies/color_text_functions-nocolor.sh"  # Include Color Functions

# [# Functions #]
checkFolder() { [ -d "$@" ] && MAG "Directory Exists: $(BLK "$@")" || (BLU "Making Directory: $(WHT "$@")"; mkdir -p "$@"); }
download()  # URL DestinationDirectory DestinationFile 
{
	# Check of Download Folder Exists
	checkFolder "$2"
	
	# Notify
	[ $send_terminal_message == "yes" ] && NTFY "Downloading: $4" "TED Videos Downloader";
	
	# Start Download
	curl -L "$1" > "$3"  # Using CURL to download
}

# [# Output Header #] --------------------------------------------------------------------------------------
WHT "$script_title"
WHT "$script_description"
BRK 1

# [# Get Passed Info #] --------------------------------------------------------------------------------------
# Set Download Metalink Location
if [ -z "$1" ]; then 
	YEL "Download Metalink $(WHT "[") $(RED "NOT Passed") $(WHT "]")"
else
	YEL "Download Metalink $(WHT "[") $(GRN "Passed") $(WHT "]")"
	metalink="$1"
fi
BLU "∟ Using: $(WHT "$metalink")"

# Set Download Location
if [ -z "$2" ]; then 
	YEL "Download Location $(WHT "[") $(RED "NOT Passed") $(WHT "]")"
else
	YEL "Download Location $(WHT "[") $(GRN "Passed") $(WHT "]")"
	download_destination_directory="$2"
fi
BLU "∟ Using: $(WHT "$download_destination_directory")"

# Set Check File Size Boolean
if [ -z "$3" ]; then 
	YEL "Check File Size Boolean $(WHT "[") $(RED "NOT Passed") $(WHT "]")"
else
	YEL "Check File Size Boolean $(WHT "[") $(GRN "Passed") $(WHT "]")"
	check_file_size="$3"
fi
BLU "∟ Using: $(WHT "$check_file_size")"

# Set Download Size Min ( if lower will use alternate link )
if [ -z "$4" ]; then 
	YEL "Download Size Min $(WHT "[") $(RED "NOT Passed") $(WHT "]")"
else
	YEL "Download Size Min $(WHT "[") $(GRN "Passed") $(WHT "]")"
	download_size_min="$4"
fi
BLU "∟ Using: $(WHT "$download_size_min")"

# Set Send Terminal Message Boolean (Synology)
if [ -z "$5" ]; then 
	YEL "Send Terminal Message Boolean (Synology) $(WHT "[") $(RED "NOT Passed") $(WHT "]")"
else
	YEL "Send Terminal Message Boolean (Synology) $(WHT "[") $(GRN "Passed") $(WHT "]")"
	send_terminal_message="$5"
fi
BLU "∟ Using: $(WHT "$send_terminal_message")"

# [# Main #] --------------------------------------------------------------------------------------
# Create Download Destination Folder
checkFolder "$download_destination_directory"

# Store Metalink into download_destination_directory
web_cache="$(basename $metalink)"   # #web_cache=$( curl --silent $metalink )
WHT "Downloading Metalink to: $download_destination_directory/$web_cache"
curl $metalink > "$download_destination_directory/$web_cache"

# Process Metalink File
item_name=""  # Set item_name Scope
curl --silent $metalink | while read web_cache_line; do
	#echo "$web_cache_line"
	
	# Get Items Name
	item_name_buffer=$( echo $web_cache_line | egrep -i -o '(name)="[^"]*' | grep -o '[^"]*$' )
	
	# Check if Name contains Data
	if [ -n "$item_name_buffer" ]; then 
		# Set Items Name
		item_name="$item_name_buffer"
		
	    BRK 7
		WHT "Item Name: $(NRM "$item_name")"
	else
		item_url=$(echo $web_cache_line | egrep -i 'http:(\.|-|\/|\w)*\.(gif|jpg|png|bmp|mp3|mp4|avi|mkv)' | cut -d ">" -f2 | cut -d "<" -f1 )
		
		# Check if URL contains Data
		if [ -n "$item_url" ]; then 
			WHT "Item URL: $(NRM "$item_url")"
			
			# Download File Locations
			item_destination_directory="$download_destination_directory/$(dirname "$item_name")"
			item_destination_file="$download_destination_directory/$item_name"
			
			# Check if item exsist already
			if [ -f "$item_destination_file" ]; then
				RED "File already exists: $( BLK "$item_destination_file" )"
				
				# Compaire Local & Remote File Size
				if [ "$check_file_size" = "yes" ]; then
					# Strip the Download File of "-en" (Subtile Download Request)
					item_url_alternate="$( echo "$item_url" | sed "s/-en//g" )"  # Might Need it later
				
					# Get Items Local & Remote File Size
					item_local_size=$(ls -la "$item_destination_file" | awk '{ print $5}')
					item_remote_size=$( curl -sI -L "$item_url" | grep "Content-Length" | awk '{ print $2}' )
					item_remote_size_alternate=$( curl -sI -L "$item_url_alternate" | grep "Content-Length" | awk '{ print $2}' )
					
					# Check if Remote Size was retrived.
					if [ -n $item_remote_size ]; then
						# Check File Size
						if [ $item_local_size -eq $item_remote_size ] && [ $item_local_size -gt $download_size_min ]; then 
							NRM "File Size: $(BLU "$item_local_size (Local)") $(GRN '==') $(YEL "$item_remote_size (Remote)")"
						elif [ $item_local_size -gt $download_size_min ] && [ $item_remote_size -gt $download_size_min ]; then
							# Download Normal
							NRM "File Size: $(BLU "$item_local_size (Local)") $(RED '!=') $(YEL "$item_remote_size (Remote)")"
							download "$item_url" "$item_destination_directory" "$item_destination_file" "$item_name"
						# Check if Alternate Remote Size was retrived.
						elif [ -n item_remote_size_alternate ]; then
							# Test ALTERNATE
							if [ $item_local_size -eq $item_remote_size_alternate ]; then
								NRM "File Size: $(BLU "$item_local_size (Local)") $(GRN '==') $(YEL "$item_remote_size_alternate (Remote ALTERNATE)") $(BLK '!=') $(BLK "$item_remote_size (Remote)")"
							elif [ $item_remote_size_alternate -gt $download_size_min ]; then
								# Download with alternate
								NRM "File Size: $(BLU "$item_local_size (Local)") $(RED '!=') $(YEL "$item_remote_size_alternate (Remote ALTERNATE)")"
								BLK "Item ALTERNATE URL: $(NRM "$item_url_alternate")"
								download "$item_url_alternate" "$item_destination_directory" "$item_destination_file" "$item_name"
							fi
						else
							WRN "Compaire Local & Remote File Size ERROR"
						fi
					fi
				fi
				
			else
				# Download Item
				GRN "File does not exists, Downloading it: $( BLK "$item_destination_file" )"
				# checkFolder "$item_destination_directory"
				# ###wget -O "$download_destination_directory/$item_name" "$item_url"
				# curl -L "$item_url" > "$item_destination_file"
				download "$item_url" "$item_destination_directory" "$item_destination_file" "$item_name"
			fi
		fi
	fi
done


#downloadFilter=$(curl --silent $2 | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$3')' )
#[ -f $fileName ] && logIt "File already exists." || (logIt "File does not exists, Downloading it."; wget $2)