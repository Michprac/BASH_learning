#!/bin/bash

# This script generates a new local user with password

# Checking if the script is running with superuser privileges
if [[ ${UID} -ne '0' ]]
then
	echo "YOu have no privileges. Run as sudo"
	exit 1
fi

# Chcecking if there are any arguments supplied
if [[ ${#} -lt 1 ]]
then
	echo "Usage ${0} USER_NAME [COMMENT] ..."
	exit 1
fi

# The first argument is the name of the account, others are treated as the comment
USER_NAME="${1}"
shift
COMMENT="${*}"

# Creating an account
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Chceck if the account was created
if [[ "${?}" -ne '0' ]]
then
	echo "The account wasn't created"
	exit 1
fi

# Generating random password and set it to the account
PASSWORD=$(date +%s%N | sha256sum | head -c48)
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}"

# Check if the passwd command was succeeded
if [[ "${?}" -ne '0' ]]
then
	echo "The passsword couldn't be set."
	exit 1
fi

# Force to change password after the user log in
passwd -e "${USER_NAME}"

# Displaying the username, password and host where the account was created
echo
echo "USERNAME: ${USER_NAME}"
echo "PASSWORD: ${PASSWORD}"
echo "HOST: ${HOSTNAME}"
echo

