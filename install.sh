#!/bin/bash

# Check if ran with administrator privledges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Installing isodev..."

chmod +x isodev
sudo chmod +x isodev
sudo cp isodev /usr/local/bin

echo "Successfully added isodev!"
echo "Run isodev in your terminal to bring up the help prompt"