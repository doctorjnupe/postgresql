#
# Cookbook Name:: postgresql
#

default[:postgresql][:version] = "9.1"
set[:postgresql][:dir]         = "/etc/postgresql/#{node[:postgresql][:version]}/main"

default['postgresql']['config']['data_directory'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['config']['hba_file'] = "/etc/postgresql/#{node['postgresql']['version']}/main/pg_hba.conf"
default['postgresql']['config']['ident_file'] = "/etc/postgresql/#{node['postgresql']['version']}/main/pg_ident.conf"
default['postgresql']['config']['external_pid_file'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
default['postgresql']['config']['listen_addresses'] = 'localhost'
default['postgresql']['config']['port'] = 5432
default['postgresql']['config']['max_connections'] = 100
default['postgresql']['config']['unix_socket_directory'] = '/var/run/postgresql'
default['postgresql']['config']['shared_buffers'] = '24MB'
default['postgresql']['config']['max_fsm_pages'] = 153600 if node['postgresql']['version'].to_f < 8.4
default['postgresql']['config']['log_line_prefix'] = '%t '
default['postgresql']['config']['datestyle'] = 'iso, mdy'
default['postgresql']['config']['default_text_search_config'] = 'pg_catalog.english'
default[:postgresql][:ssl]     = "true"
set[:postgresql][:dir]         = "/etc/postgresql/#{node[:postgresql][:version]}/main"

default['postgresql']['client']['packages'] = %w{postgresql-client libpq-dev}
default['postgresql']['server']['packages'] = %w{postgresql}
default['postgresql']['contrib']['packages'] = %w{postgresql-contrib}

default['postgresql']['enable_pitti_ppa'] = false
default['postgresql']['enable_pgdg_yum'] = false
default['postgresql']['server']['service_name'] = "postgresql"

default[:postgresql][:hba] = [
  { :method => 'md5', :address => '127.0.0.1/32' },
  { :method => 'md5', :address => '::1/128' }
]

# Configure the local net access and method.
default[:postgresql][:localnet] = nil

# Replication/Hot Standby (set to postgresql defaults)
# PostgreSQL 9.1
# ----------------------------------------------------
default[:postgresql][:listen_addresses] = "localhost"
default[:postgresql][:listen_port] = 5432

# Master Server
default[:postgresql][:master] = false # Is this a master?
# None of the below settings get written unless the above is set to "true"
default[:postgresql][:wal_level]                = "hot_standby"
default[:postgresql][:max_wal_senders]          = 5
default[:postgresql][:wal_sender_delay]         = "1s"
default[:postgresql][:wal_keep_segments]        = 32
default[:postgresql][:vacuum_defer_cleanup_age] = 0
default[:postgresql][:replication_timeout]      = "20s"

default[:postgresql][:replication_user]         = ""
default[:postgresql][:replication_password]     = ""
default[:postgresql][:replication_name]         = ""

# If you want to do synchronous streaming replication, 
# profide a string containing a comma-separated list of 
# node names for "synchronous_standby_names"
default[:postgresql][:synchronous_standby_names] = nil 
# list of IP addresses for standby nodes
default[:postgresql][:standby_ips] = [] 

# Standby Servers
default[:postgresql][:standby]   = false # Is this a standby?
default[:postgresql][:master_ip] = nil # MUST Be specified in the role
# None of the below settings get written unless the above is set to "true"
default[:postgresql][:hot_standby]                  = "on"
default[:postgresql][:max_standby_archive_delay]    = "30s"
default[:postgresql][:max_standby_streaming_delay]  = "30s"
default[:postgresql][:wal_receiver_status_interval] = "10s"
default[:postgresql][:hot_standby_feedback]         = "off"

# Role/Database Setup
default[:postgreql][:setup_items] = [] # list of data bag names
default[:postgresql][:admin] = "pg_admin"

