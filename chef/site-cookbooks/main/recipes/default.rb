include_recipe 'git'
include_recipe 'python'

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