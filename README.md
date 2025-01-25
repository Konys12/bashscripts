# Sample Bash Scripts Repository

This repository contains a collection of sample bash scripts designed to automate common administrative and security tasks. Each script is tailored for specific purposes.

---

## **Scripts Overview**

### 1. `add-new-local-user.sh`
- **Purpose**: Automates the creation of a new local user on a Linux system.
- **Details**:
   - Requires superuser privileges, exits with status 1 if not met.
   - Shows usage info if no username is provided and exits with status 1.
   - Uses the first argument as the username, remaining arguments as comments.
   - Auto-generates a password for the new account.
   - Exits with status 1 if account creation fails, displays username, password, and host on success.



---

### 2. `disable-local-user.sh`
- **Purpose**: Disables a specified local user account on a Linux system.
- **Details**:
   - Requires superuser privileges, exits with status 1 if not met, and displays messages on standard error.
   - Disables accounts by default.
   - Supports the following options:
        -d: Deletes accounts.
        -r: Removes the home directory.
        -a: Archives the home directory to /archives (creates the directory if not exists).
   - Any other option causes the script to display a usage statement and exit with status 1.
   - Accepts a list of usernames, requires at least one, or exits with usage info and status 1.
   - Refuses to disable or delete accounts with UID less than 1,000.
   - Informs the user if an action fails and displays the username and actions performed.

---

### 3. `show-attackers.sh`
- **Purpose**: Displays the number of failed login attempts by IP address and location.
- **Details**:
  - Requires a file as an argument, exits with error message and status 1 if not provided or unreadable.
  - Counts failed login attempts by IP address and displays IPs with more than 10 failed attempts, including the count, IP, and location.
  - Outputs results in CSV format with the header "Count,IP,Location".

---

### 4. `run-everywhere.sh`
- **Purpose**: Executes a given command or script on multiple servers.
- **Details**:
  - Executes all arguments as a command on servers listed in the /vagrant/servers file by default.
  - Runs the command as the user executing the script.
  - Uses ssh -o ConnectTimeout=2 to connect to hosts, avoiding delays from down servers.
  - Supports the following options:
        -f FILE: Override the default /vagrant/servers file.
        -n: Dry run, displaying commands without executing them (prefix with "DRY RUN:").
        -s: Run the command with sudo on remote servers.
        -v: Enable verbose mode, displaying the server name for each command.
  - Must be executed without superuser privileges; use -s for remote sudo commands.
  - Notifies the user if the command fails on any remote host.
- **Requirement**:
  - This script assumes working SSH connection exists between the machine executing the script and the target servers.

---

### 5. `deploy-ecommerce-application.sh`
- **Purpose**: Install ecommerce learning application
- **Details**:
  - Installs the e-commerce learning application on a LAMP stack.
  - The application web page should be accessible at http://localhost.
  - Installs and configures `firewalld`, `mariadb`, and `httpd`, and checks if they are active after installation.
  - Creates an `.env` file with database connection settings (`DB_HOST`, `DB_USER`, etc.) for the e-commerce web application.
  - Adds firewall rules to allow MariaDB (3306/tcp) and HTTP (80/tcp) traffic, and verifies they are correctly configured.
  - Creates a database (`ecomdb`) and a user (`ecomuser`) with the required permissions, then loads sample inventory data into the `products` table.
  - Verifies if inventory data (e.g., "Laptop") is successfully loaded into the database. The script exits if not.
  - Clones the `learning-app-ecommerce` repository from GitHub into the web server's document root (`/var/www/html`).
  - Uses `curl` to fetch the web page and checks if certain items (e.g., "Laptop", "Drone", "VR", "Watch") are present on the page.
- **Requirement**:
  - This script expects to work on CentOS machine
- ** Note **;
  - ecommerce learning application source code was created by Kodekloud academy for education purposses. 


