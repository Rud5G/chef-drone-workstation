# -*- mode: ruby -*-
# vi: set ft=ruby :

## Ubuntu 14.04

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
VAGRANT_MIN_VERSION = '1.6.5'


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Check Vagrant version
  if Vagrant::VERSION < VAGRANT_MIN_VERSION
    puts "FATAL: Cookbook depends on Vagrant #{VAGRANT_MIN_VERSION} or higher."
    exit
  end


# Detects vagrant omnibus plugin
  if Vagrant.has_plugin?('vagrant-omnibus')
    puts 'INFO:  Vagrant-omnibus plugin detected.'
    config.omnibus.chef_version = :latest
  else
    puts "FATAL: Vagrant-omnibus plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-omnibus' from any other directory\n       before continuing."
    exit
  end

# Detects vagrant berkshelf plugin
  if Vagrant.has_plugin?('berkshelf')
    # The path to the Berksfile to use with Vagrant Berkshelf
    puts 'INFO:  Vagrant-berkshelf plugin detected.'
    config.berkshelf.berksfile_path = './Berksfile'
  else
    puts "FATAL: Vagrant-berkshelf plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-berkshelf' from any other directory\n       before continuing."
    exit
  end

# Detects vagrant hostmanager plugin
  if Vagrant.has_plugin?('vagrant-hostmanager')
    puts 'INFO:  Vagrant-hostmanager plugin detected.'
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = %w(drone-workstation.dev www.drone.dev)
  else
    puts "WARN:  Vagrant-hostmanager plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-hostmanager' from any other directory\n       before continuing."
  end

  unless Dir[Pathname(__FILE__).dirname.join('data_bags','virtualhosts','*.json')].empty?
    config.hostmanager.aliases = Array.new
  end

  # Add additional virtualhost aliases
  Dir[Pathname(__FILE__).dirname.join('data_bags','virtualhosts','*.json')].each do |databagfile|
    config.hostmanager.aliases << JSON.parse(Pathname(__FILE__).dirname.join('data_bags','virtualhosts',databagfile).read)['server_name']
    JSON.parse(Pathname(__FILE__).dirname.join('data_bags','virtualhosts',databagfile).read)['server_aliases'].each do |serveralias|
      config.hostmanager.aliases << serveralias
    end
  end

  # remove duplicate
  config.hostmanager.aliases = config.hostmanager.aliases.uniq


# Enable SSH agent forwarding for git clones
  config.ssh.forward_agent = true


# vm config
  config.vm.hostname = 'dev-drone'

  config.vm.box = 'phusion-open-ubuntu-14.04-amd64'
  config.vm.box_url = 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box'

  config.vm.network :private_network, :ip => '10.10.0.100'

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      'modifyvm', :id,
      '--memory', '2048',
      '--cpus', '2',
    ]
  end

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box_url = 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box'
  end


  # docker support
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Fix perl reconfigure error and Install Docker
    pkg_cmd = 'locale-gen nl_NL.UTF-8; dpkg-reconfigure locales;' \
      'wget -q -O - https://get.docker.io/gpg | apt-key add -;' \
      'echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;' \
      'apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; '
    # Add vagrant user to the docker group
    pkg_cmd << 'usermod -a -G docker vagrant; '
    config.vm.provision :shell, :inline => pkg_cmd
  end


  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = 'data_bags'
    chef.environments_path = 'environments'
    chef.roles_path = 'roles'

    chef.verbose_logging = true
    chef.log_level = :info
    # chef.log_level = :debug
    chef.node_name = 'dev-drone'
    chef.environment = 'development'

    # chef.provisioning_path = guest_cache_path
    chef.json = {
        'mysql' => {
            'server_root_password' => 'rootpass',
            'server_repl_password' => 'iloverandompasswordsbutthiswilldo',
            'server_debian_password' => 'iloverandompasswordsbutthiswilldo'
        }
    }

    chef.run_list = %w(
      role[base]
      recipe[drone-workstation::servernode]
    )

  end
end
