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

function githubdownload {
	echo
	if [ -f githubtools.lst ]; then
		for gitrepo in `cat githubtools.lst`
		do
			repo_name=`sed 's|https://github.com/.*/||' <<< $gitrepo`
			sanitized=`sed 's|\.git||' <<< $repo_name`
			
			if [ -f gitskip.lst ]; then
				for skipped in `cat gitskip.lst`
				do
					if [ $skipped == $sanitized ]; then
						echo
						echo "You dont want $sanitized updated/downloaded! I'll skip it!"
					else
						download_upgrade
					fi
				done
			else
				download_upgrade
			fi
		done
	else
		echo
		echo "Can't find the tools list! Can't download!"
		echo "Make sure the file githubtools.lst is in the same working directory as this script!"
	fi
}

function download_upgrade {
        if [ -d "/opt/$sanitized" ]; then
                echo
                echo "Updating $sanitized ..."
                cd /opt/$sanitized
                git pull
        else
                echo
                echo "Downloading $sanitized .."
                git -C /opt/ clone $gitrepo
        fi
}

main () {
	banner
	echo
	echo "I will attempt to download/update the tools from github, this might take a while..."
	githubdownload
	echo
	echo "Happy hunting!"
}

main
