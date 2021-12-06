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
  echo -e "   docker   [-d]  Instead of using vagrant use docker (use with -h afterwards to see options)"
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
      echo -e "curl -fsSL https://rpm.nodesource.com/setup_17.x | bash -" >> $PWD/Vagrantfile
      echo -e "sudo yum install -y nodejs" >> $PWD/Vagrantfile
    elif [[ $1 == "python" ]] || [[ $1 == "-p" ]]; then
      echo -e "sudo yum install -y python3" >> $PWD/Vagrantfile
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
    echo -e "  config.vm.provider \"virtualbox\" do |v|" >> $PWD/Vagrantfile
    echo -e "    v.memory = 256" >> $PWD/Vagrantfile
    echo -e "    v.cpus = 1" >> $PWD/Vagrantfile
    echo -e "    v.customize [\"modifyvm\", :id, \"--cpuexecutioncap\", \"42\"]" >> $PWD/Vagrantfile
    echo -e "    v.name = \"isodev\"" >> $PWD/Vagrantfile
    echo -e "  end\n" >> $PWD/Vagrantfile

    echo -e "  config.vm.box = \"centos/7\"" >> $PWD/Vagrantfile
    echo -e "  config.vm.synced_folder \".\", \"/vagrant\"" >> $PWD/Vagrantfile
    echo -e "  config.vm.provision \"shell\", inline: \$script" >> $PWD/Vagrantfile
    echo -e "end" >> $PWD/Vagrantfile
  fi
}

# Docker command
docker() {
  # Check for help
  if [[ $1 == "" ]] || [[ $1 == "-h" ]] || [[ $1 == "help" ]]; then
    # Print help prompt to console
    echo -e "\Docker help\n"
    echo -e "isodev docker [options] \n"
    echo -e "Available Generations:"
    echo -e "   node [-n]     NodeJS Docker configuration"
    echo -e "   python [-p]   Python3 Docker configuration"
    echo -e "   go [-g]       Golang Docker configuration"
    echo -e "   run [-r]      Run the application (with npm command afterwards)"
  # Create node configuration
  elif [[ $1 == "-n" ]] || [[ $1 == "node" ]]; then
    # Create Dockerfile
    : > $PWD/Dockerfile
    echo -e "FROM node\n" >> $PWD/Dockerfile
    echo -e "ARG cmd=\"\"" >> $PWD/Dockerfile
    echo -e "ENV arg=\$cmd\n" >> $PWD/Dockerfile
    echo -e "WORKDIR /app\n" >> $PWD/Dockerfile
    echo -e "CMD \$arg" >> $PWD/Dockerfile
    
    # Create docker-compose.yml
    : > $PWD/docker-compose.yml
    echo -e "services:" >> $PWD/docker-compose.yml
    echo -e "  web:" >> $PWD/docker-compose.yml
    echo -e "    build: " >> $PWD/docker-compose.yml
    echo -e "      context: ." >> $PWD/docker-compose.yml
    echo -e "      args: " >> $PWD/docker-compose.yml
    echo -e "        cmd: \${ARGUMENT}" >> $PWD/docker-compose.yml
    echo -e "    volumes:" >> $PWD/docker-compose.yml
    echo -e "      - type: bind" >> $PWD/docker-compose.yml
    echo -e "        source: \${PWD}/." >> $PWD/docker-compose.yml
    echo -e "        target: /app/" >> $PWD/docker-compose.yml
    echo -e "    ports: " >> $PWD/docker-compose.yml
    echo -e "      - 3000:3000" >> $PWD/docker-compose.yml

    # Confirmation
    echo "Created Node Docker configuration"

  # Run the application
  elif [[ $2 == "up" ]] || [[ $2 == "-r" ]] || [[ $2 == "run" ]]; then
    # Check for collection of remaining arguments
    if [[ ${@:3} == "" ]]; then
      echo "No npm command provided. Run isodev -d -r npm <command>"
    # Run docker compose based on arguments provided
    else
      ARGUMENT="${@:3}" docker-compose up --build
    fi
  # No valid options
  else
    echo "No valid option provided. Run with [-h] to see options"
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
elif [[ $1 == "docker" ]] || [[ $1 == "-d" ]]; then 
  docker "$2" "${@:2}"
  exit
elif [[ $1 == "clean" ]] || [[ $1 == "-c" ]]; then 
  clean
  exit
else
  help1
  exit
fi