linux-bash-scripts-core-library
===============================
This is a script that will back up all of your routers settings, logs, NVRAM data, bandwidth, web usage, sysinfo and more. It is very useful if you often make changes to your router and want the reassurance that your settings are being backed up. Their is nothing worse than doing a 30/30/30 reset and then thinking "…did I write down my settings…". Use this script if you would like to have your router back itself up to a usb storage device on a regular basis by using the scheduler.

Requirements
------------
* Router Falshed with Tomato or DD-WRT (untested)
* USB Flash Drive

Setup
-----
Log into your router: [http://192.168.1.1](http://192.168.1.1)

Navigate to [USB & NAS] -> [USB Support]
* Make sure make sure that USB support is enabled.
* Make sure your USB device appears in the attached devices.
	* Take note of its mounted location. Exp: (/tmp/mnt/usb8gb)
* Download the [linux-bash-scripts-library-core](https://github.com/AustinSaintAubin/linux-bash-scripts-library-core.git) to your USB Drive.
* Extract the archives contents to the dir on your falsh drive that you would like to use for scripts. Exp: (/mnt/usb8gb/active_system)
	* ```mkdir /mnt/usb8gb/active_system```
	* ```unzip linux-bash-scripts-library-core-master.zip -d /mnt/usb8gb/active_system```
	* ```mv /mnt/usb8gb/active_system/linux-bash-scripts-library-core-master /mnt/usb8gb/active_system/scripts```
 
### USB (Run After Mounting)
Navigate to [USB & NAS] -> [USB Support] -> Run After Mounting

```
logIt() { echo "$@"; logger -t USBMount "$@"; }

if [ -d /mnt/usb8gb ]; then
	logIt "Mounted: usb8gb"
	nvram set usb_disk=/tmp/mnt/usb8gb
	nvram set usb_disk_system=$(nvram get usb_disk)/active_system
	
	# Sync & Save Root Home Folder
	#cp -a -f "$(nvram get usb_disk_tomato)/Root Home/." "/tmp/home/root/"
	
	logIt "Mounting Optware and Apps"
	mount -o noatime -t ext3 -o bind "$(nvram get usb_disk_system)/optware" /opt
	
	# Run Internet Outage Loggin Script
	sh "$(nvram get usb_disk_system)/scripts/logging/internet_outage_logger.sh" "$(nvram get wan_gateway)" "5g"
fi
```

### Schedule
Navigate to [Administration] -> [Scheduler]

```
# Run System Backups
# Do different backups on certain days of the month
if [ "Sun" == "$(date +%a)" ]; then
	sh "$(nvram get usb_disk_system)/scripts/backup/backup_router_tomato.sh" full
else
	sh "$(nvram get usb_disk_system)/scripts/backup/backup_router_tomato.sh"
fi

# Backup Mounted Drives to NAS
#logIt "Running a Full Backup of USB Drives (Custom Scheduled 1)"
#rm -f "/cifs1/Tomato Router/tomato.tar.gz"
#tar -cvzf "/cifs1/Tomato Router/tomato.tar.gz" "/tmp/mnt"

# Backup to NAS
#rsync -az ./path server2:/destination/
#rsync --archive --ipv6 --log-file="" --rsh="ssh -y -i /home/root/.ssh/id_rsa" \
#"/mnt/" rsync@nas:'"/volume1/NetBackup/Tomato Router - Flash Drive/"'
```

Usage
-----
* Run Standard (Default) Backup:
	* ``sh "$(nvram get usb_disk_system)/scripts/backup/backup_router_tomato.sh"``
* Run Full Backup:
	* ``sh "$(nvram get usb_disk_system)/scripts/backup/backup_router_tomato.sh" full``
* Run Limited Backup:
	* ``sh "$(nvram get usb_disk_system)/scripts/backup/backup_router_tomato.sh" limited``

Tips
----
But everything that you are planning on running on your tomato router from the USB drive in a folder on the root of your USB drive called active_system. Exp: (/mnt/usb8gb/active_system)

Backups will save by default to a folder called backups on the root of your flash drive. Exp: (/mnt/usb8gb/backups)
