# the user the webserver runs as
default['dropbox']['website']['user'] = 'nobody'

# the group the webserver belongs to
default['dropbox']['website']['group'] = 'www-data'

# the hostname you'll access your Dropbox website at
default['dropbox']['website']['hostname'] = 'demo.charanga.com'

default['dropbox']['website']['directory'] = "/var/www/#{node['dropbox']['website']['hostname']}"
default['dropbox']['website']['docroot']   = "#{node['dropbox']['website']['directory']}/docroot"
default['dropbox']['website']['logdir']    = "#{node['dropbox']['website']['directory']}/logs"

# assumes that your Dropbox website folder is named after your hostname
default['dropbox']['website']['synced_folder'] = node['dropbox']['website']['hostname']
default['dropbox']['selective_sync']['folders'] = [node['dropbox']['website']['synced_folder']]