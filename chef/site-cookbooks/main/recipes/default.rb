include_recipe 'git'
include_recipe 'python'
include_recipe 'php'
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'

app = node[:app]
app_name = app[:name]
app_user = app[:user]
db = node[:db]

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

template "/etc/apache2/sites-available/#{app_name}.conf" do
    source 'apache2-site.erb'
    mode '644'
    notifies :reload, 'service[apache2]'
end

template "/etc/php5/apache2/php.ini" do
    source 'php.ini.erb'
    mode '644'
    notifies :reload, 'service[apache2]'
end

execute 'a2dissite 000-default' do
  user 'root'
end

execute 'a2ensite app' do
  user 'root'
end

if db[:host] == 'localhost'

    include_recipe 'mysql::server'
    db_user = db[:user]

    mysql_user db_user do
        password db[:password]
    end

    mysql_db db[:name] do
        owner db_user
    end
end

