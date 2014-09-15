# Dependencies Check - v4 2013/04/20
# Checks to make sure that the script has everything it needs to run.
# dependencies_check.sh [AppsToCheck]
# source /mnt/scripts/dependencies/dependencies_check.sh "echo printf usleep sleep nc telnet ser2net"

# Include Color Functions
source /mnt/scripts/dependencies/color_text_functions.sh

# Main Function
checkDependencies "Apps to check"
checkDependencies()
{
	# DependenciesList is the list of application this script needs to have available in order to run.
	if [ -z "$@" ]; then 
		#DependenciesList="echo printf usleep sleep nc telnet ser2net"
		#YEL "Checking Scripts Dependencies"
		#BLK "$DependenciesList"
		
		WRN "No Dependencies Passes"
		exit 0
	else
		DependenciesList="$@"
	fi
	
	BRK 6
	for DPCY in $DependenciesList; do
		DPCY_Location="$(which $DPCY)"
		if [ -z "$DPCY_Location" ]; then 
			FAIL "$DPCY"
			# WRN "Exiting script because of Dependency Failure"
			WRN "Dependency Failure, installation of [$DPCY] needed"
			
			if [ -n "$(which ipkg)" ]; then
				read -t 30 -n 1 -p "Would you like to install [$DPCY] by using \"ipkg\" (y/n)? "
				echo ""
				if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
					# echo "Choice: Yes"
					BLK "Updating IPKG Package List"
					ipkg update
					MAG "Running IPKG Install of: $DPCY"
					ipkg install "$DPCY"
					# Call checkDependencies Function for DPCY and test to see if install was a success.
					checkDependencies "$DPCY"
				else
					# echo "Choice: No"
					WRN "Exiting script because of Dependency Failure, install [$DPCY] manualy, or install optware and use it to install [$DPCY]"
					exit 0
				fi
			else
				WRN "Exiting script because of Dependency Failure, install [$DPCY] manualy, or install optware and use it to install [$DPCY]"
				exit 0
			fi
			
		else
			PASS "$DPCY\t |\t $DPCY_Location"
		fi
	done
	
	BRK 6
	if [ -z "$1" ]; then 
		GRN "All Dependencies are Present. =^-^="
	fi
}
