#!/bin/bash

# This script creates a new user on the local system with generated password
# You have to supply a username as an argument to the script
# Also you can supply a comment as an argument

# Checking if the script is running with superuser privileges
if [[ ${UID} -ne '0' ]]
then
	echo "YOu have no privileges. Please run as root"
	exit 1
fi

# Chcecking if there are any arguments supplied
if [[ ${#} -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT."
	exit 1
fi

# The first argument is the name of the account, others are treated as the comment
USER_NAME="${1}"
shift
COMMENT="${*}"

# Generating random password
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Creating an account
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Chceck if the account was created
if [[ "${?}" -ne '0' ]]
then
	echo "The account wasn't created"
	exit 1
fi

# Set the password to the account
echo "${PASSWORD}" | passwd --stdin "${USER_NAME}"

# Check if the passwd command was succeeded
if [[ "${?}" -ne '0' ]]
then
	echo "The passsword couldn't be set."
	exit 1
fi

# Force password change after the user log in
passwd -e "${USER_NAME}"

# Displaying the username, password and host where the account was created
echo
echo "USERNAME: ${USER_NAME}"
echo "PASSWORD: ${PASSWORD}"
echo "HOST: ${HOSTNAME}"
echo

