
# IsoDev
An easy and lightweight way to created isolated development environments

## Why make IsoDev
Recently, there have been a lot of security issues related to using different npm modules. For example, the most recent was the issues with the [coa package](https://www.rapid7.com/blog/post/2021/11/05/new-npm-library-hijacks-coa-and-rc/). For developers, this can be very scary, as we usually install these tools directly onto our machines. Enter IsoDev, a way to create a lightweight isolated development environment. This is my solution to the current problem, by either using Vagrant or Docker to create such environment.

## Capabilities
You are able to create python, node, and golang applications without having any of  the packages directly installed on your local machine. This also means you will not need python, node, or golang installed on your local machine.

## Getting Started
All you have to do is run the following commands to get up and started with IsoDev:
```
git clone https://github.com/simar-singh/IsoDev.git
cd IsoDev/
chmod +x install.sh
sudo ./install.sh
isodev -h
```

> ** There are two requirements to be able to use IsoDev. The first being [Vagrant](https://www.vagrantup.com/) with [Virtualbox](https://www.virtualbox.org/). The second is [Docker](https://www.docker.com/get-started) if you plan on using any of the docker capabilities.

## License
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
