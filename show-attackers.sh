#!/bin/bash

# This script shows failed login attempts by IP address.
# If there are any IPs with over LIMIT failures, display the count, IP and location.

LIMIT='10'

# Provided file name as an argument.
FILE_NAME="${1}"

# Check if the file exists.
if [[ ! -e "${FILE_NAME}" ]]
then
	echo "Cannot open log file: ${FILE_NAME}" >&2
	exit 1
fi

# Display the CSV header
echo 'count,IP,Location'

# Loop through the list of failed attemptts and corresponding IP addresses.
grep Failed syslog-sample | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
	# If the number of failed attempts is greater than the limit, display count, IP and location.
	if [[ "${COUNT}" -gt "${LIMIT}" ]]
	then
		LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done

exit 0