#!/bin/bash

# Normal help prompt
help1 () {
  echo -e "\nIsoDev"
  echo -e "The Isolated Development CLI"
  echo -e "Version 0.1.0\n"

  echo -e "Usage: isodev [command] \n"

  echo -e "Commands:"
  echo -e "   generate [-g]  Generate an isolated development enviornment (use with -h afterwards to see options)"
  echo -e "   run      [-r]  Run the isolated development enviornment (use with -h afterwards to see options)"
  echo -e "   clean    [-c]  Clean and delete all Vagrant Boxes on machine"
  echo -e "   help           Help"
}

# Run command
run() {
  # Check if help prompt
  if [[ $1 == "help" ]] || [[ $1 == "-h" ]]; then 
    echo -e "Run options:"
    echo -e "   *             Destroy and run isolated enviornment"
    echo -e "   reload [-l]   Reload isolated enviornment"
  # Reload vm
  elif [[ $1 == "reload" ]] || [[ $1 == "-l" ]]; then
    echo -e "reload"
    vagrant reload --provision
  # Destroy and run vm
  else 
    vagrant destroy -f
    vagrant up --provision
  fi

  # Print ssh config
  echo -e "\n"
  vagrant ssh-config
  echo -e "\n Copy and paste the above section into your ssh config to add vscode ssh capabilities"
}

# Generate command
generate() {
  # Check help prompt
  if [[ $1 == "help" ]] || [[ $1 == "-h" ]]; then 
    echo -e "\nGenerate help\n"
  
    echo -e "isodev generate [options] \n"

    echo -e "Available Generations:"
    echo -e "   node [-n]     NodeJS"
    echo -e "   python [-p]   Python3"
    echo -e "   go [-g]       Golang"
  # Generate Vagrantfile
  else 
    : > $PWD/Vagrantfile
    echo -e "# -*- mode: ruby -*-" >> $PWD/Vagrantfile
    echo -e "# vi: set ft=ruby :\n" >> $PWD/Vagrantfile
    echo -e "\$script = <<-SCRIPT" >> $PWD/Vagrantfile

    # Check for language configuration
    if [[ $1 == "node" ]] || [[ $1 == "-n" ]]; then
      echo -e "curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -" >> $PWD/Vagrantfile
      echo -e "sudo apt-get install -y nodejs" >> $PWD/Vagrantfile
    elif [[ $1 == "python" ]] || [[ $1 == "-p" ]]; then
      echo -e "sudo apt install build-essential -y" >> $PWD/Vagrantfile
      echo -e "sudo apt install python3 python3-dev -y" >> $PWD/Vagrantfile
    else 
      true
    fi

    # Continue Vagrantfile generation
    echo -e "mkdir /home/vagrant/isodev" >> $PWD/Vagrantfile
    echo -e "cp -fr -a /vagrant/. /home/vagrant/isodev/" >> $PWD/Vagrantfile
    echo "echo -e \"rsync -av --progress /home/vagrant/isodev/. /vagrant --exclude node_modules --exclude .vagrant --exclude .git\" > isosync" >> $PWD/Vagrantfile
    echo -e "chmod +x isosync" >> $PWD/Vagrantfile
    echo -e "sudo chmod +x isosync" >> $PWD/Vagrantfile
    echo -e "sudo mv isosync /usr/local/bin" >> $PWD/Vagrantfile
    echo -e "SCRIPT\n" >> $PWD/Vagrantfile

    echo -e "Vagrant.configure("2") do |config|" >> $PWD/Vagrantfile
    echo -e "\tconfig.vm.provider \"virtualbox\" do |v|" >> $PWD/Vagrantfile
    echo -e "\t\tv.memory = 512" >> $PWD/Vagrantfile
    echo -e "\t\tv.cpus = 1" >> $PWD/Vagrantfile
    echo -e "\t\tv.name = \"isodev\"" >> $PWD/Vagrantfile
    echo -e "\tend\n" >> $PWD/Vagrantfile

    echo -e "\tconfig.vm.box = \"hashicorp/bionic64\"" >> $PWD/Vagrantfile
    echo -e "\tconfig.vm.synced_folder \".\", \"/vagrant\", type: \"virtualbox\"" >> $PWD/Vagrantfile
    echo -e "\tconfig.vm.provision \"shell\", inline: \$script" >> $PWD/Vagrantfile
    echo -e "end" >> $PWD/Vagrantfile
  fi
}

# Clean command
clean() {
  # Find all the boxes and delete each one
  vagrant box list | cut -f 1 -d ' ' | xargs -L 1 vagrant box remove --all --force
  echo "Cleaned Vagrant Boxes"
}

# Command check
if [[ $# -eq 0 ]]; then
  help1
  exit
elif [[ $1 == "generate" ]] || [[ $1 == "-g" ]]; then
  generate $2
  exit
elif [[ $1 == "run" ]] || [[ $1 == "-r" ]]; then 
  run $2
  exit
elif [[ $1 == "clean" ]] || [[ $1 == "-c" ]]; then 
  clean
  exit
else
  help1
  exit
fi