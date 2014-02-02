ScriptInfo_color_text_functions() {
SCRIPT_NAME="Color Text Functions Library"; SCRIPT_VERSION="7.6"; SCRIPT_DATE="2014/02/01"; SCRIPT_AUTHER="Austin Saint Aubin"; SCRIPT_AUTHER_CONTACT="AustinSaintAubin@gmail.com"
SCRIPT_DESCRIPTION="Used for make colors easy"
SCRIPT_TITLE="Dependency: $(RED ${SCRIPT_NAME:0:1})$(GRN ${SCRIPT_NAME:1:1})$(YEL ${SCRIPT_NAME:2:1})$(BLU ${SCRIPT_NAME:3:1})$(MAG ${SCRIPT_NAME:4:1}) $(WHT ${SCRIPT_NAME:5}) - $(GRN "v$SCRIPT_VERSION") - $(BLU "$SCRIPT_DATE") - $(CYN "$SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT)") \n   ∟ Description: $SCRIPT_DESCRIPTION ( $(BLKB Black), $(REDB Red), $(GRNB Green), $(YELB Yellow), $(BLUB Blue), $(MAGB Magenta), $(CYNB Cyan), $(WHTB White) )"
echo -e " $(YEL "▶︎") $SCRIPT_TITLE"; }
# -------------------------------------------------------------------------------------------------
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# source "/volume1/active_system/system_scripts/dependencies/color_text_functions.sh" # Include Color Functions
# NRM "$(BLK Black), $(RED Red), $(GRN Green), $(YEL Yellow), $(BLU Blue), $(MAG Magenta), $(CYN Cyan), $(WHT White)"
# =================================================================================================

# List of colors for prompt and Bash
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
# ---------------------------
# Reset
color_reset='\e[0m'     # Text Color Reset to Normal

# Regular Colors
color_black='\e[0;30m'        # Black
color_red='\e[0;31m'          # Red
color_green='\e[0;32m'        # Green
color_yellow='\e[0;33m'       # Yellow
color_blue='\e[0;34m'         # Blue
color_magenta='\e[0;35m'      # Magenta
color_cyan='\e[0;36m'         # Cyan
color_white='\e[0;37m'        # White

# Bold Colors
color_bold_black='\e[1;30m'       # Black
color_bold_red='\e[1;31m'         # Red
color_bold_green='\e[1;32m'       # Green
color_bold_yellow='\e[1;33m'      # Yellow
color_bold_blue='\e[1;34m'        # Blue
color_bold_magenta='\e[1;35m'     # Magenta
color_bold_cyan='\e[1;36m'        # Cyan
color_bold_white='\e[1;37m'       # White

# Underlined Colors
color_underline_black='\e[4;30m'       # Black
color_underline_red='\e[4;31m'         # Red
color_underline_green='\e[4;32m'       # Green
color_underline_yellow='\e[4;33m'      # Yellow
color_underline_blue='\e[4;34m'        # Blue
color_underline_magenta='\e[4;35m'     # Magenta
color_underline_cyan='\e[4;36m'        # Cyan
color_underline_white='\e[4;37m'       # White

# Background Colors
color_background_black='\e[40m'       # Black
color_background_red='\e[41m'         # Red
color_background_green='\e[42m'       # Green
color_background_yellow='\e[43m'      # Yellow
color_background_blue='\e[44m'        # Blue
color_background_magenta='\e[45m'     # Magenta
color_background_cyan='\e[46m'        # Cyan
color_background_white='\e[47m'       # White

# High Intensity Colors
color_intense_black='\e[0;90m'       # Black
color_intense_red='\e[0;91m'         # Red
color_intense_green='\e[0;92m'       # Green
color_intense_yellow='\e[0;93m'      # Yellow
color_intense_blue='\e[0;94m'        # Blue
color_intense_magenta='\e[0;95m'     # Magenta
color_intense_cyan='\e[0;96m'        # Cyan
color_intense_white='\e[0;97m'       # White

# Bold High Intensity Colors
color_bold_intense_black='\e[1;90m'      # Black
color_bold_intense_red='\e[1;91m'        # Red
color_bold_intense_green='\e[1;92m'      # Green
color_bold_intense_yellow='\e[1;93m'     # Yellow
color_bold_intense_blue='\e[1;94m'       # Blue
color_bold_intense_magenta='\e[1;95m'    # Magenta
color_bold_intense_cyan='\e[1;96m'       # Cyan
color_bold_intense_white='\e[1;97m'      # White

