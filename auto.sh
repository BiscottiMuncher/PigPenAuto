#!/bin/bash

preIn(){
## Get update, fix packages, install git, install venv
apt-get update --fix-missing && apt-get install -y git
apt-get install python3.11-venv && apt-get install pip
}

getS3A(){
## Git clone snort auto package
git clone https://github.com/BiscottiMuncher/Snort3Auto
cd Snort3Auto/
echo "Installing Snort"
chmod +x snortauto.sh
./snortauto.sh -t eth0
cd
}

getSF(){
## Install and configure splunk forwarder
cd
# Gets forwarder deb
wget "$1"
sfStr=$(ls | grep splunkforward*)
echo "Installing $sfStr"
dpkg -i "$sfStr"
# Takes in 4 arguments Splunk IP, Forwarder Port, Username, Password
/opt/splunkforwarder/bin/splunk start --accept-license --add-forward-server $2:$3 --auth $4:$5 --answer-yes --enable-boot-start
# Adds monitor to /var/log/snort for monitoring of all logs
/opt/splunkforwarder/bin/splunk add monitor /var/log/snort
}

getPP(){
## Install PigPen
git clone https://github.com/BiscottiMuncher/PigPen
cd PigPen
python3 -m venv ppenvo
source PigPen/ppenvo/bin/activate
pip install -r requirements.txt
python pigpen.py
}

if [ -z "$1" ]; then
        echo "Enter Forwarder link, Splunk Server IP, Forwarder Port, Splunk Username, Splunk Password"
else
        echo "Installing With $1 $2 $3 $4 $5"
        preIn
        getS3A
        getSF $1 $2 $3 $4 $5
        getPP
fi
