#!/bin/bash

# This script creates a user on the local system.
# You will be prompted to enter the username (login), the real name and a password
# In the output you can get the acount information.

# Superuser privileges checking
UID_SUDO='0'
if [[ ${UID} -ne ${UID_SUDO} ]]
then
	echo "You have no privileges. Run this script as root."
	exit 1
fi

# Asking for user name, real name and password for the account
read -p "Enter your username: " USERNAME
read -p "Enter your real name: " USER_REAL_NAME
read -p "Enter a password: " PASSWORD

# Create an account with comment USER_REAL_NAME and specified home directory USERNAME
useradd -c "${USER_REAL_NAME}" -m ${USERNAME}

# Check if the user account was created
if [[ "${?}" -ne 0 ]]
then
	echo "The account wasn't created"
	exit 1
fi

# Password setting
echo "${PASSWORD}" | passwd --stdin ${USERNAME}

# Check if the password was set
if [[ "${?}" -ne 0 ]]
then
	echo "The password couldn't be set"
	exit 1
fi

# Force password change after log in to the account
passwd -e ${USERNAME}

# Display the username, password, and the host where the user was created
echo
echo "username:"
echo "${USERNAME}"
echo
echo "password:"
echo "${PASSWORD}"
echo
echo "host:"
echo "${HOSTNAME}"

exit 0