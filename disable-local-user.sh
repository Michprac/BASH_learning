#!/bin/bash

# This script is can be used for disabling, deleting or archiving users on the local system.

ARCHIVE_DIR='/archive'

# Function for displaying usage message.
usage_msg() {
	echo "Usage ${0} [-dra] USERNAME [USERNAMEN]..." >&2
	echo "Disable a local user account." >&2
	echo "Options:" >&2
	echo "-d 	Deletes accounts instead of disabling." >&2
	echo "-r 	Removes the home directory associated with the account(s)." >&2
	echo "-a 	Creates an archive of the home directory associated with the account(s)." >&2
	exit 1
}

# Function for checking if the command was performed successfully.
check_cmd(){
	local MESSAGE_FALSE="${1}"
	local MESSAGE_TRUE="${2}"
	if [[ "${?}" -ne 0 ]]
	then
		echo "${MESSAGE}" >&2
		exit 1
	else
		echo "${MESSAGE_TRUE}"
	fi
}



# Checking if the script was running with a super privileges.
if [[ ${UID} -ne 0 ]]
then
	echo "Please run the script with sudo or root privileges." >&2
	exit 1
fi


# Parsing of different scenarios
while getopts "dra" OPTION
do
	case ${OPTION} in
		d)
			DELETE_OPTION='true'
			echo "Deleting has chosen"
			;;
		r)
			# If the user will choose this option the variable REMOVE_OPTION wouldn't be empty.
			REMOVE_OPTION='-r'
			echo "Removing home directory has chosen"
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
shift "$(( OPTIND - 1 ))"

# Checking if there is a USERNAME arguments
if [[ "${#}" -eq 0 ]]
then
	echo "You haven't supplied a USERNAME of the account" >&2
	usage_msg
fi

# Loop through all the USERNAMEs supplied as arguments.
for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"
	
	# Make sure the UID of account is at least 1000. 
	# Only system aacounts should be modified.
	USERID=$(id -u ${USERNAME})
	if [[ "${USERID}" -lt 1000 ]]
	then
		echo "Refusing to remove the ${USERNAME} account with UID ${USERID}." >&2
		exit 1
	fi
	
	# Create an archive if requested to do so. Option -a
	if [[ "${ARCHIVE_OPTION}" = 'true' ]]
	then
		# Make sure the ARCHIVE_DIR directory exists.
		if [[ ! -d "${ARCHIVE_DIR}" ]]
		then
			echo "Creating ${ARCHIVE_DIR} directory."
			mkdir -p ${ARCHIVE_DIR}
			check_cmd "The archive directory ${ARCHIVE_DIR} could not be created." "The archive directory ${ARCHIVE_DIR} was created."
		fi
		
		# Archive the user's home directory and move it into the ARCHIVE_DIR
		HOME_DIR="/home/${USERNAME}"
		ARCHIVE_FILE="${ARCHIVE_DIR}${USERNAME}.tgz"
		if [[ -d "${HOME_DIR}" ]]
		then
			echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
			tar -zcf "${ARCHIVE_FILE}" "${HOME_DIR}" &> /dev/null
			check_cmd "Could not create ${ARCHIVE_FILE}." "The ${ARCHIVE_FILE} was created."
		else
			echo "${HOME_DIR} does not exist or is not a directory." >&2
			exit 1
		fi
	fi
	
	# Delete user. Option -d
	if [[ "${DELETE_OPTION}" = 'true' ]]
	then
		# Delete the user
		userdel ${REMOVE_OPTION} ${USERNAME}
		
		# Check to see if the userdel was ran successfully
		check_cmd "The account ${USERNAME} was NOT deleted" "The account ${USERNAME} was deleted"
	else
		# The user account locked as a default		
		chage -E 0 ${USERNAME}
		
		# Check to see if the chage command was ran successfully
		check_cmd "The account ${USERNAME} was NOT disabled" "The account ${USERNAME} was disabled"

	fi
done

exit 0


