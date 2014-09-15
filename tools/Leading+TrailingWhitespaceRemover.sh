# Leading & Trailing Whitespace Remover Script - v1.2 - 2011/04/03
# By: Austin St. Aubin
# Leading+TrailingWhitespaceRemover.sh ( "SourceRoot", "color/nocolor", "dstLogFileName" )
# sh $(nvram get usb_disk_main)/Tomato/Leading+TrailingWhitespaceRemover.sh "/tmp/mnt/300GB_EXT3/Design Resources-Backup" "color"

# "/tmp/mnt/DS3R_1TB_1/Design Resources" 
DestinationRoot="$1"

if [[ -n "$2" ]]; then
outputType="$2"

else
outputType="color"
#outputType="nocolor"
#outputType="log"
echo "Setting outputType Default: $outputType"
fi

if [[ -n "$3" ]]; then
dstLogFileName="$3"

else
dstLogFileName="Leading+TrailingWhitespaceRemoverLog.txt"
echo "Setting dstLogFileName to Default: $dstLogFileName"
fi

# DigRemoveLeading( SourceRoot  )
DigRemoveLeading()
{
cd  "$1"
say "$(RED "Removing") $(MAG "Leading") $(WHT "Whitespace") $(BLK "( Spaces / Tabs )")"
find -name " *" | sed -e 's/\.*//' | while read fileName; do
newFileName="$(echo $fileName | sed 's/\/[ \t]/\//')"
say "$(YEL "Found: $1$fileName")"
say "$(BLK "Src: \"$fileName\"")   $(BLU ">")   $(BLK "Dst: \"$newFileName\"")"
mv "$1$fileName" "$1$newFileName"
done
say "Leading $(WHT "Whitespace") Remover $(GRN "Done")"
}
# DigRemoveTrailing( SourceRoot  )
DigRemoveTrailing()
{
cd  "$1"
say "$(RED "Removing") $(CYN "Trailing") $(WHT "Whitespace") $(BLK "( Spaces / Tabs )")"
find -name "* " | awk '{print $0 "\b"}' | sed -e 's/\.*//' | while read fileName; do
newFileName="$(echo "$fileName" | tr -d '\b' | sed 's/[ \t]$//')"
say "$(YEL "Found: $1$fileName")"
say "$(BLK "Src: \"$fileName\"")   $(BLU ">")   $(BLK "Dst: \"$newFileName\"")"
mv "$1$(echo "$fileName" | tr -d '\b')" "$1$newFileName"
done
say "Trailing $(WHT "Whitespace") Remover $(GRN "Done")"
}

# LogPrepair(  )
LogPrepair()
{
say "$(GRN "Setting up Log File:") $(BLK "$DestinationRoot/$dstLogFileName")"
#say "$(RED "Deleting Log File:") $(BLK "$DestinationRoot/$dstLogFileName")"
#rm -f "$DestinationRoot/$dstLogFileName"
checkFolder "$DestinationRoot"
say "$(GRN "Creating Log File:") $(WHT "$DestinationRoot/$dstLogFileName")"
echo "# Leading & Trailing Whitespace Remover Script by: Austin Saint Aubin" >> "$DestinationRoot/$dstLogFileName"
echo "# Generat Started: $(date '+DATE: %m/%d/%y TIME: %r')" >> "$DestinationRoot/$dstLogFileName"
echo "" >> "$DestinationRoot/$dstLogFileName"
say "================================================================================"
}

# Say( "Your Text" )
# COLOR( "Your Text" )
if [ $outputType = "color" ]; then
say()
{
# Version 4.1 - 2011/03/08 - By: Austin Saint Aubin
# Colors: "$(BLK Black), $(RED Red), $(GRN Green), $(YEL Yellow), $(BLU Blue), $(MAG Magenta), $(CYN Cyan), $(WHT White)"
# Usage: (say "THE OUTPUT [green]TEXT) THAT YOU [blue]TO)WANT TO OUTPUT")
# Colors

#This sets the defalf color ), and the end color
default="\\033[0m"

# Echo output for shell
echo "$@"

# Logger output for logs
logger -t Saying "$(echo $@ | tr -d '\e' | sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?(;[0-9]{1,2})?)m//g")"

# Log File output for logs
#echo "$(echo $@ | tr -d '\e' | sed -r "s/\[([0-9]{1,2}(;[0-9]{1,2})?(;[0-9]{1,2})?)m//g")" >> "$DestinationRoot/$dstLogFileName"

#exit 0
}
BLK() { echo -e "\033[30;40;1m$@\033[0m"; }
RED() { echo -e "\033[31;40;1m$@\033[0m"; }
GRN() { echo -e "\033[32;40;1m$@\033[0m"; }
YEL() { echo -e "\033[33;40;1m$@\033[0m"; }
BLU() { echo -e "\033[34;40;1m$@\033[0m"; }
MAG() { echo -e "\033[35;40;1m$@\033[0m"; }
CYN() { echo -e "\033[36;40;1m$@\033[0m"; }
WHT() { echo -e "\033[37;40;1m$@\033[0m"; }
WRN() { echo -e "\033[31;40;1m/\033[33;40;1m!\033[31;40;1m\\ \033[33;40;1mWARNING:\033[37;40;1m $@ \033[31;40;1m/\033[33;40;1m!\033[31;40;1m\ \\033[0m"; }
elif [ $outputType = "nocolor" ]; then
say()
{
# Echo output for shell
echo "$@"

# Logger output for logs
logger -t Saying "$@"

# Log File output for logs
#echo "$@" >> "$DestinationRoot/$dstLogFileName"

#exit 0
}
BLK() { echo -e "$@"; }
RED() { echo -e "$@"; }
GRN() { echo -e "$@"; }
YEL() { echo -e "$@"; }
BLU() { echo -e "$@"; }
MAG() { echo -e "$@"; }
CYN() { echo -e "$@"; }
WHT() { echo -e "$@"; }
WRN() { echo -e "$@"; }
elif [ $outputType = "log" ]; then
say()
{
# Logger output for logs
logger -t Saying "$@"

# Log File output for logs
echo "$@" >> "$DestinationRoot/$dstLogFileName"

#exit 0
}
BLK() { echo -e "$@"; }
RED() { echo -e "$@"; }
GRN() { echo -e "$@"; }
YEL() { echo -e "$@"; }
BLU() { echo -e "$@"; }
MAG() { echo -e "$@"; }
CYN() { echo -e "$@"; }
WHT() { echo -e "$@"; }
WRN() { echo -e "$@"; }

# Call LogPrepair Function
LogPrepair
else
echo "/!\\ You need to set the outputType /!\\"
say()
{
echo "/!\\ You need to set the outputType for Say Function Starter /!\\"
echo "$@"
logger -t Saying "$@"

#exit 0
}
fi

checkFolder() { [ -d "$@" ] && say "$(BLU "Folder Exists: $@")" || (say "$(MAG "Making Folder: $@")"; mkdir -p "$@"); } #CheckFolder v3 - 2011/02/20

say "$(GRN "Running Leading/Trailing") $(WHT Whitespace) $(GRN "Remover") on: $(BLK "$1")"
say "= - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - ="
DigRemoveLeading "$1"
say "~ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
DigRemoveTrailing "$1"
say "Leading/Trailing $(WHT "Whitespace") Remover $(GRN "Done")"