# Underlined High Intensity Colors
color_underlined_intense_black='\e[4;90m'      # Black
color_underlined_intense_red='\e[4;91m'        # Red
color_underlined_intense_green='\e[4;92m'      # Green
color_underlined_intense_yellow='\e[4;93m'     # Yellow
color_underlined_intense_blue='\e[4;94m'       # Blue
color_underlined_intense_magenta='\e[4;95m'    # Magenta
color_underlined_intense_cyan='\e[4;96m'       # Cyan
color_underlined_intense_white='\e[4;97m'      # White

# High Intensity Background Colors
color_intense_background_black='\e[0;100m'   # Black
color_intense_background_red='\e[0;101m'     # Red
color_intense_background_green='\e[0;102m'   # Green
color_intense_background_yellow='\e[0;103m'  # Yellow
color_intense_background_blue='\e[0;104m'    # Blue
color_intense_background_magenta='\e[0;105m' # Magenta
color_intense_background_cyan='\e[0;106m'    # Cyan
color_intense_background_white='\e[0;107m'   # White

# Prompt escapes
# The various Bash prompt escapes listed in the manpage:
# Bash allows these prompt strings to be customized by inserting a
# number of backslash-escaped special characters that are
# decoded as follows:
# 
escape_bell='\a'	# an ASCII bell character (07)
# 	\d		the date in "Weekday Month Date" format (e.g., "Tue May 26")
# 	\D{format}	the format is passed to strftime(3) and the result
# 			  is inserted into the prompt string an empty format
# 			  results in a locale-specific time representation.
# 			  The braces are required
# 	\e		an ASCII escape character (033)
# 	\h		the hostname up to the first `.'
# 	\H		the hostname
# 	\j		the number of jobs currently managed by the shell
# 	\l		the basename of the shell's terminal device name
# 	\n		newline
# 	\r		carriage return
# 	\s		the name of the shell, the basename of $0 (the portion following
# 			  the final slash)
# 	\t		the current time in 24-hour HH:MM:SS format
# 	\T		the current time in 12-hour HH:MM:SS format
# 	\@		the current time in 12-hour am/pm format
# 	\A		the current time in 24-hour HH:MM format
# 	\u		the username of the current user
# 	\v		the version of bash (e.g., 2.00)
# 	\V		the release of bash, version + patch level (e.g., 2.00.0)
# 	\w		the current working directory, with $HOME abbreviated with a tilde
# 	\W		the basename of the current working directory, with $HOME
# 			 abbreviated with a tilde
# 	\!		the history number of this command
# 	\#		the command number of this command
# 	\$		if the effective UID is 0, a #, otherwise a $
# 	\nnn		the character corresponding to the octal number nnn
# 	\\		a backslash
# 	\[		begin a sequence of non-printing characters, which could be used
# 			  to embed a terminal control sequence into the prompt
# 	\]		end a sequence of non-printing characters
# 
# 	The command number and the history number are usually different:
# 	the history number of a command is its position in the history
# 	list, which may include commands restored from the history file
# 	(see HISTORY below), while the command number is the position in
# 	the sequence of commands executed during the current shell session.
# 	After the string is decoded, it is expanded via parameter
# 	expansion, command substitution, arithmetic expansion, and quote
# 	removal, subject to the value of the promptvars shell option (see
# 	the description of the shopt command under SHELL BUILTIN COMMANDS
# 	below).

# Code Action/Color
# http://www.vias.org/linux-knowhow/lnag_05_05_04.html
# ---------------------------
# 0 reset all attributes to their defaults
# 1 set bold
# 2 set half-bright (simulated with color on a color display)
# 4 set underscore (simulated with color on a color display)
# 5 set blink
# 7 set reverse video
# 22 set normal intensity
# 24 underline off
# 25 blink off
# 27 reverse video off
# 30 set black foreground
# 31 set red foreground
# 32 set green foreground
# 33 set brown foreground
# 34 set blue foreground
# 35 set magenta foreground
# 36 set cyan foreground
# 37 set white foreground
# 38 set underscore on, set default foreground color
# 39 set underscore off, set default foreground color
# 40 set black background
# 41 set red background
# 42 set green background
# 43 set brown background
# 44 set blue background
# 45 set magenta background
# 46 set cyan background
# 47 set white background
# 49 set default background color


