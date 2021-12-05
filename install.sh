#!/bin/bash

# Check if ran with administrator privledges
if [ "$EUID" -ne 0 ]
  then echo -e "Please run as root"
  exit
fi

# Start installation
echo -e "\nInstalling isodev...\n"

# Make executable
chmod +x isodev
sudo cp isodev /usr/local/bin

# Successfully installed
echo -e "Successfully added isodev!"
echo -e "Run isodev in your terminal to bring up the help prompt"