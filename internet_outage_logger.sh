TITLE="Internet Outage Logger Script v5.0 - 2011/09/05"
# Written By: AustinSaintAubin@gmail.com
# https://docs.google.com/document/d/1gcVKuAm4hCaH_wC6DcrtO36cdAdb6EdATAZwvt5do1k/edit?hl=en_US&authkey=COTh8bED
# PingLEDStatus.sh "led" "IP"
# sh $(nvram get usb_disk_main)/Tomato/Scripts/Connection_Logger_and_Status_Script.sh "$(nvram get wan_gateway)" "white"
# ====================================================================================================
ShortLogSeconds=60	#Shorter log notetion for anything less than this time.
DoNotLogSeconds=3	#Will not log if down for less than X secionds.
LogDirectoy="$(nvram get usb_disk_main)/active_system/archives/internet_outage_logs"
LogFilename="internet_outage_log"
ISP="COX Business 1year - 15mb Down / 3mb Up"
ZipCode="73013"
# ----------------------------------------------
LogLocation=$LogDirectoy"/"$LogFilename"_"$(date +%Y-%m_%B)".txt"
ADDRESS="$1"
LED="$2"
DownStateTimeSec=1  # DownStateTimeSec=$(date +%s)
DownStateTime="Start of Script"
lastConState="Up"


# Functions ------------------------------------
checkFolder() { [ -d "$@" ] && echo "$(BLU "Folder Exists: $@")" || (echo "$(MAG "Making Folder: $@")"; mkdir -p "$@"); } #CheckFolder v3 - 2011/02/20

# COLOR( "Your Text" )
BLK() { echo -e "\033[30;40;1m$@\033[0m"; }
RED() { echo -e "\033[31;40;1m$@\033[0m"; }
GRN() { echo -e "\033[32;40;1m$@\033[0m"; }
YEL() { echo -e "\033[33;40;1m$@\033[0m"; }
BLU() { echo -e "\033[34;40;1m$@\033[0m"; }
MAG() { echo -e "\033[35;40;1m$@\033[0m"; }
CYN() { echo -e "\033[36;40;1m$@\033[0m"; }
WHT() { echo -e "\033[37;40;1m$@\033[0m"; }
WRN() { echo -e "\033[31;40;1m/\033[33;40;1m!\033[31;40;1m\\ \033[33;40;1mWARNING:\033[37;40;1m $@ \033[31;40;1m/\033[33;40;1m!\033[31;40;1m\ \\033[0m"; }

logPrepair()
{
	#Check if Log Location needs Updating
	if [ "$(echo $LogDirectoy"/"$LogFilename"_"$(date +%Y-%m_%B)".txt")" != "$LogLocation" ]; then
		LogLocation=$LogDirectoy"/"$LogFilename"_"$(date +%Y-%m_%B)".txt"
		BLK "Updating Log Location: "$LogFilename"_"$(date +%Y-%m_%B)".txt"
	fi
	
	# echo "$(GRN "Setting up Log File:") $(WHT "$LogLocation")"
	if [ -f "$LogLocation" ]; then
		#echo "$(RED "Deleting Log File:") $(BLK "$LogDirectoy/$dstLogFilename")"
		#rm -f "$LogDirectoy/$dstLogFilename"
		echo "$(GRN "Log File Exsist, using it:") $(BLK "$LogLocation")"
	else
		checkFolder "$LogDirectoy"
		echo "$(YEL "Creating Log File:") $(BLK "$LogLocation")"
		echo "# $TITLE" >> "$LogLocation"
		echo "# Internet Service Provider: $ISP  |  Zip Code: $ZipCode" >> "$LogLocation"
		echo "# Creating Log: $(date '+DATE: %m/%d/%y TIME: %r')" >> "$LogLocation"
		echo "================================================================================" >> "$LogLocation"
		echo "" >> "$LogLocation"
	fi
}

# ConectionState ( CurrentState, LastState )
ConectionState()
{
	CurrentState="$1"
	LastState="$2"
	
	BLK "- - - - - - - - - - - - - - - - - - - - - -"
	WHT "$(BLU $ADDRESS) $(YEL CHANGED STATE!!!)"
	BLK "LastState: $(GrnOrRed $LastState)"
	BLK "CurrentState: $(GrnOrRed $CurrentState)"
	BLK "- - - - - - - - - - - - - - - - - - - - - -"
	
	TimeStampOutput "$CurrentState"
}