# COLOR( "Your Text" ) --------------------------------------------------
ColorOn() { # Color Function
	# Regular Colors
	BLK() { echo -e "$color_black$@$color_reset"; }   # Black
	RED() { echo -e "$color_red$@$color_reset"; }     # Red
	GRN() { echo -e "$color_green$@$color_reset"; }   # Green
	YEL() { echo -e "$color_yellow$@$color_reset"; }  # Yellow
	BLU() { echo -e "$color_blue$@$color_reset"; }    # Blue
	MAG() { echo -e "$color_magenta$@$color_reset"; } # Magenta
	CYN() { echo -e "$color_cyan$@$color_reset"; }    # Cyan
	WHT() { echo -e "$color_white$@$color_reset"; }   # White
	
	# Bold Colors
	BLKB() { echo -e "$color_bold_black$@$color_reset"; }   # Black
	REDB() { echo -e "$color_bold_red$@$color_reset"; }     # Red
	GRNB() { echo -e "$color_bold_green$@$color_reset"; }   # Green
	YELB() { echo -e "$color_bold_yellow$@$color_reset"; }  # Yellow
	BLUB() { echo -e "$color_bold_blue$@$color_reset"; }    # Blue
	MAGB() { echo -e "$color_bold_magenta$@$color_reset"; } # Magenta
	CYNB() { echo -e "$color_bold_cyan$@$color_reset"; }    # Cyan
	WHTB() { echo -e "$color_bold_white$@$color_reset"; }   # White
	
	# Underlined Colors
	BLKU() { echo -e "$color_underline_black$@$color_reset"; }   # Black
	REDU() { echo -e "$color_underline_red$@$color_reset"; }     # Red
	GRNU() { echo -e "$color_underline_green$@$color_reset"; }   # Green
	YELU() { echo -e "$color_underline_yellow$@$color_reset"; }  # Yellow
	BLUU() { echo -e "$color_underline_blue$@$color_reset"; }    # Blue
	MAGU() { echo -e "$color_underline_magenta$@$color_reset"; } # Magenta
	CYNU() { echo -e "$color_underline_cyan$@$color_reset"; }    # Cyan
	WHTU() { echo -e "$color_underline_white$@$color_reset"; }   # White
	
	# Background Colors
	BLKBG() { echo -e "$color_background_black$@$color_reset"; }   # Black
	REDBG() { echo -e "$color_background_red$@$color_reset"; }     # Red
	GRNBG() { echo -e "$color_background_green$@$color_reset"; }   # Green
	YELBG() { echo -e "$color_background_yellow$@$color_reset"; }  # Yellow
	BLUBG() { echo -e "$color_background_blue$@$color_reset"; }    # Blue
	MAGBG() { echo -e "$color_background_magenta$@$color_reset"; } # Magenta
	CYNBG() { echo -e "$color_background_cyan$@$color_reset"; }    # Cyan
	WHTBG() { echo -e "$color_background_white$@$color_reset"; }   # White
	
	# High Intensity Colors
	BLKI() { echo -e "$color_intense_black$@$color_reset"; }   # Black
	REDI() { echo -e "$color_intense_red$@$color_reset"; }     # Red
	GRNI() { echo -e "$color_intense_green$@$color_reset"; }   # Green
	YELI() { echo -e "$color_intense_yellow$@$color_reset"; }  # Yellow
	BLUI() { echo -e "$color_intense_blue$@$color_reset"; }    # Blue
	MAGI() { echo -e "$color_intense_magenta$@$color_reset"; } # Magenta
	CYNI() { echo -e "$color_intense_cyan$@$color_reset"; }    # Cyan
	WHTI() { echo -e "$color_intense_white$@$color_reset"; }   # White
	
	# Underlined High Intensity Colors
	BLKUI() { echo -e "$color_underlined_intense_black$@$color_reset"; }   # Black
	REDUI() { echo -e "$color_underlined_intense_red$@$color_reset"; }     # Red
	GRNUI() { echo -e "$color_underlined_intense_green$@$color_reset"; }   # Green
	YELUI() { echo -e "$color_underlined_intense_yellow$@$color_reset"; }  # Yellow
	BLUUI() { echo -e "$color_underlined_intense_blue$@$color_reset"; }    # Blue
	MAGUI() { echo -e "$color_underlined_intense_magenta$@$color_reset"; } # Magenta
	CYNUI() { echo -e "$color_underlined_intense_cyan$@$color_reset"; }    # Cyan
	WHTUI() { echo -e "$color_underlined_intense_white$@$color_reset"; }   # White
	
	# Bold High Intensity Colors
	BLKBI() { echo -e "$color_bold_intense_black$@$color_reset"; }   # Black
	REDBI() { echo -e "$color_bold_intense_red$@$color_reset"; }     # Red
	GRNBI() { echo -e "$color_bold_intense_green$@$color_reset"; }   # Green
	YELBI() { echo -e "$color_bold_intense_yellow$@$color_reset"; }  # Yellow
	BLUBI() { echo -e "$color_bold_intense_blue$@$color_reset"; }    # Blue
	MAGBI() { echo -e "$color_bold_intense_magenta$@$color_reset"; } # Magenta
	CYNBI() { echo -e "$color_bold_intense_cyan$@$color_reset"; }    # Cyan
	WHTBI() { echo -e "$color_bold_intense_white$@$color_reset"; }   # White
	
	# Background High Intensity Colors
	BLKBGI() { echo -e "$color_intense_background_black$@$color_reset"; }   # Black
	REDBGI() { echo -e "$color_intense_background_red$@$color_reset"; }     # Red
	GRNBGI() { echo -e "$color_intense_background_green$@$color_reset"; }   # Green
	YELBGI() { echo -e "$color_intense_background_yellow$@$color_reset"; }  # Yellow
	BLUBGI() { echo -e "$color_intense_background_blue$@$color_reset"; }    # Blue
	MAGBGI() { echo -e "$color_intense_background_magenta$@$color_reset"; } # Magenta
	CYNBGI() { echo -e "$color_intense_background_cyan$@$color_reset"; }    # Cyan
	WHTBGI() { echo -e "$color_intense_background_white$@$color_reset"; }   # White
	
	# Helper Functions
	NRM() { echo -e "$color_reset$@"; }  # Reset to normal
	CLR() { echo -e "$(clear) $@"; }  # Clear Screen
	WRN() { echo -e "$color_bold_red/$color_bold_yellow!$color_bold_red\\  $color_underlined_intense_yellow"WARNING"$color_intense_yellow:$color_reset$color_bold_white $color_background_red $@ $color_reset $color_bold_red/$color_bold_yellow!$color_bold_red\\ $color_reset $escape_bell"; } # "\7" = BEL = Bell Sound
	PASS() { echo -e "$color_white$@ \t $color_bold_white[$color_bold_green PASS $color_bold_white]$color_reset"; }
	FAIL() { echo -e "$color_bold_white$@ \t $color_bold_white[$color_bold_red FAIL $color_bold_white]$color_reset $escape_bell"; }
	INFO() { echo -e "$color_white$@ \t $color_bold_white[$color_bold_cyan INFO $color_bold_white]$color_reset"; }
	QST()  # passed Reply to $REPLY
	{
		read -p "$(echo -e "$color_magenta($color_blue?$color_magenta) $color_underline_blue"QUESTION"$color_reset$color_blue:$color_white $@?$color_blue:$color_reset $escape_bell")"
	}
	QSTYN()  # passed Reply to $REPLY
	{
		read -t 30 -n 1 -p "$(echo -e "$color_magenta($color_blue?$color_magenta) $color_underline_blue"QUESTION"$color_reset$color_blue:$color_white $@? ($color_green"y"$color_white/$color_red"n"$color_white)$color_blue:$color_reset $escape_bell")"
# 		echo " " # Creates Newline
		case $REPLY in  # Out Response
			y|Y)
				# Yes
				echo -e "  $color_bold_white($color_bold_green Yes $color_bold_white)$color_reset";;
			*) # catch all
				# No, catch all
				echo -e "  $color_bold_white($color_bold_red No $color_bold_white)$color_reset";;
		esac
	}
	NTFY() { echo -e "\033[0;30m$1$color_reset"; synodsmnotify @administrators "Script: $2" "$(echo -e "$1")"; }
	TITLE() { echo -e "\e]0;$@\a"; }  # Set Shell Window Title
}

