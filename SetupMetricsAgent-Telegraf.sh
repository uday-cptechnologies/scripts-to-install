#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root user"
   exit 1
fi

usage() {
    echo  -e "\n###\n Telegraf Agent Installation Script
       Note:
         This script is for Ubuntu | Debian | Redhat | CentOS Server types Only.
       Purpose:
         This Script will perform the following functions:
	 -- Check OS type of server.
	 -- Install Telegraf 1.16 with required input plugins & dependencies.
       Usage:
         bash $0 --help
         bash $0 start
       Script Parameters:
         start                  starts the script
         --help or -h           shows this help text \n###\n"
    exit 0
}

if test "$1" = "" || test  "$1" = "--help" || test "$1" = "-h"; then
   usage
elif test "$1" = "start" ; then
   break
fi
echo -e "\n##############################################\n"

###########################################################
##         install Telegraf on client machine            ##
###########################################################
debian_telegraf() {
    #Installing Telegraf on Ubuntu
    echo -e "\n###\n Downloading Telegraf 1.16 \n###\n"
    wget https://dl.influxdata.com/telegraf/releases/telegraf_1.16.2-1_amd64.deb
    echo -e "\n###\n Installing Telegraf 1.16 \n###\n"
    sudo dpkg -i telegraf_1.16.2-1_amd64.deb
    echo -e "\n###\n Starting Telegraf Service \n###\n"
    systemctl start telegraf.service
    echo -e "\n###\n Removing deb package \n###\n"
    rm -f telegraf_*.*_amd64.deb
}

redhat_telegraf() {
    #Installing Telegraf on Ubuntu
    echo -e "\n###\n Downloading Telegraf 1.16 \n###\n"
    wget https://dl.influxdata.com/telegraf/releases/telegraf-1.16.2-1.x86_64.rpm
    echo -e "\n###\n Installing Telegraf 1.16 \n###\n"
    sudo yum localinstall telegraf-1.16.2-1.x86_64.rpm
    echo -e "\n###\n Starting Telegraf Service \n###\n"
    systemctl start telegraf.service
    echo -e "\n###\n Removing deb package \n###\n"
    rm -f telegraf_*.*_amd64.deb
}
if [ "$(grep -Ei 'Debian|Ubuntu|Mint' /etc/*release)" ]
    then
        echo " It's a Debian or Ubuntu based system."
        debian_telegraf
elif [ "$(grep -Ei 'Redhat|CentOS|Fedora' /etc/*release)" ]
    then
        echo " It's a Redhat or CentOS based system."
        redhat_telegraf
else
    echo "This script doesn't support this OS type."
    echo "Please refer this page to find your OS type: https://www.influxdata.com/get-influxdb/"
    exit 3
fi

#Finishing 
echo  -e "\n###\n ### Telegraf Agent is Installed ###
	Following Should Work to check if data is being sent to your database Server:
	-- telegraf service should be running
	-- telegraf should be able to connect to your database server. \n###\n"