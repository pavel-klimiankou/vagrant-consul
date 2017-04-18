#!/bin/bash

# update and unzip
dpkg -s unzip &>/dev/null || {
	apt-get -y update && apt-get install -y unzip
}

# install consul 
if [ ! -f /usr/local/bin/consul ]; then
	cd /usr/local/bin

	version='0.8.0'
	wget https://releases.hashicorp.com/consul/${version}/consul_${version}_linux_amd64.zip -O consul.zip
	unzip consul.zip
	rm consul.zip

	chmod +x consul
fi

if [ ! -f /etc/systemd/system/consul.service ]; then
	cp /vagrant/consul.service /etc/systemd/system/consul.service
fi

if [ ! -d /etc/systemd/system/consul.d ]; then
	mkdir -p /etc/systemd/system/consul.d
fi
