# What it is:

A Vagrant machine using chef provisioning to create a basic LAMP (Linux-Apache-MySql-Php) server

# How to use:

1. Have vagrant and virtualbox installed
2. Clone the project and its submodules
3. Edit the chef and vagrant configs in `Vagrantfile` so as suit you, or just skip this step
4. Run `vagrant up`
5. After vargant finished provisioning, check your site at `localhost:8080` (if you don't touch the Vagrant file)
6. You have a LAMP virtual machine. Do whatever you intend to do with it.
