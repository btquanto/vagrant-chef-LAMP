include_recipe 'git'
include_recipe 'python'
include_recipe 'apache2'
include_recipe 'mysql'
include_recipe 'apache2::mod_php5'

app = node[:app]
app_name = app[:name]
app_user = app[:user]

%w{
    libjpeg-dev
    zlib1g-dev
    libpng12-dev
}.each do |pkg|
    package pkg do
        action :install
    end
end

user app_user do
    home "/home/#{app_user}"
    shell '/bin/bash'
    supports :manage_home => true
    action :create
end

template "/etc/apache2/sites-available/#{app_name}" do
    source 'apache2-site.erb'
    mode '644'
    notifies :reload, 'service[apache2]'
end

apache_site 'default' do
    action :disable
end

apache_site app_name do
    action :enable
end