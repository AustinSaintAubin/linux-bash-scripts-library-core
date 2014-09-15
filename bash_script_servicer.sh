#!/bin/sh
# Bash Script Servicer / Runner - 2014/08/28 - v1.0.0 - Written By: Austin Saint Aubin"
#  ∟ Description: Will run a bash script as a service recursively if needed."
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/.../bash_script_servicer.sh" "/../SCRIPT.sh" MODE LOOP_TIME
# General Usage: sh "/volume1/active_system/scripts/bash_script_servicer.sh" "/volume1/active_system/scripts/directory_rsync.sh" start 90
# =================================================================================================
# Notes:
#	
# =================================================================================================
# [# Global Static Variables #]
SCRIPT_PATH="$1"
SCRIPT_FILENAME="$(basename $SCRIPT_PATH)"
LOOP_SLEEP_TIME=$3
# Start & Stop Varables
PID_FILE="/var/run/${SCRIPT_FILENAME}.pid"

# [# Global Variables #]

# [# Included Library's & Scripts #]
# PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
source /root/.profile  # Get Environment Variables from Root Profile

# [# Main Program #] --------------------------------------------------------------------------------------
StartProgram() {
	echo "Starting: ${SCRIPT_FILENAME}" 
	
	if [ -z $LOOP_SLEEP_TIME ]; then
		# Run Program without loop
		source "$SCRIPT_PATH"
	else
		# Loop & Run Program
		while sh "$SCRIPT_PATH"; do :; sleep $LOOP_SLEEP_TIME; done
	fi
}

# [# Functions #]
DaemonStart() {
	DaemonStatus
	if [ $? == 0 ]; then
		# Run Program / Script
		StartProgram &
		
		# Create PID File
		echo $! > "$PID_FILE"
	else
		echo "${SCRIPT_FILENAME} already running."
	fi
}

DaemonDebug() {
	DaemonStatus
	if [ $? == 0 ]; then
		echo "Starting: ${SCRIPT_FILENAME}"
		
		# Run Script
		MainProgram
	fi
}

DaemonStop() {
	DaemonStatus
	if [ $? == 1 ]; then
		echo "Stopping: ${SCRIPT_FILENAME}."
		kill $(cat "$PID_FILE");
		rm -f "$PID_FILE"
		
		sleep 3
	else
		echo "Nothing to stop for: ${SCRIPT_FILENAME}."
	fi
}

DaemonStatus() {
	# Check if PID file exist
	if [ -f "$PID_FILE" ]; then
		PID=$(cat "$PID_FILE")
		
		if [ -n "$(ps | grep $PID | grep -vn "grep $PID")" ]; then
			echo "${SCRIPT_FILENAME} is running ..."
			return 1  # is running
		else
			echo "${SCRIPT_FILENAME} is NOT running ..."
			rm -f ${PID_FILE}  # Remove Invalid PID
			return 0  # is NOT running
		fi
	else
		echo "${SCRIPT_FILENAME} is NOT running ...."
		return 0  # is NOT running
	fi
}

# [# Service Control #] --------------------------------------------------------------------------------------
case $2 in
	start)
		DaemonStart
		sleep 1
		DaemonStatus
		exit $(( ! $? ))  # [ $? == 1 ] && exit 0 || exit 1  # this if statement flips the boolean outcome.
	;;
	stop)
		DaemonStop
		sleep 1
		DaemonStatus
		exit $?
	;;
	restart)
		DaemonStop
		sleep 10
		DaemonStart
		sleep 1
		DaemonStatus
		exit $(( ! $? ))  # this if statement flips the boolean outcome.
	;;
	status)
		DaemonStatus
		exit $(( ! $? ))  # this if statement flips the boolean outcome.
	;;
	debug)
		DaemonDebug
		exit 0
	;;
	log-show)
		cat "$LOGSTASH_LOG_PATH"
		exit 0
	;;
	log-clear)
		rm -f "$LOGSTASH_LOG_PATH"
		exit 0
	;;
	log)
		echo "$LOGSTASH_LOG_PATH"
		exit 0
	;;
	*)
		echo "Usage: $0 {script_path} {start|stop|restart|status|debug|log|log-show|log-clear}"
		exit 1
	;;
esac