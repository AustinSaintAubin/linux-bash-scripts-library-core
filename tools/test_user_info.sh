# export PATH=/opt/bin:/opt/sbin:$PATH
# "/volume1/Projects Resources/Synology NAS/Scripts/test_user_info.sh" > "/volume1/Projects Resources/Synology NAS/Scripts/test_user_info-log.txt"
# ==========================================================
echo "Testing: $(date)"
echo "PATH: $PATH"
echo "PS1: $PS1"
echo "whoami: $(whoami)"
echo "----------------------------"
echo "Current Directory"
pwd
echo "----------------------------"
echo "Current Directory Contents"
ls -la
echo "----------------------------"
echo "Home Directory"
cd ~
pwd
echo "----------------------------"
echo "Home Directory Contents"
cd ~
ls -la
echo "----------------------------"
echo IPKG List: $(ipkg list)