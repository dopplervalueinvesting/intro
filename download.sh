#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ $( id -u ) -eq 0 ]; then
	echo "You must NOT be root to run this script."
	exit 2
fi

# Get your username (not root)
UNAME=$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)
DIR_DOPPLER=/home/$UNAME/doppler

# This is the script that downloads the remaining repositories for the Doppler Value Investing Calculator.



get_rep ()
	{
	if [ -d $DIR_DOPPLER/$1 ]; then
		echo "Repository $1 already present."
	else
		cd $DIR_DOPPLER
		git clone git@github.com:dopplervalueinvesting/$1.git
	fi
	return 0
	}
	
echo
echo "PREPARING TO DOWNLOAD REPOSITORIES"
echo
echo "Requesting and saving your password"
# From http://info.solomonson.com/content/setting-ssh-agent-ask-passphrase-only-once
# Start up ssh-agent to save your password.
# This allows you to download all repositories while entering your password just once.
tempfile=/tmp/ssh-agent.test
 
#Check for an existing ssh-agent
if [ -e $tempfile ]
then
    echo "Examining old ssh-agent"
    . $tempfile
fi
 
#See if the agent is still working
ssh-add -l > /dev/null
 
#If it's not working yet, just start a new one.
if [ $? != 0 ]
then
    echo "Old ssh-agent is dead..creating new agent."
 
    #Create a new ssh-agent if needed
    ssh-agent -s > $tempfile
    . $tempfile
 
    #Add the key
    ssh-add
fi    
 
#Show the user which keys are being used.
ssh-add -l

# ssh-agent is now implemented.  Now it's time to download all repositories.
echo "BEGIN OBTAININING REPOSITORIES"

# Get repositories for Regular Swift Linux
get_rep input
get_rep output
get_rep calc


echo "FINISHED DOWNLOADING REPOSITORIES"
echo "Deleting your password"

rm -r /tmp/ssh* # Delete the saved password

exit 0