ColorOff() {
	# Regular Colors
	BLK() { echo -e "$@"; }   # Black
	RED() { echo -e "$@"; }     # Red
	GRN() { echo -e "$@"; }   # Green
	YEL() { echo -e "$@"; }  # Yellow
	BLU() { echo -e "$@"; }    # Blue
	MAG() { echo -e "$@"; } # Magenta
	CYN() { echo -e "$@"; }    # Cyan
	WHT() { echo -e "$@"; }   # White
		
	# Bold Colors
	BLKB() { echo -e "$@"; }   # Black
	REDB() { echo -e "$@"; }     # Red
	GRNB() { echo -e "$@"; }   # Green
	YELB() { echo -e "$@"; }  # Yellow
	BLUB() { echo -e "$@"; }    # Blue
	MAGB() { echo -e "$@"; } # Magenta
	CYNB() { echo -e "$@"; }    # Cyan
	WHTB() { echo -e "$@"; }   # White
	
	# Underlined Colors
	BLKU() { echo -e "$@"; }   # Black
	REDU() { echo -e "$@"; }     # Red
	GRNU() { echo -e "$@"; }   # Green
	YELU() { echo -e "$@"; }  # Yellow
	BLUU() { echo -e "$@"; }    # Blue
	MAGU() { echo -e "$@"; } # Magenta
	CYNU() { echo -e "$@"; }    # Cyan
	WHTU() { echo -e "$@"; }   # White
	
	# Background Colors
	BLKBG() { echo -e "$@"; }   # Black
	REDBG() { echo -e "$@"; }     # Red
	GRNBG() { echo -e "$@"; }   # Green
	YELBG() { echo -e "$@"; }  # Yellow
	BLUBG() { echo -e "$@"; }    # Blue
	MAGBG() { echo -e "$@"; } # Magenta
	CYNBG() { echo -e "$@"; }    # Cyan
	WHTBG() { echo -e "$@"; }   # White
	
	# High Intensity Colors
	BLKI() { echo -e "$@"; }   # Black
	REDI() { echo -e "$@"; }     # Red
	GRNI() { echo -e "$@"; }   # Green
	YELI() { echo -e "$@"; }  # Yellow
	BLUI() { echo -e "$@"; }    # Blue
	MAGI() { echo -e "$@"; } # Magenta
	CYNI() { echo -e "$@"; }    # Cyan
	WHTI() { echo -e "$@"; }   # White
	
	# Underlined High Intensity Colors
	BLKUI() { echo -e "$@"; }   # Black
	REDUI() { echo -e "$@"; }     # Red
	GRNUI() { echo -e "$@"; }   # Green
	YELUI() { echo -e "$@"; }  # Yellow
	BLUUI() { echo -e "$@"; }    # Blue
	MAGUI() { echo -e "$@"; } # Magenta
	CYNUI() { echo -e "$@"; }    # Cyan
	WHTUI() { echo -e "$@"; }   # White
	
	# Bold High Intensity Colors
	BLKBI() { echo -e "$@"; }   # Black
	REDBI() { echo -e "$@"; }     # Red
	GRNBI() { echo -e "$@"; }   # Green
	YELBI() { echo -e "$@"; }  # Yellow
	BLUBI() { echo -e "$@"; }    # Blue
	MAGBI() { echo -e "$@"; } # Magenta
	CYNBI() { echo -e "$@"; }    # Cyan
	WHTBI() { echo -e "$@"; }   # White
	
	# Background High Intensity Colors
	BLKBGI() { echo -e "$@"; }   # Black
	REDBGI() { echo -e "$@"; }     # Red
	GRNBGI() { echo -e "$@"; }   # Green
	YELBGI() { echo -e "$@"; }  # Yellow
	BLUBGI() { echo -e "$@"; }    # Blue
	MAGBGI() { echo -e "$@"; } # Magenta
	CYNBGI() { echo -e "$@"; }    # Cyan
	WHTBGI() { echo -e "$@"; }   # White
	
	NRM() { echo -e "$@"; }  # Reset to normal
	CLR() { echo -e "$(clear) $@"; }  # Clear Screen
	WRN() { echo -e "/!\\ WARNING: $@ /!\\ $escape_bell"; } # "\7" = BEL = Bell Sound
	PASS() { echo -e "$@ \t [ PASS ]"; }
	FAIL() { echo -e "$@ \t [ FAIL ] $escape_bell"; }
	INFO() { echo -e "$@ \t [ INFO ]"; }
	QST()  # passed Reply to $REPLY
	{
		read -p "$(echo -e "(?) QUESTION: $@?:$escape_bell")"
	}
	QSTYN()  # passed Reply to $REPLY
	{
		read -t 30 -n 1 -p "$(echo -e "(?) QUESTION: $@? (y/n):$escape_bell")"
# 		echo " " # Creates Newline
		case $REPLY in  # Out Response
			y|Y)
				# Yes
				echo -e "  ( Yes )";;
			*) # catch all
				# No, catch all
				echo -e "  ( No )";;
		esac
	}	
	NTFY() { echo -e "$1"; synodsmnotify @administrators "Script: $2" "$(echo -e "$1")"; }
	TITLE() { echo " "; }  # Set Shell Window Title
}

