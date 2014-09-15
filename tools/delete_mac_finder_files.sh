echo "Delete MAC Finder (.DS_Store, .Trashes, .TemporaryItems,  and ._resources)"
#find -name ".DS_Store" -name ".Trashes" -name "._*" -name ".TemporaryItems"

#find -name ".DS_Store"
#find -name ".Trashes"
#find -name "._*"
#find -name ".TemporaryItems"

find /mnt/ -name ".DS_Store" -exec rm -f -r "{}" \;
find /mnt/ -name ".Trashes" -exec rm -f -r "{}" \;
#find /mnt/ -name "._*" -exec rm -f -r "{}" \;
find /mnt/ -name ".TemporaryItems" -exec rm -f -r "{}" \;