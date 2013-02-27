# This goes in the data directory; where data is stored
node_name  = Chef::Config[:node_name]
query      = "chef_environment:#{node.chef_environment} AND role:postgresql-master"
pg_master  = search(:node, query).first
pg_standby = search(:node, "chef_environment:#{node.chef_environment} AND role:postgresql-standby").first

replication_secret   = encrypted_data_bag "postgres", "replication_secret"
replication_user     = replication_secret["user"]
replication_password = replication_secret["password"]
replication_appname  = replication_secret["appname"]
replication_address  = pg_master[:ipaddress]

template "/var/lib/postgresql/#{node[:postgresql][:version]}/main/recovery.conf" do
  source "recovery.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   0600
  variables(
    :listen_addresses     => node.postgresql.listen_addresses,
    :listen_port          => node.postgresql.listen_port,
    :master               => node[:postgresql][:master],
    :standby              => node.postgresql.standby,
    :pg_master            => pg_master,
    :pg_standby           => pg_standby,
    :replication_user     => replication_user,
    :replication_password => replication_password,
    :replication_appname  => replication_appname,
    :replication_address  => replication_address
  )
  notifies :restart, resources(:service => "postgresql")
end

