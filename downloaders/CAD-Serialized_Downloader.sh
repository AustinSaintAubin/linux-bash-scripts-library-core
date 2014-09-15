# CAD Serialized Downloader By Date - 2011/06/09 - v4 - By: Austin Saint Aubin
# sh "$(nvram get usb_disk_main)/Tomato/Scripts/Downloaders/CAD-Serialized_Downloader.sh"
# ===============================================
#URL=http://www.cad-comic.com/cad/20021023
NAME="CAD - Ctrl+Alt+Del"
URL=http://www.cad-comic.com/cad/
fileTypes="png|jpg|gif"
URLFilerFind="comics"
startYear=2002
startMonth=10
startDay=23
endYear=2011
endMonth=06
endDay=10
# ======================
#FlashDrvDIR=$(nvram get usb_disk_main)
#ComDIR="Podcasts"
#PodsDIR="$FlashDrvDIR/$ComDIR"
PodsDIR="/volume1/Photo/Comics/"

# Loading Functions for Castget Loader
logIt() { echo "$@"; logger -t CAD-Downer "$@"; }
checkFolder() { [ -d "$1" ] && logIt "Folder Exsits: $1" || (logIt "Making Folder: $1"; mkdir -p "$1"); }

checkFolder "$PodsDIR/$NAME"
cd "$PodsDIR/$NAME"

logIt "Starting Serialized Downloader By Date"
logIt "============================"
logIt "Name:" $NAME
logIt "URL:" $URL
logIt "============================"
logIt "Start Year:" $startYear
logIt "End Year:" $endYear
logIt "Start Month:" $startMonth
logIt "End Month:" $endMonth
logIt "Start Day:" $startDay
logIt "End Day:" $endDay
logIt "============================"

YEAR=$startYear
while [ $YEAR -le $endYear ]; do
	Folder="$PodsDIR/$NAME/$(printf "%.4d" $YEAR)"
	checkFolder "$Folder"
	cd "$Folder"
	
	if [ -z $MONTH ]; then
		MONTH=$startMonth
	else
		MONTH=01
	fi
	# while [ $MONTH -le $endMonth ]; do
	while [ $MONTH -le 12 ]; do
		#checkFolder "$PodsDIR/$NAME/$(printf "%.4d" $YEAR)/$(printf "%.2d" $MONTH)"
		#cd "$PodsDIR/$NAME/$(printf "%.4d" $YEAR)/$(printf "%.2d" $MONTH)"

		if [ -z $DAY ]; then
			DAY=$startDay
		else
			DAY=01
		fi
		# while [ $DAY -le $endDay ]; do
		while [ $DAY -le 32 ]; do
			fileName=cad-$(printf "%.4d" $YEAR)$(printf "%.2d" $MONTH)$(printf "%.2d" $DAY)
			logIt "Year: $(printf "%.4d" $YEAR)"
			logIt "Month: $(printf "%.2d" $MONTH)"
			logIt "Day: $(printf "%.2d" $DAY)"
			logIt "~ - - - - - - - "
			logIt "Folder: $Folder"
			logIt "FileName: $fileName*"
			
			#[ -f $fileName ] && logIt "File already exists." || (logIt "File does not exists, Downloading it."; FullURL=$(curl --silent $URL$NUM | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$fileTypes')' | grep -i "comic" ); echo $FullURL; wget -O $fileName $FullURL)
			#if [ -f "$fileName" ]; then
			if [ $(find -name "$fileName*") ]; then
				logIt "File already exists."
			else
				logIt "File does not exists, Downloading it."
				FullURL=$(curl --silent $URL$(printf "%.4d" $YEAR)$(printf "%.2d" $MONTH)$(printf "%.2d" $DAY) | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$fileTypes')' | grep -i "$URLFilerFind" )
				
				if [ $FullURL ]; then 
					logIt URL: $URL$(printf "%.4d" $YEAR)$(printf "%.2d" $MONTH)$(printf "%.2d" $DAY)
					logIt Download URL: $FullURL
					# wget -U "Firefox" -O "$fileName" "$FullURL"
					wget -U "Firefox" "$FullURL"
				else
					logIt "No downloadable content found"
				fi
			fi
			
			let DAY++
			logIt "------------------------------------------"
		done
		let MONTH++
	done
	let YEAR++
done