#!/bin/bash

# This script is created for learning STDIN/OUT/ERR, based on add-new-local-user.sh

# Checking if the script is running with superuser previleges, if not put meassage to STDERR
if [[ ${UID} -ne '0' ]]
then
	echo "You have no previleges. Run the script as root" 1>&2
	exit 1
fi

# Checking if there are any arguments supplied.
if [[ ${#} -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..." 1>&2
	exit 1
fi

# The first provided argument is a username, others are treated as a COMMENT
USER_NAME="${1}" 
shift
COMMENT="${*}"

# Automaatically generated password for the account and redirecting it to the null (we don't want to see otput)
PASSWORD=$(date | sha256sum | head -c10)

# Creating an account
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Checking if the account was created successfully
if [[ ${?} -ne 0 ]]
then
	echo "The account wasn't created." 1>&2
	exit 1
fi

# Assign generated password to the account and redirecting it to the null (we don't want to see otput)
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Checking if the password was created successfully.
if [[ ${?} -ne 0 ]]
then
	echo "The password wasn't assigned." 1>&2
	exit 1
fi

# Force password change after first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password and host were the account was created.
echo
echo "USERNAME: ${USER_NAME}"
echo "PASSWORD: ${PASSWORD}"
echo "HOST: ${HOSTNAME}"
echo

exit 0