TimeStampOutput()
{
	TimeStamp=$(date +%a\ %B\ %d\ \(%m/%d/%Y\)\ %I:%M:%S\ %p)
	
	if [ $1 == "Down" ]; then
		# LED Light Change
		BLK "Setting LED: $(WHT "$LED") $(GRN "on")"
		led $LED on
		BLK "-  -  -  -  -  -  -  -  -  -  -  -  -  -  -"
		
		# Write State to temp file for LCD Scree Readout
		YEL "Writing State $(RED "Down") $(BLK "to Wan Status Log:") $(WHT "/tmp/wan_status.txt")"
		echo "Down | $(date +%a\ %I:%M%P)" > /tmp/wan_status.txt
		
		# Creating Time Stamps for Down State
		DownStateTimeSec=$(date +%s)
		DownStateTime=$TimeStamp
		
	elif [ $1 == "Up" ]; then
		# LED Light Change
		BLK "Setting LED: $(WHT "$LED") $(YEL "off")"
		led $LED off
		BLK "-  -  -  -  -  -  -  -  -  -  -  -  -  -  -"
		
		# Write State to temp file for LCD Scree Readout
		YEL "Writing State $(GRN "Up") $(BLK "to Wan Status Log:") $(WHT "/tmp/wan_status.txt")"
		echo "Up | $(date +%a\ %I:%M%P)" > /tmp/wan_status.txt
		
		CurrentDateSec=$(date +%s) #This is to try and fix post processing problems
		if [ $(($CurrentDateSec - $DownStateTimeSec)) -lt $DoNotLogSeconds ]; then
			echo "$(BLU $ADDRESS) was $(RED Down) $(YEL "for < $DoNotLogSeconds sec, not logging.")"
		elif [ $(($CurrentDateSec - $DownStateTimeSec)) -gt $ShortLogSeconds ]; then
			# Down State Logs
			echo "$(CYN $DownStateTime) | $(BLU $ADDRESS) $(WHT [$(RED Down)])"
			echo "$DownStateTime | $ADDRESS [Down]" >> "$LogLocation"
			logger -t WANStatus "$DownStateTime | $ADDRESS [Down]"
			
			#===========================================================
			# Up State Logs
			TimePassed=$(timeOutput $(($CurrentDateSec - $DownStateTimeSec)))
			
			echo "$(CYN $TimeStamp) | $(BLU $ADDRESS) $(WHT [$(GRN Up)])"
			BLK "Was $(WHT [$(RED Down)]) $(BLK for) $(MAG $TimePassed)"
			BLK "-------------------------------------------"
			
			echo "$TimeStamp | $ADDRESS [Up]" >> "$LogLocation"
			echo "Was [Down] for $TimePassed" >> "$LogLocation"
			echo "-------------------------------------------" >> "$LogLocation"
			
			logger -t WANStatus "$TimeStamp | $ADDRESS [Up]"
			logger -t WANStatus "Was [Down] for $TimePassed"
			#logger -t WANStatus "~------------------------------------------"
		else
			TimePassed=$(($CurrentDateSec - $DownStateTimeSec))
			# If connection was down for less than X secionds
			echo "$(CYN $TimeStamp) | $(BLU $ADDRESS) | $(YEL "Connection Was Down for $TimePassed second(s)")"
			BLK "- - - - - - - - - - - - - - - - - - - - - -"
			
			echo "$TimeStamp | $ADDRESS | Connection Was Down for $TimePassed second(s)" >> "$LogLocation"
			echo "- - - - - - - - - - - - - - - - - - - - - -" >> "$LogLocation"
			
			logger -t WANStatus "$TimeStamp | $ADDRESS | Connection Was Down for $TimePassed second(s)"
			#logger -t WANStatus "~ - - - - - - - - - - - - - - - - - - - - -"
		fi
	else
		WRN "TimeStampOutput: Error"
	fi
}

timeOutput()
{
	seconds=$1

	days=$((seconds / 86400 ))
	seconds=$((seconds % 86400))
	hours=$((seconds / 3600))
	seconds=$((seconds % 3600))
	minutes=$((seconds / 60))
	seconds=$((seconds % 60))

	output=""
	if [ $days -gt 0 ]; then
		output="$days days(s) "
	fi
	if [ $hours -gt 0 ]; then
		output="$output$hours hour(s) "
	fi
	if [ $minutes -gt 0 ]; then
		output="$output$minutes minute(s) "
	fi
	if [ $seconds -gt 0 ]; then
		output="$output$seconds seconds(s) "
	fi
	
	# echo "$hours hour(s) $minutes minute(s) $seconds second(s)"
	echo "$output"
}

