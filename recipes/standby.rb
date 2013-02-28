service "postgresql" do
  service_name node['postgresql']['server']['service_name']
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

if node[:postgresql][:standby]
  # This goes in the data directory; where data is stored
  node_name = Chef::Config[:node_name]
  master_ip = node[:postgresql][:master_ip]
  template "/var/lib/postgresql/#{node[:postgresql][:version]}/main/recovery.conf" do
    source "recovery.conf.erb"
    owner "postgres"
    group "postgres"
    mode 0600
    variables(
      :primary_conninfo => "host=#{master_ip} application_name=#{node_name}",
      :trigger_file => "/var/lib/postgresql/#{node[:postgresql][:version]}/main/trigger"
    )
    notifies :restart, resources(:service => "postgresql")
  end
end
