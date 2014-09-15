# BashDowner - RSS/HTML Feeds Aggregator Script 2011/02/25 v2.2 By: Austin Saint Aubin
# sh $(nvram get usb_tomato)/Scripts/BashDowner.sh
# ============================================================================
# Loading Dependant Functions
logIt() { echo "$@"; logger -t RSSDowner "$@"; }
checkFolder() { [ -d "$@" ] && logIt "Folder Exists: $@" || (logIt "Making Folder: $@"; mkdir -p "$@"); } #CheckFolder v3 - 2011/02/20

# Saying Script Name
logIt "RSSDowner - RSS Feeds Downloader Script"

# XFilterFileURL( FileFolderFilter ), URL and fileName are shared. Usage: XFilterFileURL "X-234 XURL-gogle XURL-gole XURL-google"
XFilterFileURL()
{
filterState="Pass"

# Run Filer if it is not NULL
if [[ -n "$1" ]]; then
i=0
#Detecting Filter Type
for ID in $1; do
let i++

if [[ ${ID:0:2} == "X-" ]]; then
filter=$(echo ${ID:2})
filterStateFile=$(checkFilter $(echo $fileName | egrep -i -v -E '('$filter')' | wc -l))
filterStateURL=$(checkFilter $(echo $URL | egrep -i -v -E '('$filter')' | wc -l))
logIt "XFilter($i): Fillter in All | Filter: $filter | FileName: $filterStateFile | URL: $filterStateURL"

if [[ $filterStateFile == "Fail" || $filterStateURL == "Fail" ]]; then
filterState="Fail"
fi

elif [[ ${ID:0:5} == "XFile" ]]; then
filter=$(echo ${ID:6})
filterStateFile=$(checkFilter $(echo $fileName | egrep -i -v -E '('$filter')' | wc -l))
logIt "XFilter($i): Fillter in File | Filter: $filter | FileName: $filterStateFile"

if [[ $filterStateFile == "Fail" ]]; then
filterState="Fail"
fi

elif [[ ${ID:0:4} == "XURL" ]]; then
filter=$(echo ${ID:5})
filterStateURL=$(checkFilter $(echo $URL | egrep -i -v -E '('$filter')' | wc -l))
logIt "XFilter($i): Fillter in URL | Filter: $filter | URL: $filterStateURL"

if [[ $filterStateURL == "Fail" ]]; then
filterState="Fail"
fi
else
logIt "   /!\\ XFilter Error /!\\"
fi
done
logIt "XFilter End State: [$filterState]"
fi
}

# Check for a Pass of Fail
checkFilter()
{
if [ "$1" == 1 ]; then
echo "Pass" 
else
echo "Fail"
fi
}

# SubDIRSetup( Name, FileFolderFilter, DIR )
SubDIRSetup()
{
subError="PASS"

# Sub Directory Setup, if it is not NULL
if [[ -n "$2" ]]; then
i=0
#Detecting Filter Type
subDIR=''
for ID in $2; do
let i++
# File Selector, Usage: "File6-2-xx", ReferenceChar - Span - Append to end of dir
if [[ ${ID:0:4} == "File" ]]; then
dirPart=${fileName:$(echo ${ID:4} | cut -d '-' -f1):$(echo ${ID:4} | cut -d '-' -f2)}$(echo ${ID:4} | cut -d '-' -f3)
subDIR=$subDIR/$dirPart
logIt "File Selector($i): Char $(echo ${ID:4} | cut -d '-' -f1) - Span $(echo ${ID:4} | cut -d '-' -f2) - Append $(echo ${ID:4} | cut -d '-' -f3) | $dirPart | $subDIR"

# URL Selector, Usage: "URL6-0-3-2", Selector - ReferenceChar - Span - 2ndSelector with delimiter "-"
elif [[ ${ID:0:3} == "URL" ]]; then
dirPart=$(echo $URL | cut -d '/' -f $(echo ${ID:3} | cut -d '-' -f1))
# 2ndSelector
if [[ -n "$(echo ${ID:3} | cut -d '-' -f4)" ]]; then
if [[ $(echo ${ID:3} | cut -d '-' -f4) != 0 ]]; then
dirPart=$(echo $dirPart | cut -d '-' -f $(echo ${ID:3} | cut -d '-' -f4))
fi
fi
# Span
if [[ -n "$(echo ${ID:3} | cut -d '-' -f3)" ]]; then
if [[ $(echo ${ID:3} | cut -d '-' -f3) != 0 ]]; then
dirPart=${dirPart:$(echo ${ID:3} | cut -d '-' -f2):$(echo ${ID:3} | cut -d '-' -f3)}
fi
fi
subDIR=$subDIR/$dirPart
logIt "URL Selector($i): Selector $(echo ${ID:3} | cut -d '-' -f1) - Char $(echo ${ID:3} | cut -d '-' -f2) - Span $(echo ${ID:3} | cut -d '-' -f3) - 2ndSelector $(echo ${ID:3} | cut -d '-' -f4) | $dirPart | $subDIR"

# Custom Dir, Usage: "DIR-CustomDIR"
elif [[ ${ID:0:3} == "DIR" ]]; then
dirPart=$(echo ${ID:4} | cut -d '-' -f1)
subDIR=$subDIR/$dirPart
logIt "File Filter($i): Custom DIR Name | $dirPart | $subDIR"

else
logIt "   /!\\ Filter ($ID) is Invalid /!\\"
fi

if [[ -z "$dirPart" ]]; then
subError="FAIL"
logIt "   /!\\ SubDIR Part Invalid, Setting to Skip file /!\\"
fi
done

logIt "Setting Up Sub Directory for $1"
subDIR=$(echo $3/$1$subDIR)
logIt "Saving to $subDIR"
checkFolder "$subDIR"
cd "$subDIR"
fi
}

