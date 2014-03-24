dropbox_tgz = "/tmp/dropbox.tgz"

group node['dropbox']['group'] do
  action :create
end

user node['dropbox']['user'] do
  action :create
  shell "/bin/bash"
  gid node['dropbox']['group']
  supports :manage_home => true
  home "/home/#{node['dropbox']['user']}" #TODO: make OS independent. /Users is /home on OS X
  not_if "test -d /home/#{node['dropbox']['user']}"
end

remote_file dropbox_tgz do
  owner node['dropbox']['user']
  group node['dropbox']['group']  
  source "https://www.dropbox.com/download?plat=#{node['dropbox']['OS_platform']}" 
  not_if "test -f #{dropbox_tgz}"
end

directory node['dropbox']['cli']['bin_dir'] do
  owner node['dropbox']['user']
  group node['dropbox']['group']
  mode node['dropbox']['mode']
  not_if "test -d #{node['dropbox']['cli']['bin_dir']}"
end

remote_file node['dropbox']['cli']['bin'] do
  owner node['dropbox']['user']
  group node['dropbox']['group']  
  source node['dropbox']['cli']['download_url']
  mode 0755
  not_if "test -f #{node['dropbox']['cli']['bin']}"
end

bash "Install Dropbox" do
  user node['dropbox']['user']
  group node['dropbox']['group']
  code <<-BASH  
    cd #{node['dropbox']['install_dir']} && tar xzvf #{dropbox_tgz}
  BASH
  not_if "test -d #{node['dropbox']['install_dir']}/.dropbox"
end

directory node['dropbox']['folder'] do
  owner node['dropbox']['user']
  group node['dropbox']['group']
  recursive true
  mode 01775 # sticky TODO: add sticky to existing mode attribute?
end

template "/etc/init.d/dropbox" do
  source "init.d.erb"
  owner "root"
  group "root"
  mode 0755
  action :create_if_missing
end

service "dropbox" do
  supports :status => true, :restart => true, :reload => false
  action [ :enable, :start ]
end

# TODO: currently there's still a manual step required to
# complete the pairing after initial install
#
# sudo /etc/init.d/dropbox stop
#
# node['dropbox']['install_dir']}/.dropbox-dist/dropboxd
# and wait for it to print out the URL to visit to pair
# go to this, leaving the .dropbox-dist/dropboxd running
# until it confirms in the console "Welcome ..."
# then you can ctrl-c the .dropbox-dist/dropboxd executable
# and start the service

bash "Selective sync" do
  only_if { node['dropbox']['selective_sync']['enabled'] }
  code <<-BASH
    # exclude all the top level folders
    cd #{node['dropbox']['folder']} && #{node['dropbox']['cli']['bin']} exclude add *
    # then put back the folders we'd like to sync
    cd #{node['dropbox']['folder']} && #{node['dropbox']['cli']['bin']} exclude remove #{node['dropbox']['selective_sync']['folders'].join(' ')}
  BASH
end