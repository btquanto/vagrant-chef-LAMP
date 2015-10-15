# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "hashicorp/precise32"

    http_port = 8080
    ssh_port = 8022
    csync_port = 9116

    config.vm.network :forwarded_port, guest: 80, host: http_port
    config.vm.network :forwarded_port, guest: 22, host: ssh_port, id: "ssh", auto_correct: true
    config.vm.network :forwarded_port, guest: 8888, host: csync_port

    # apt wants the partial folder to be there
    apt_cache = './.cache/apt'
    FileUtils.mkpath "#{apt_cache}/partial"

    chef_cache = '/var/chef/cache'

    shared_folders = {
        apt_cache => '/var/cache/apt/archives',
        './.cache/chef' => chef_cache,
    }

    config.vm.provider :virtualbox do |vb|

        #vb.gui = true

        shared_folders.each do |source, destination|
            FileUtils.mkpath source
            config.vm.synced_folder source, destination
            vb.customize ['setextradata', :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/#{destination}", '1']
        end

        vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']
    end

    config.vm.provision :chef_solo do |chef|

        chef.provisioning_path = chef_cache

        chef.cookbooks_path = [
            'chef/chef-cookbooks',
            'chef/site-cookbooks',
        ]

        chef.json = {
            :app => {
                :user => 'vagrant',
            },
            :apache => {
                :user => 'vagrant',
            },
            :php => {
                :ppa => {
                    :uri => 'ppa:ondrej/php5',
                    :key_server => 'keyserver.ubuntu.com',
                    :key => 'E5267A6C'
                }
            },
            :db => {
                :host => 'localhost',
                :name => 'vagrant',
                :user => 'vagrant',
                :password => 'vagrant',
            },
            :mysql => {
                :server_root_password => 'vagrant',
            }
        }

        chef.add_recipe 'main'
    end

end