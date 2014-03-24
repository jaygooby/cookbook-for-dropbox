group node['dropbox']['group'] do
  members "www-data"
  append true
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

directory node['dropbox']['website']['directory'] do
  owner node['nginx']['user'] 
  group node['nginx']['group'] 
  recursive true
  not_if "test -d #{node['dropbox']['website']['directory']}"
end

directory node['dropbox']['website']['logdir'] do
  owner node['nginx']['user'] 
  group node['nginx']['group'] 
  recursive true
  not_if "test -d #{node['dropbox']['website']['logdir']}"
end

link "#{node['dropbox']['website']['docroot']}" do
  to "#{node['dropbox']['folder']}/#{node['dropbox']['website']['synced_folder']}"
end

template "/etc/nginx/sites-available/#{node['dropbox']['website']['hostname']}" do
  source "website.erb"
  action :create_if_missing
  owner node['dropbox']['website']['user']
  group node['dropbox']['website']['group']
end

bash "enable #{node['dropbox']['website']['hostname']}" do
  user "root"
  code <<-BASH  
  nxensite #{node['dropbox']['website']['hostname']}
  BASH
  notifies :reload, "service[nginx]"
end