# Seperation Formating, Linebreaks
BRK()
{
	if [ $@ == 1 ]; then
		YEL "################################################################"
	elif [ $@ == 2 ]; then
		BLU "****************************************************************"
	elif [ $@ == 3 ]; then
		WHT "================================================================"
	elif [ $@ == 4 ]; then
		BLU "~--------------------------------------------------------------~"
	elif [ $@ == 5 ]; then
		MAG " ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
	elif [ $@ == 6 ]; then
		BLKB "................................................................"
	elif [ $@ == 7 ]; then
		CYN "~   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   ~"
	elif [ $@ == 8 ]; then
		BLKB "________________________________________________________________"
	else
		WRN "Break Formatting ERROR [ $@ ]"
	fi
}

# Color Use Conditioning
case $@ in
	0|off|Off|OFF|no?color|No?Color|NO?COLOR|disable|Disable|DISABLE|disable?|Disable?|DISABLE?) # Disable Color
		ColorOff;;  # Include Non-Color Functions, Disable Color
	dedug|Debug|DEBUG) # For Debuging
		# Debug Mode
		ColorOn  # Include Color Functions, Enable Color
		BRK 1  # Linebreak
		
		# Color Varables
		echo -e "$color_black Black, $color_red Red, $color_green Green, $color_yellow Yellow, $color_blue Blue, $color_magenta Magenta, $color_cyan Cyan, $color_white White, $color_reset	[ Regular Colors ]"
		echo -e "$color_bold_black Black, $color_bold_red Red, $color_bold_green Green, $color_bold_yellow Yellow, $color_bold_blue Blue, $color_bold_magenta Magenta, $color_bold_cyan Cyan, $color_bold_white White, $color_reset	[ Bold Colors ]"
		echo -e "$color_underline_black Black, $color_underline_red Red, $color_underline_green Green, $color_underline_yellow Yellow, $color_underline_blue Blue, $color_underline_magenta Magenta, $color_underline_cyan Cyan, $color_underline_white White, $color_reset	[ Underlined Colors ]"
		echo -e "$color_background_black Black, $color_background_red Red, $color_background_green Green, $color_background_yellow Yellow, $color_background_blue Blue, $color_background_magenta Magenta, $color_background_cyan Cyan, $color_background_white White, $color_reset	[ Background Colors ]"
		echo -e "$color_intense_black Black, $color_intense_red Red, $color_intense_green Green, $color_intense_yellow Yellow, $color_intense_blue Blue, $color_intense_magenta Magenta, $color_intense_cyan Cyan, $color_intense_white White, $color_reset	[ High Intensity Colors ]"
		echo -e "$color_bold_intense_black Black, $color_bold_intense_red Red, $color_bold_intense_green Green, $color_bold_intense_yellow Yellow, $color_bold_intense_blue Blue, $color_bold_intense_magenta Magenta, $color_bold_intense_cyan Cyan, $color_bold_intense_white White, $color_reset	[ Bold High Intensity Colors ]"
		echo -e "$color_underlined_intense_black Black, $color_underlined_intense_red Red, $color_underlined_intense_green Green, $color_underlined_intense_yellow Yellow, $color_underlined_intense_blue Blue, $color_underlined_intense_magenta Magenta, $color_underlined_intense_cyan Cyan, $color_underlined_intense_white White, $color_reset	[ Underlined High Intensity Colors ]"
		echo -e "$color_intense_background_black Black, $color_intense_background_red Red, $color_intense_background_green Green, $color_intense_background_yellow Yellow, $color_intense_background_blue Blue, $color_intense_background_magenta Magenta, $color_intense_background_cyan Cyan, $color_intense_background_white White, $color_reset	[ Background High Intensity Colors ]"
		BRK 1  # Linebreak
		
		# Color Function
		echo -e "  ( $(BLK Black), $(RED Red), $(GRN Green), $(YEL Yellow), $(BLU Blue), $(MAG Magenta), $(CYN Cyan), $(WHT White) )	[ Regular Colors ]"
		echo -e "  ( $(BLKB Black), $(REDB Red), $(GRNB Green), $(YELB Yellow), $(BLUB Blue), $(MAGB Magenta), $(CYNB Cyan), $(WHTB White) )	[ Bold Colors ]"
		echo -e "  ( $(BLKU Black), $(REDU Red), $(GRNU Green), $(YELU Yellow), $(BLUU Blue), $(MAGU Magenta), $(CYNU Cyan), $(WHTU White) )	[ Underlined Colors ]"
		echo -e "  ( $(BLKBG Black), $(REDBG Red), $(GRNBG Green), $(YELBG Yellow), $(BLUBG Blue), $(MAGBG Magenta), $(CYNBG Cyan), $(WHTBG White) )	[ Background Colors ]"
		echo -e "  ( $(BLKI Black), $(REDI Red), $(GRNI Green), $(YELI Yellow), $(BLUI Blue), $(MAGI Magenta), $(CYNI Cyan), $(WHTI White) )	[ High Intensity Colors ]"
		echo -e "  ( $(BLKBI Black), $(REDBI Red), $(GRNBI Green), $(YELBI Yellow), $(BLUBI Blue), $(MAGBI Magenta), $(CYNBI Cyan), $(WHTBI White) )	[ Bold High Intensity Colors ]"
		echo -e "  ( $(BLKBGI Black), $(REDBGI Red), $(GRNBGI Green), $(YELBGI Yellow), $(BLUBGI Blue), $(MAGBGI Magenta), $(CYNBGI Cyan), $(WHTBGI White) )	[ Background High Intensity Colors ]"
		BRK 1  # Linebreak
		
		# Helper Functions
		WRN "Debuging & TESTING"
		PASS "Debuging & TESTING"
		FAIL "Debuging & TESTING"
		INFO "Debuging & TESTING"
		QST "Debuging & TESTING"
		echo "[$REPLY]"
		QSTYN "Debuging & TESTING"
		echo "[$REPLY]"
		
		# Formating Linebreak Functions
		BRK 1
		BRK 2
		BRK 3
		BRK 4
		BRK 5
		BRK 6
		BRK 7
		BRK 8
		
		# Output Title
		ScriptInfo_color_text_functions
		;;
	*) # catch all  ( 1|on|On|ON|color|Color|COLOR|enable|Enable|ENABLE|enable?|Enable?|ENABLE?|* )
		# Check if this script is already loaded
		if [ -z $script_loaded_color_text_functions ]; then
			# Test if Terminal can handle color
			case $TERM in  # prevent outputing color to a terminal that can not handle color
				xterm*|rxvt*) # xterm and rxvt get color
					ColorOn;;  # Include Color Functions, Enable Color
				*) # catch all for (vt100) and others, do not get color
					ColorOff;;  # Include Non-Color Functions, Disable Color
			esac
			
			# Output Title
			ScriptInfo_color_text_functions
		fi
esac

# Output Title
#NRM " ▶︎ Dependency: $(RED ${SCRIPT_NAME:0:1})$(GRN ${SCRIPT_NAME:1:1})$(YEL ${SCRIPT_NAME:2:1})$(BLU ${SCRIPT_NAME:3:1})$(MAG ${SCRIPT_NAME:4:1}) $(WHT ${SCRIPT_NAME:5}) - $(GRN "v$SCRIPT_VERSION") - $(BLU "$SCRIPT_DATE") - $(CYN "$SCRIPT_AUTHER ($SCRIPT_AUTHER_CONTACT)") \n   ∟ Description: $SCRIPT_DESCRIPTION ( $(BLKB Black), $(REDB Red), $(GRNB Green), $(YELB Yellow), $(BLUB Blue), $(MAGB Magenta), $(CYNB Cyan), $(WHTB White) )"

# Set Script Initialize Variable
script_loaded_color_text_functions=true