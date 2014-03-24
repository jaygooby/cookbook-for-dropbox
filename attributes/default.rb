default['dropbox']['OS_platform'] = 'lnx.x86_64'
default['dropbox']['cli']['download_url'] = "https://www.dropbox.com/download?dl=packages/dropbox.py" 

default['dropbox']['user'] = "deploy"
default['dropbox']['group'] = node['dropbox']['user']

default['dropbox']['mode'] = "0755"

default['dropbox']['install_dir'] = "/home/#{node['dropbox']['user']}"
default['dropbox']['cli']['bin_dir'] = "#{node['dropbox']['install_dir']}/bin"
default['dropbox']['cli']['bin'] = "#{node['dropbox']['cli']['bin_dir']}/dropbox.py"
default['dropbox']['folder'] = "#{node['dropbox']['install_dir']}/Dropbox"

default['dropbox']['selective_sync']['enabled'] = false
default['dropbox']['selective_sync']['folders'] = []