# LICD Serialized Downloader By Date - 2011/06/09 - v3 - By: Austin Saint Aubin
# sh "/volume1/active_system/system_scripts/downloaders/LICD-Serialized_Downloader.sh"
# ===============================================
#URL=http://cdn.leasticoulddo.com/comics/20110124.gif
#URL=http://www.leasticoulddo.com/wp-content/uploads/2013/11/20131126.gif
NAME="LICD - Least I Could Do"
URL=http://www.leasticoulddo.com/wp-content/uploads/
#fileTypes="jpg|png|gif"
fileTypes="gif"
startYear=2003
startMonth=01
startDay=23
endYear=2013
endMonth=12
endDay=34
# ======================
#FlashDrvDIR=$(nvram get usb_disk_main)
#ComDIR="Podcasts"
#PodsDIR="$FlashDrvDIR/$ComDIR"
PodsDIR="/volume1/Photo/Comics/"

# Loading Functions for Castget Loader
logIt() { echo "$@"; }  # logIt() { echo "$@"; logger -t RSSDowner "$@"; }
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
	while [ $MONTH -le 12 ]; do
		#checkFolder "$PodsDIR/$NAME/$(printf "%.4d" $YEAR)/$(printf "%.2d" $MONTH)"
		#cd "$PodsDIR/$NAME/$(printf "%.4d" $YEAR)/$(printf "%.2d" $MONTH)"

		if [ -z $DAY ]; then
			DAY=$startDay
		else
			DAY=01
		fi
		while [ $DAY -le 32 ]; do
			#fileName=licd_$(printf "%.4d" $YEAR)$(printf "%.2d" $MONTH)$(printf "%.2d" $DAY).gif
			fileName=$(printf "%.4d" $YEAR)$(printf "%.2d" $MONTH)$(printf "%.2d" $DAY).gif
			
			logIt "Year: $YEAR"
			logIt "Month: $MONTH"
			logIt "Day: $DAY"
			logIt "~ - - - - - - - "
			logIt "Folder: $Folder"
			logIt "FileName: $fileName"
			
			#[ -f $fileName ] && logIt "File already exists." || (logIt "File does not exists, Downloading it."; FullURL=$(curl --silent $URL$NUM | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$fileTypes')' | grep -i "comic" ); echo $FullURL; wget -O $fileName $FullURL)
			if [ -f $fileName ]; then
				logIt "File already exists."
			else
				logIt "File does not exists, Downloading it."
				FullURL="$URL$(printf "%.4d" $YEAR)/$(printf "%.2d" $MONTH)/$fileName"

					logIt URL: $URL$YEAR$MONTH$DAY
					logIt Download URL: $FullURL
					#echo Download URL: $FullURL
					wget "$FullURL"
			fi
			
			let DAY++
			logIt "~------------------------------------------"
		done
		let MONTH++
	done
	let YEAR++
done