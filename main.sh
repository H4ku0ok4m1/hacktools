#!/bin/bash

banner () {
        echo "==============================================================="
        echo
        echo "      Common hacking tools download, install and update"
        echo
        echo
        echo
        echo "    Special thanks to everyone who actually made the tools"
        echo
        echo "==============================================================="
}

function git_Download {
        echo
	if [ -f githubtools.lst ]; then
		if [ -f gitskip.lst ]; then
			echo "The blacklist file is found, partial download/update."
			for GITREPO in `cat githubtools.lst`
			do
				REPO_NAME=`sed 's|https://git.*.com/.*/||' <<< $GITREPO`
				SANITIZED=`sed 's|\.git||' <<< $REPO_NAME`
                                if grep -Fxq "$SANITIZED" $SCRIPTPATH/gitskip.lst; then
										echo
                                        echo "$SANITIZED is in the list, won't do anything"
                                else
                                        download_Upgrade
                                fi
			done
		else
			echo "No gitskip.lst file found, downloading/updating everything in the list."
			for GITREPO in `cat githubtools.lst`
			do
				REPO_NAME=`sed 's|https://github.com/.*/||' <<< $GITREPO`
				SANITIZED=`sed 's|\.git||' <<< $REPO_NAME`
				download_Upgrade
			done
		fi
	else
		echo
		echo "Can't find the tools list! Can't download!"
		echo "Make sure the file githubtools.lst is in the same working directory as this script!"
	fi
}

function download_Upgrade {
        if [ -d "/opt/$SANITIZED" ]; then
                echo
                echo "Updating $SANITIZED ..."
                cd /opt/$SANITIZED
                git pull
        else
                echo
                echo "Downloading $SANITIZED .."
                git -C /opt/ clone $GITREPO
        fi
}

function update_Os {
        sudo apt update && sudo apt upgrade -y
}


main () {
        SCRIPTPATH=`pwd`
        banner
        echo "Checking internet connection."
        ping -c1 google.com > /dev/null 2>&1
      	if [ "$?" != 0 ]; then
      		      echo "No internet! Check your connection!"
      	else
      		      echo "You have connection, continue..."
                echo
                echo "I will first update the system, please wait."
                update_Os
                echo
                echo "I will attempt to download/update the tools from github, this might take a while..."
                git_Download
                echo
                echo "Happy hunting!"
      	fi
}

main
