#/etc/profile: system-wide .profile file for ash.
# =========================================================
umask 022

# [# Set Paths #]
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin
export PATH

#This fixes the backspace when telnetting in.
#if [ "$TERM" != "linux" ]; then
#        stty erase
#fi
PGDATA=/var/service/pgsql
export PGDATA

TERM=${TERM:-cons25}
export TERM

PAGER=more
export PAGER

PS1="`hostname`> "
export PS1

alias dir="ls -al"
alias ll="ls -la"

ulimit -c unlimited

# Java Paths
PATH=$PATH:/var/packages/JavaManager/target/Java/bin
PATH=$PATH:/var/packages/JavaManager/target/Java/jre/bin
JAVA_HOME=/var/packages/JavaManager/target/Java/jre
CLASSPATH=.:/var/packages/JavaManager/target/Java/jre/lib
LANG=en_US.utf8
export CLASSPATH PATH JAVA_HOME LANG
# =============================================
#/etc/profile: system-wide .profile file for ash.
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# [# Included Library's & Scripts #]
source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions

# Set Teminal Title
TITLE "$(hostname)"

# Set Terminal Environment variables
#PS1="`hostname`> "
PS1='\[\e[0;32m\]\u\[\e[1;37m\]@\[\e[0;31m\]\h \[\e[1;34m\]\w \[\e[1;32m\]\$ \[\e[1;37m\]\e[0m'
export PS1

BRK 4
MAG $(uname -a)
YEL $(uptime)
BRK 4

# Check if in Screen Session
if [ "$TERM" != "screen" ]; then
	# Check for the environment variable $STY (contains info about the screen) or for $TERM being 'screen'.
	# [[ "$TERM" == "screen" ]] && echo "in screen"
	# [[ "$STY" == NULL ]] && echo "in screen"
	# [[ "$TERM" != "screen" && "$STY" == NULL ]] && echo "in screen"
	QSTYN "Would you like to resume last screen session by using \"screen -RR\""
	if [ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]; then
		echo "Choice: Yes"
		screen -RR
		#screen -d
	else
		echo "Choice: No"
		echo "[ Listing of screen sessions \"screen -ls\" ]"
		screen -ls
	fi
fi