Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "consul-server"
  config.vm.provision "shell", path: "provision.sh"

  serverIp = "192.168.99.100"
  config.vm.network "private_network", ip: serverIp

  serverInit = %(
	{
		"server": true,
		"ui": true,
		"advertise_addr": "#{serverIp}",
		"client_addr": "#{serverIp}",
		"data_dir": "/tmp/consul",
		"bootstrap_expect": 1
	}
  )
  config.vm.provision "shell", inline: "echo '#{serverInit}' > /etc/systemd/system/consul.d/init.json"
  config.vm.provision "shell", inline: "service consul start"
end
