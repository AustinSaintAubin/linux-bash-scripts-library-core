# LFG Serialized Downloader - 2011/04/26 - v3 - By: Austin Saint Aubin
# ===============================================
# sh "/volume1/Archives/System Scripts/downloaders/LFG-Serialized_Downloader.sh"
#URL=http://lfgcomic.com/page/460
NAME="LFG - Looking For Group2"
URL="http://lfgcomic.com/page/"
startNum=0001
endNum=0800
fileTypes="jpg|png|gif"
# ======================
FlashDrvDIR=$(nvram get usb_disk_main)
#ComDIR="Podcasts"
#PodsDIR="$FlashDrvDIR/$ComDIR"
PodsDIR="/volume1/Photo/Comics/"


# Loading Functions
logIt() { echo "$@"; logger -t SerializedDowner "$@"; }
checkFolder() { [ -d "$@" ] && logIt "Folder Exists: $@" || (logIt "Making Folder: $@"; mkdir -p "$@"); } #CheckFolder v3 - 2011/02/20

checkFolder "$PodsDIR/$NAME"
cd "$PodsDIR/$NAME"

echo "Starting Serialized Downloader By Number"
echo "============================"
echo "Name:" $NAME
echo "URL:" $URL
echo "============================"
echo "Start Num:" $startNum
echo "End Num:" $endNum
echo "============================"

NUM=$startNum
while [ $NUM -le $endNum ]; do
	NUMZero=$(printf "%04d" $NUM)
	numMask=${NUMZero:1:1}xx
	echo "FolderIndex: $numMask"
	echo "FileIndex:   $NUMZero"

	checkFolder "$PodsDIR/$NAME/$numMask"
	cd "$PodsDIR/$NAME/$numMask"
	echo "FilePath: $PodsDIR/$NAME/$numMask"

	fileName="lfg"$(printf "%.4d" $NUM)".gif"
	echo "FileName: $fileName"
	
	[ -f $fileName ] && logIt "File already exists." || (logIt "File does not exists, Downloading it."; FullURL=$(curl --silent $URL$NUM | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$fileTypes')' | grep -i "comic" ); echo $FullURL; wget -O $fileName $FullURL)
	let NUM++
	echo "------------------------------------------"
done