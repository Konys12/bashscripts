#!/bin/bash
#
# This script automats the deployment of the Kodekloud e-commerce application
#

#######################################
# Print a message in a given color.
# Arguments:
#   Color. eg: green, red
#######################################

function print_color(){
  NC="\033[0m"
  case $1 in
    "green") COLOR="\033[0;32m";;
    "red") COLOR="\033[0;31m";;
    *) COLOR="\033[0m";;
  esac

  echo -e "${COLOR} $2 ${NC}"
}

#######################################
# Check the status of a given service. If not active exit script
# Arguments:
#   Service Name. eg: firewalld, mariadb
#######################################
function check_service_status(){

  is_service_active=$(systemctl is-active $1)
   
  if  [[ $is_service_active = "active" ]]
  then
    print_color "green" "$1 is active"
  else
    print_color "red" "$1 Service is not active"
    exit 1
  fi
}

#######################################
# Check the status of a firewalld rule. If not configured exit.
# Arguments:
#   Port Number. eg: 3306, 80
#######################################
function is_firewalld_configured(){
  firewalld_ports=$(sudo firewall-cmd --list-all --zone=public | grep ports)

  if [[ $firewalld_ports == *$1* ]]
  then
    print_color "green" "Port $1 is configured"
  else
    print_color "red" "Port $1 is NOT configured"
    exit 1
  fi
}

#######################################
# Check if a given item is present in an output
# Arguments:
#   1 - Output
#   2 - Item
#######################################
function check_item (){
  if [[ $1 == *$2* ]]
  then
    print_color "green" "item $2 is present on the web page"
  else
    print_color "red" "item $2 is NOT present on the web page"
  fi
}

print_color "green" "---------------- Setup Database Server ------------------"
# Install and configure FirewallD
print_color "green" "Installing firewalld..."

sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

check_service_status firewalld

# Install and configure MariaDB
print_color "green" "Installing MariaDB..."
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

check_service_status mariadb

# Add Firewall ruless for database
print_color "green" "Adding Firewall rules for DB..."
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

is_firewalld_configured 3306

# Configure Database
print_color "green" "Configuring DB..."
cat > configure-db.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF

sudo mysql < configure-db.sql

# Load inventory daa into the database
print_color "green" "Loading inventory into the DB..."
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

sudo mysql < db-load-script.sql

mysql_db_results=$(sudo mysql -e "use ecomdb; select * from products;")

# Check if invetory data (pick on Laptop) was correctly loded into database
if [[ $mysql_db_results == *Laptop* ]]
then
  print_color "green" "Inventory data loaded into MySQL"
else
  print_color "red" "Inventory data not loaded into MySQL"
  exit 1
fi

print_color "green" "---------------- Setup Database Server - Finished ------------------"

print_color "green" "-------------- Web Server Configuration ----------------------------"
print_color "green" "Installing web server packages..."

# Install apache web server and php
sudo yum install -y httpd php php-mysqlnd

# Configure Firewall rules for web server
print_color "green" "Configuring FirewallD rules.."
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

is_firewalld_configured 80

# Update httpd configuration to work with index.php by default
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

# Start and enable httpd service
print_color "green" "Starting Web Server..."
sudo systemctl start httpd
sudo systemctl enable httpd

check_service_status httpd

# Install GIT and download source code repository
print_color "green" "Clonig git repo..."
sudo yum install -y git
sudo git clone https://github.com/Konys12/learning-app-ecommerce.git /var/www/html/

# Create and configure env file for database environment variables
print_color "green" "Configuring environment variables..."
sudo tee /var/www/html/.env > /dev/null <<EOF
DB_HOST=localhost
DB_USER=ecomuser
DB_PASSWORD=ecompassword
DB_NAME=ecomdb
EOF

print_color "green" "All set..."

print_color "green" "---------------- Setup Web Server - Finished ------------------"


# Test Script
web_page=$(curl http://localhost)

for item in Laptop Drone VR Watch
do
  check_item "$web_page" $item
done
