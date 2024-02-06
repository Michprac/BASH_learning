#!/bin/bash

# This script is going to be used for disabling a local user.

usage_msg() {
	echo "Usage COMMAND [-r] [-a] USERNAME"
	echo
	echo "Disable, delete or archive a local user's account."
	echo
	echo "Options:"
	echo "-d 	Delete an account instead of disabling"
	echo "-r 	use for removing the home directory associated with the account"
	echo "-a 	use for  creating an archive of the home directory associated with the account and stores the archive in the /archives directory."
	exit 1
}

# Checking if the script was running as a root.
if [[ ${UID} -ne 0 ]]
then
	echo "Please run the script with root privileges." >&2
	exit 1
fi

# By default the command desables an account
DELETE_DISABLE_OPTION='disable'

# Processing of different scenarios
while getopts "dra" OPTION
do
	case ${OPTION} in
		d)
			DELETE_DISABLE_OPTION='delete'
			echo "Deleting has chosen"
			
			;;
		r)
			REMOVE_OPTION='true'
			echo "Removing has chosen"
			;;
		a)
			ARCHIVE_OPTION='true'
			echo "Archiving has chosen"
			;;
		?)
			usage_msg
			;;
	esac
done

# Deleting options and leaving other arguments.
shift $(( OPTIND - 1 ))

# Checking if there is a USERNAME arguments
if [[ "${#}" -eq 0 ]]
then
	echo "You haven't supplied a USERNAME of the account" >&2
	usage_msg
fi

# Getting USERNAME
USERNAME="${*}"

# Deleting/disabling a user account and refuse if the UID is less then 1000  Option -d
# Only system aacounts should be modified.
if [[ $(id -u ${USERNAME}) -lt 1000 ]]
then
	echo "You can't disabling or deleting system accounts." >&2
	exit 1
else
	if [[ ${DELETE_DISABLE_OPTION} = 'disable' ]]
	then
		chage -E 0 ${USERNAME}
	else
		userdel "${USERNAME}"
	fi
fi

# Check if the user account was disabled/deleted and display info
if [[ "${?}" -ne 0 ]]
then
	echo "The account wasn't deleted/disabled." >&2
	exit 1
fi

echo "The account for ${USERNAME} was disabled/deleted."

# Removing the home directory associated with the account. Option -r
if [[ REMOVE_OPTION = 'true' ]]
then
	userdel -r "${USERNAME}"
	
	# Checking if the home directory was deleted.
	if [[ "${?}" -eq 0 ]]
	then
		echo "The account and home directory were deleted."
	else
		echo "The account and home directory were NOT deleted."
	fi
fi

# Creating an archive. Option -a
if [[ ARCHIVE_OPTION = 'true' ]]
then
	# Checking if there is an /archives directory.
	locate ./archives
	if [[ "${?}" -ne 0 ]]
	then
		mkdir archives
	fi

	# Creating an archive
	cd /archives
	tar -c -f "${USERNAME}_archive.tar" "/home/${USERNAME}"

	# Check if the user account was archived and display info
	if [[ "${?}" -ne 0 ]]
	then
		echo "The account wasn't archived." >&2
		exit 1
	else
		echo "The account for the ${USERNAME} was archived."
	fi
fi

exit 0