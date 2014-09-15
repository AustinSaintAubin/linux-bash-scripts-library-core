# Creates Password less Login for Max OS X on most linux systems
# Written 2013/05/01   By: Austin Saint Aubin
# sh $(nvram get usb_tomato)/Scripts/BashDowner.sh
# ============================================================================
# http://www.noah.org/wiki/SSH_public_keys
# http://nerderati.com/2011/03/simplify-your-life-with-an-ssh-config-file/
# ============================================================================
# Warning: it's important to copy the key exactly without adding newlines or whitespace. Thankfully the pbcopy command makes it easy to perform this setup perfectly.

# == [ Build Keys ] ================================================
read -t 30 -n 1 -p "Build New Key on Client (y/n): "
case $REPLY in
	[Yy]* ) YEL "Building New Key"; ssh-keygen -t rsa; cat ~/.ssh/id_rsa.pub; break;; # On client (Mac OS X): On you host computer (not the diskstation) open a terminal and run the following command: ssh-keygen -t rsa -C "your_email@youremail.com"
	[Nn]* ) BLK "Using Current Key"; break;;
        * ) RED "Please answer (y/n).";;
esac

# Pause and wait
read -t 60 -n 1 -p "Press any key to continue…(60 sec timeout)"

# == [ Send Keys to Server / NAS ] ================================================
# Adds a clients id_rsa.pub to authorized_keys for user on NAS

read -p "Server Hostname or IP: "
SERVER="$REPLY"
read -p "Username on \"$SERVER\": "
USERNAME="$REPLY"

# [ These run from workstation and connect to server ]
# On NAS: You need to create a directory with a file containing the the authorized keys of clients being able to connect.
# On NAS: Copy the content of your id_rsa.pub file from your Host-computer (the one you want to connect from) into the authorized_keys file.
# On NAS: Change the file permissions of the authorized-key file.
cat ~/.ssh/id_rsa.pub | ssh $USERNAME@$SERVER 'mkdir ~/.ssh; touch ~/.ssh/authorized_keys; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 644 ~/.ssh/authorized_keys; echo "========================"; cat ~/.ssh/authorized_keys; echo "========================";'

# Pause and wait
read -t 60 -n 1 -p "Press any key to exit…(60 sec timeout)"






exit # Exit Above Script
# ================================
# On Tomato Router (So router can SSH into other devices)
SERVER="nas"
USERNAME="AustinSaintAubin"
dropbearkey -t rsa -f ~/.ssh/id_rsa  # Tomato has to have a simpler key, generate keys with dropbearkey
cat ~/.ssh/id_rsa.pub | ssh $USERNAME@$SERVER 'mkdir ~/.ssh; touch ~/.ssh/authorized_keys; cat >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 644 ~/.ssh/authorized_keys; echo "========================"; cat ~/.ssh/authorized_keys; echo "========================";'
# ssh -y -i /tmp/mnt/usb8gb/active_system/ssh/id_rsa AustinSaintAubin@nas 'echo hello'



# Permission problems with SSH
# ssh is very picky about permissions on the ~/.ssh directory and files. Sometimes you may do something to mess up these permissions. Run the following to fix most permissions problems. You may have to do this on both the remote host and local host.
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub  
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts

# SSH key fingerprint
# Some tools will store public keys and then refer to them by their fingerprint. If you don't know the fingerprint to your own key then this can be confusing. This command will show the fingerprint of your default public key:
ssh-keygen -lf ~/.ssh/id_rsa.pub
ssh-keygen -lf ~/.ssh/id_dsa.pub






# Here is my problem when trying to make an ssh connection from an access point to a remote server with key authentification :
# ssh -i key user@remote_server
# ssh: exited: string too long
# What does it mean ?
# Best regards.
# 2 amokk 2008-03-23 20:42:31
# Member
# Offline
# Registered: 2008-03-23
# Posts: 1
# Try generate keys with dropbearkey
dropbearkey -t rsa -f ~/.ssh/id_rsa