# DownThis( Name, URL, DIR, SubDIR  )
DownThis()
{
logIt "URL: $2"
fileName=$(basename $2)
logIt "Filename: $fileName"

if [[ ${2:0:4} == "http" ]]; then
XFilterFileURL "$5"
if [[ $filterState == "Pass" ]]; then
# Sub Directory Setup, if it is not NULL
SubDIRSetup "$1" "$4" "$3"
if [[ $subError != "FAIL" ]]; then
[ -f $fileName ] && logIt "File already exists." || (logIt "File does not exists, Downloading it."; wget $2)
else 
logIt "Sub Dir Registered a [$subError], Skipping File"
fi
else
logIt "File Failed Filter, Skipping File."
fi
else
logIt "   /!\\ URL Invalid /!\\, Skipping File!"
fi
}

# RSSThis(Name, url, fileType, DIR, …)
RSSThis()
{
logIt "=========================================================="
logIt "[$1] Feed"

# Checking Feeds Podcast Folder to see if it is there
logIt "Checking Feeds Root Download Folder"
checkFolder "$4"
cd "$4"

logIt "=========================================================="
logIt "Parsing RSS: $1 at $2"

checkFolder "$4/$1"
cd "$4/$1"

logIt "~  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  ~"
logIt "Acquiring Header Image"
URL=$(curl --silent $2 | egrep -i -o '<url[^<]*' | grep -o '[^>]*$' | grep -E '(.gif|.png|.jpg|.svg)' )
[ -z "$URL" ] && logIt "Could not find a header image in feed." || (logIt "Feed has header image, getting it."; DownThis "$1" $URL)
lastURL="$URL"

logIt "=========================================================="
downloadFilter=$(curl --silent $2 | egrep -i -o '(url|src|href)''="[^"]*' | grep -o '[^"]*$' | egrep -i -E '\.''('$3')' )
#logIt $downloadFilter
for URL in $downloadFilter; do
if [[ "$URL" != "$lastURL" ]]; then
DownThis "$1" $URL "$4" "$5" "$6"
lastURL="$URL"
else
logIt "   /!\\ Duplicate found in feed, skipping it. /!\\"
fi
logIt "~ - - - - - - - - - - - - - - - - - - - - - - - - - - - ~"
done
logIt "Done with $1 Feed"
}

# Edit what you want bellow this line.

# ========================================================================================
#USBDrvDIR=$(nvram get usb_disk_main)
StorageUSBDrvDIR="/tmp/mnt/DS3R_1TB_1"
MediaUSBDrvDIR="/tmp/mnt/DS3R_1TB_2"
ComDIR="Podcasts"
# --------------------------------------
PodsDIR="$MediaUSBDrvDIR/$ComDIR"
ComicsDIR="$MediaUSBDrvDIR/Comics"
Revision3DIR="$MediaUSBDrvDIR/Video Series/Revision3 Videos"
DesignResorces="$StorageUSBDrvDIR/Design Resources"
DgnResInspWks="$DesignResorces/Inspiring Works of Art & Design"


