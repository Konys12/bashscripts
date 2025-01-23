#!/bin/bash

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" != 0 ]] 
then
  echo 'Please run with sudo or as root.' >&2
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" = 0 ]]
then
  echo 'Usage: ./add-new-local-user.sh USER_NAME [COMMENT]...' >&2
  echo 'Create an account on the local system with the name of USER_NAME and a comments field of COMMENT.' >&2
  exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"
shift

# The rest of the parameters are for the account comments.
COMMENT="${*}"

# Generate a password.
PASSWORD=$(date +%s%N | sha256sum | head -c48)


# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Check to see if the useradd command succeeded.
if [[ "${?}" != 0 ]]
then
  echo 'ERROR: User creation failed!!' >&2
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded.
if [[ "${?}" != 0 ]]
then
  echo 'ERROR: User password change failed!!' >&2
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user wascreated.
echo
echo -e "username: ${USER_NAME}"
echo
echo -e "password: ${PASSWORD}"
echo
echo -e "host: ${HOSTNAME}"
echo

exit 0
