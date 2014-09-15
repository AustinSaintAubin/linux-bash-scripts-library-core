# Creates Password less Login for Max OS X on most linux systems
# Written 2013/05/01   By: Austin Saint Aubin
# sh $(nvram get usb_tomato)/Scripts/BashDowner.sh
# ============================================================================

# COLOR( "Your Text" ) --------------------------------------------------
# Color Function (No Logger) - 2013/04/20 - v5.1 MacOSX
NTFY() { echo -e "$@"; synodsmnotify @administrators "Terminal Message" "$(echo $@)"; }
BLK() { echo -e "\033[30;40;1m$@\033[0m"; }
RED() { echo -e "\033[31;40;1m$@\033[0m"; }
GRN() { echo -e "\033[32;40;1m$@\033[0m"; }
YEL() { echo -e "\033[33;40;1m$@\033[0m"; }
BLU() { echo -e "\033[34;40;1m$@\033[0m"; }
MAG() { echo -e "\033[35;40;1m$@\033[0m"; }
CYN() { echo -e "\033[36;40;1m$@\033[0m"; }
WHT() { echo -e "\033[37;40;1m$@\033[0m"; }
WRN() { echo -e "\033[31;40;1m/\033[33;40;1m!\033[31;40;1m\\ \033[33;40;1mWARNING:\033[37;40;1m $@ \033[31;40;1m/\033[33;40;1m!\033[31;40;1m\\ \033[0m $(tput bel)"; } # "$(tput bel)" = BEL = Bell Sound
PASS() { echo -e "\033[30;40;1m$@ \t \033[37;40;1m[\033[32;40;1mPass\033[37;40;1m]\033[0m"; }
FAIL() { echo -e "\033[37;40;1m$@ \t \033[37;40;1m[\033[31;40;1mFail\033[37;40;1m]\033[0m $(tput bel)"; }
QSTYN()
{
	read -t 30 -n 1 -p "$(echo -e "\033[35;40;1m(\033[34;40;1m?\033[35;40;1m) \033[34;40;1mQUESTION:\033[37;40;1m $@? \033[37;40;1m(\033[32;40;1my\033[37;40;1m/\033[31;40;1mn\033[37;40;1m) \033[32;40;1m:\033[0m$(tput bel) ")"
	echo " " # Creates Newline
}
QST()
{
	read -p "$(echo -e "\033[35;40;1m(\033[34;40;1m?\033[35;40;1m) \033[34;40;1mQUESTION:\033[37;40;1m $@\033[32;40;1m:\033[0m$(tput bel) ")"
	echo " " # Creates Newline
}
BRK()
{
	if [ $1 == 1 ]; then
		YEL "***<=============>*****<=============>***"
	elif [ $1 == 2 ]; then
		BLU "========================================="
	elif [ $1 == 3 ]; then
		BLK "~---------------------------------------~"
	elif [ $1 == 4 ]; then
		BLU "~ - - - - - - - - - - - - - - - - - - - ~"
	elif [ $1 == 5 ]; then
		BLK "~   -   -   -   -   -   -   -   -   -   ~"
	elif [ $1 == 6 ]; then
		BLK "........................................."
	elif [ $1 == 7 ]; then
		BLK "_________________________________________\n"
	else
		WRN "Break Formatting ERROR [ $2 ]"
	fi
}

# == [ Build Keys ] ================================================
#read -t 30 -n 1 -p "Build New Key on Client (y/n)? []"
while true; do
    QSTYN "Build New Key on Client [n]"
    case $REPLY in
        [Yy]* ) YEL "Building New Key"; echo ssh-keygen -t rsa; break;; # On client (Mac OS X): On you host computer (not the diskstation) open a terminal and run the following command:
        [Nn]* ) BLK "Using Current Key"; break;;
        * ) RED "Please answer (y/n).";;
    esac
done

# Pause and wait
read -t 60 -n 1 -p "Press any key to exit…(60 sec timeout)"

# == [ Send Keys to Server / NAS ] ================================================
# Adds a clients id_rsa.pub to authorized_keys for user on NAS

QST "Server Hostname or IP"
SERVER="$REPLY"
QST "Username on \"$SERVER\""
USERNAME="$REPLY"

# [ These run from workstation and connect to server ]
# On NAS: You need to create a directory with a file containing the the authorized keys of clients being able to connect.
# On NAS: Copy the content of your id_rsa.pub file from your Host-computer (the one you want to connect from) into the authorized_keys file.
# On NAS: Change the file permissions of the authorized-key file.
cat ~/.ssh/id_rsa.pub | ssh $USERNAME@$SERVER 'mkdir ~/.ssh; touch ~/.ssh/authorized_keys; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 644 ~/.ssh/authorized_keys; echo "========================"; cat ~/.ssh/authorized_keys; echo "========================";'

# Pause and wait
read -t 60 -n 1 -p "Press any key to exit…(60 sec timeout)"