# RSS Feeds List - Edit & Add as you like.
# RSSThis( "name/filename", "RSS-URL", "File Type to download", "Folder to download to", "Sub Folder Filters (File2-6 URL3-2-8 DIR-younameit) these are stackable", "XFilter (X-any XFile-infile XURL-inurl)" )
# [Comics]
RSSThis "LICD - Least I Could Do" "http://feeds.feedburner.com/LICD?format=xml" "gif" "$ComicsDIR" "File0-4"
#RSSThis "LFG - Looking For Group" "http://feeds.feedburner.com/LookingForGroup?format=xml" "gif|png|jpg" "$ComicsDIR" "File4-1-xx"
# [Audio Podcast]
RSSThis RadioLab "http://feeds.wnyc.org/radiolab" "mp3|mp4|m4v|jpg|png" "$PodsDIR"
# [Revision3 Podcast]
# RSSThis Hak5 "http://revision3.com/hak5/feed/MP4-Small" "mp4|jpg" "$Revision3DIR" "File6-2"
# RSSThis ScamSchool "http://revision3.com/scamschool/feed/MP4-Small" "mp4|jpg" "$Revision3DIR"
#RSSThis TekZilla "http://revision3.com/tekzilla/feed/MP4-Small" "mp4" "$Revision3DIR"
# RSSThis TomsTop5 "http://revision3.com/tomstop5/feed/MP4-Small" "mp4" "$Revision3DIR"
#RSSThis TheBenHeckShow "http://revision3.com/tbhs/feed/MP4-Small" "mp4|jpg" "$Revision3DIR"
# [Art Images]
# RSSThis BotanyPhotoOfTheDay "http://www.ubcbotanicalgarden.org/potd/atom.xml" "jpg|gif" "$DgnResInspWks" "URL6-0-0"
# RSSThis FlowingData.com "http://feeds.feedburner.com/FlowingData" "flv|mov|avi|mp3|mp4|m4v|jpg|png|gif" "$DgnResInspWks" "URL6-0-0 URL7-0-0" "XFile-addtomyyahoo XFile-AOLButton XURL-/themes/ XURL-weburb_thumbs XFile-wikio XFile-fbplusmo"
# RSSThis WebUrbanist.com "http://feeds.feedburner.com/weburbanist" "flv|mov|avi|mp3|mp4|m4v|jpg|png|gif" "$DgnResInspWks" "URL6-0-0 URL7-0-0" "XFile-addtomyyahoo XFile-AOLButton XURL-/themes/ XURL-weburb_thumbs XFile-wikio XFile-fbplusmo"
# RSSThis "Worth1000.com" "http://www.worth1000.com/#potd" "gif|png|jpg" "$DgnResInspWks" "" "XFile-_sqr"
# RSSThis "CurvedWhite.com" "http://curvedwhite.com/rss" "jpg|png|gif" "$DgnResInspWks"
RSSThis "Textures - Bittbox" "http://api.flickr.com/services/feeds/photos_public.gne?id=31124107@N00&lang=en-us" "jpg|png|gif" "$DesignResorces/Stock Images & Artwork"
# DesignMilk.com
# RSSThis "Design-Milk.com/Architecture" "http://feeds.feedburner.com/DesignMilkArchitecture" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/Art" "http://feeds.feedburner.com/DesignMilkArt" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/Home Furnishings" "http://feeds.feedburner.com/DesignMilkHomeFurnishings" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/Interior Design" "http://feeds.feedburner.com/DesignMilkInteriorDesign" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/News & Events" "http://feeds.feedburner.com/DesignMilkNewsEvents" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/Style & Fashion" "http://feeds.feedburner.com/DesignMilkStyleFashion" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"
# RSSThis "Design-Milk.com/Technology" "http://feeds.feedburner.com/DesignMilkTechnology" "flv|mov|avi|mp3|mp4|m4v|jpg|png" "$DgnResInspWks" "URL5-0-0 URL6-0-0"