GrnOrRed()
{
	[ $1 != "Up" ] && ( RED $1 ) || ( GRN $1 )
}

ResetWANAdress()
{
	ADDRESS="$(nvram get wan_gateway)"
	while sleep 3 && [ "$ADDRESS" != "${ADDRESS/0.0.0.0/}" ] || [ "$ADDRESS" != "${ADDRESS/192.168.1./}" ]; do
		WRN "$ADDRESS NOT valid, attempting to reset WAN IP address"
		logger -t WANStatus "$ADDRESS NOT valid, attempting to reset WAN IP address"
		dhcpc-release
		sleep 10
		dhcpc-renew
		sleep 3
		ADDRESS="$(nvram get wan_gateway)"
	done
}

# ==============================================================

# Varable for checking if script is already running.
BLK "$TITLE | $(WHT IP:) $(BLU $ADDRESS) $(BLK "|") $(WHT LED:) $(MAG $LED)"
logger -t WANStatus "$TITLE | IP: $ADDRESS | LED: $LED"
SCRIPT_STATUS=$(ps -w | grep -v $$ | grep `basename $0` | grep "$ADDRESS" | grep -v "grep" | wc -l)
# Write State to temp file for LCD Scree Readout
# YEL "Writing State $(GRN "Up") $(BLK "to Wan Status Log:") $(WHT "/tmp/wan_status.txt")"
# echo "Up | $(date +%a\ %I:%M%P)" > /tmp/wan_status.txt

# Check Address
BLK "Testing Address for validity"
if [ "$ADDRESS" != "${ADDRESS/0.0.0.0/}" ] || [ "$ADDRESS" != "${ADDRESS/192.168.1./}" ]; then
	# Connection Down
	ConectionState "Down" "Up"
		ResetWANAdress
	ConectionState "Up" "Down"
fi

# Main ------------------------------------------
sleep 1
if [ "$SCRIPT_STATUS" -le "2"  ]; then # Checking if script is already running.
	YEL "Pinging $(BLK with a wait time of) $(WHT "1 second(s)") $(BLK at) $(WHT 1 count),\n $(BLK "shorter notes of connection drop of less than") $(WHT "$ShortLogSeconds second(s)"),\n $(BLK "will not log for less than") $(WHT "$DoNotLogSeconds second(s)")." 
	while sleep 1; do
		# ping -w 1 -c 1 $ADDRESS > /dev/null && (led $LED off; echo "$ADDRESS is up"; ConectionState up $lastConState; lastConState="up") || (led $LED on; echo "$ADDRESS is down"; ConectionState up $lastConState; lastConState="down")
		if ping -w 1 -c 1 $ADDRESS > /dev/null; then
			# Connection Up
			echo "$(BLU $ADDRESS) is $(GRN Up)"
			# logger -t WANStatus "$ADDRESS is Up"
		else
			if !(ping -w 1 -c 1 $ADDRESS > /dev/null); then
				# Connection Down
				ConectionState "Down" "Up"
				
				#Setup Log File & Log Header
				logPrepair
				
				while !(ping -w 1 -c 1 $ADDRESS > /dev/null); do
					if [ "$(nvram get wan_gateway)" != "${ADDRESS/0.0.0.0/}" ] || [ "$(nvram get wan_gateway)" != "${ADDRESS/192.168.1./}" ]; then
						ADDRESS="$(nvram get wan_gateway)"
						echo "$(BLU $ADDRESS) is $(RED Down), and Address is not valid, atempting reset"
						ResetWANAdress
					else
						echo "$(BLU $ADDRESS) is $(RED Down)"
					fi
				done
				ConectionState "Up" "Down"
				# logger -t WANStatus "$ADDRESS is Down"
			else
				YEL "Possable False Down Time. Conection was down for less than a seciond"
			fi
		fi
	done
else
	WRN "($SCRIPT_STATUS) Script Process(s) Already Running for $ADDRESS, Exiting Script"
	BLK "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"
	echo "PID: $$"
	ps -w | grep -v "grep" | grep -v $$ | grep `basename $0` | grep "$ADDRESS"
	BLK "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"
fi