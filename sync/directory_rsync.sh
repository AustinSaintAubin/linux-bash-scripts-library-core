#!/bin/sh
# Synology Directory Synchronization Service using RSync - 2014/08/28 - v1.0.0 - Written By: Austin Saint Aubin"
#  ∟ Description: Sync the changes of SORUCE DIR with DEST DIR using RSync"
# Link to this Script: 
# -------------------------------------------------------------------------------------------------
# General Usage: sh "/volume1/active_system/scripts/directory_rsync.sh"
# =================================================================================================
# Notes:
#	
# =================================================================================================
# [# Global Variables #]
dir_source="/volume1/video/YouTube Videos/"
dir_dest="/volume1/web/videos/YouTube/"

# [# Included Library's & Scripts #]

# [# Functions #]

# [# Main Program #] --------------------------------------------------------------------------------------

# Sync Source to Destination
# rsync -vrt --delete --exclude="@eaDir" --exclude=".htaccess" --exclude="_h5ai*" --exclude="video.php" "$dir_source" "$dir_dest" --dry-run
rsync -rt --delete --exclude="@eaDir" --exclude=".htaccess" --exclude="_h5ai*" --exclude="video.php" "$dir_source" "$dir_dest"

# Fix Permissions
chmod -R 755 "$dir_dest"