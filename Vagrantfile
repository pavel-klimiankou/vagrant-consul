Vagrant.configure("2") do |config|

  def create_consul_host(config, hostname, ip, initJson)
    config.vm.define hostname do |host|
      host.vm.box = "ubuntu/xenial64"
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: ip

      host.vm.provision "shell", path: "provision.sh"
      host.vm.provision "shell", inline: "echo '#{initJson}' > /etc/systemd/system/consul.d/init.json"
      host.vm.provision "shell", inline: "service consul start"
    end
  end

  def create_consul_win_host(config, hostname, ip, initJson)
    config.vm.define hostname do |host|
      host.vm.box = "mwrock/Windows2016"
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: ip

      host.vm.provision "shell", path: "provision-win.ps1"
      host.vm.provision "shell", inline: "Set-Content -Value '#{initJson}' -Path C:\\Consul\\init.json"
      host.vm.provision "shell", inline: "Start-Process consul.exe -WorkingDirectory C:\\Consul -ArgumentList 'agent', '-config-dir=C:\\Consul'"
    end
  end

  # Create server
  serverIp = "192.168.99.100"
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

  create_consul_host config, "consul-server", serverIp, serverInit

  # Create Linux agents
  for host_number in 1..2
    hostname="host-#{host_number}"
    clientIp="192.168.99.10#{host_number}"

    clientInit = %(
      {
        "advertise_addr": "#{clientIp}",
        "retry_join": ["#{serverIp}"],
        "data_dir": "/tmp/consul"
      }
    )

    create_consul_host config, hostname, clientIp, clientInit
  end

  # Create windows agent
  winClientIP = "192.168.99.103"
  winClientInit = %(
    {
      "advertise_addr": "#{winClientIP}",
      "retry_join": ["#{serverIp}"],
      "data_dir": "C:\\\\Consul\\\\data"
    }
  )

  create_consul_win_host config, "host-win", winClientIP, winClientInit
end
