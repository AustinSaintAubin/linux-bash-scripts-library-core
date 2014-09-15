# check if hidden files are visible and store result in a variable
STATUS=`defaults read com.apple.finder AppleShowAllFiles`

# toggle visibility based on variables value
if [ $STATUS == YES ]; 
then
    defaults write com.apple.finder AppleShowAllFiles NO
else
    defaults write com.apple.finder AppleShowAllFiles YES
fi

# force changes by restarting Finder
killall Finder