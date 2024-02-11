#!/bin/bash

# This script help user to run commands on many servers automatically


# The file which contain servers' names
FILE_NAME='/vagrant/servers'

# Options for the ssh command.
SSH_OPTIONS='-o ConnectTimeout=2'

usage() {
	# Display the usage and exit.
	echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
	echo 'Executes COMMAND as a single command on every server.' >&2
	echo "	-f FILE	USE FILE for the list off servers. Default ${FILE_NAME}." >&2
	echo "	-n 		Dry run mode. Display the COMMAND that would have been executed and exit." >&2
	echo "	-s 		Execute the COMMAND using sudo on the remote server." >&2
	echo "	-v 		Verbose mode. Displays the server name before executing COMMAND." >&2
	exit 1
}

# Make sure the script is not begin executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
	echo "Do not execute this script as root. Use the -s option instead." >&2
	usage
fi


# Different options
while getopts "f:nsv" option
do
	case ${option} in
		f)
			FILE_NAME="${OPTARG}"
			;;
		n)
			DRY_RUN='true'		
			;;
		s)
			SUDO_OPTION='sudo'
			;;
		v)
			VERBOSE='true'
			;;
		?)
			usage
			;;
	esac
done

# Remove the options while leaving the remaing arguments.
shift "$((OPTIND - 1))"

# If the user doesn't supply at leat one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
	usage
fi

# Anything that remains on the command line is to be treated as a single command.
COMMAND="${@}"

# Make sure the FILE_NAME file exists.
if [[ ! -e "${FILE_NAME}" ]]
then
	echo "Cannot open server list file ${FILE_NAME}." >&2
	exit 1
fi

EXIT_STATUS='0'

# Loop through the FILE_NAME
for SERVER in $(cat ${FILE_NAME})
do
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${SERVER}"
	fi
	
	
	SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO_OPTION} ${COMMAND}"
 
	# If it's a dry run, it wouldn't be executed only displayed.
	if [[ "${DRY_RUN}" = 'true' ]]
	then
		echo "DRY RUN: ${SSH_COMMAND}"
	else
		${SSH_COMMAND}
		SSH_EXIT_STATUS="${?}"
		
		# Capture any non-zero exit status from the SSH_COMMAND and report to the user.
		if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
		then
			EXIT_STATUS="${SSH_EXIT_STATUS}"
			echo "Execution on ${SERVER} failed." >&2
		fi
	fi
done

exit ${EXIT_STATUS}
