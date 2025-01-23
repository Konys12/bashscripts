# Sample Bash Scripts Repository

This repository contains a collection of sample bash scripts designed to automate common administrative and security tasks. Each script is tailored for specific purposes.

---

## **Scripts Overview**

### 1. `add-new-local-user.sh`
- **Purpose**: Automates the creation of a new local user on a Linux system.
- **Details**:
  - Enforces that it be executed with superuser (root) privileges. If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1.
  - Provides a usage statement if the user does not supply an account name on the command line and returns an exit status of 1
  - Uses the first argument provided on the command line as the username for the account. Any remaining arguments on the command line will be treated as the comment for the account.
  - Automatically generates a password for the new account.
  - Informs the user if the account was not able to be created for some reason. If the account is not created, the script is to return an exit status of 1
  - Displays the username, password, and host where the account was created.

---

### 2. `disable-local-user.sh`
- **Purpose**: Disables a specified local user account on a Linux system.
- **Details**:
  - Enforces that it be executed with superuser (root) privileges. If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1. All messages associated with this event will be displayed on standard error.
  - Disables (expires/locks) accounts by default.
  - Allows the user to specify the following options:
    -d Deletes accounts instead of disabling them.
    -r Removes the home directory associated with the account(s).
    -a Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives directory. (NOTE: /archives is not a directory that exists by default on a Linux system. The script will need to create this directory if it does not exist.)
    - Any other option will cause the script to display a usage statement and exit with an exit status of 1.
  - Accepts a list of usernames as arguments. At least one username is required or the script will display a usage statement and return an exit status of 1. All messages associated with this event will be displayed on standard error.
  - Refuses to disable or delete any accounts that have a UID less than 1,000.
  - Informs the user if the account was not able to be disabled, deleted, or archived for some reason.
  - Displays the username and any actions performed against the account.

---

### 3. `show-attackers.sh`
- **Purpose**: Displays the number of failed login attempts by IP address and location.
- **Details**:
  - Requires that a file is provided as an argument. If a file is not provided or it cannot be read, then the script will display an error message and exit with a status of 1.
  - Counts the number of failed login attempts by IP address. If there are any IP addresses with more than 10 failed login attempts, the number of attempts made, the IP address from which those attempts were made, and the location of the IP address will be displayed.
  - Produces output in CSV (comma-separated values) format with a header of "Count,IP,Location".

---

### 4. `run-everywhere.sh`
- **Purpose**: Executes a given command or script on multiple servers.
- **Details**:
  - Executes all arguments as a single command on every server listed in the /vagrant/servers file by default.
  - Executes the provided command as the user executing the script.
  - Uses "ssh -o ConnectTimeout=2" to connect to a host. This way if a host is down, the script doesn't hang for more than 2 seconds per down server.
  - Allows the user to specify the following options:
      - -f FILE This allows the user to override the default file of /vagrant/servers. This way they can create their own list of servers execute commands against that list.
      - -n This allows the user to perform a "dry run" where the commands will be displayed instead of executed. Precede each command that would have been executed with "DRY RUN: ".
      - -s Run the command with sudo (superuser) privileges on the remote servers.
      - -v Enable verbose mode, which displays the name of the server for which the command is being executed on.
  - Enforces that it be executed without superuser (root) privileges. If the user wants the remote commands executed with superuser (root) privileges, they are to specify the -s option.
  - Informs the user if the command was not able to be executed successfully on a remote host.


