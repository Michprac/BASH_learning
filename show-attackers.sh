#!/bin/bash

# This script shows failed login attempts.

# Provided file name as an argument.
FILE_NAME="${*}"

# Check if the file exists.
if [[ ! -e "#{FILE_NAME}" ]]
then
	echo "Fie doesn't exist." >&2
	exit 1
fi



