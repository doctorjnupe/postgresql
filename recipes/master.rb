#
# Cookbook Name:: postgresql
# Recipe:: master
#
# Copy data files from master to standby. Should only happen once.
query = "chef_environment:#{node.chef_environment} AND role:postgresql-standby"
standby_servers = search(:node, query)

standby_servers.each do |server|
  bash "copy-master-data-files-to-standby" do
      user "root"
      cwd  "/var/lib/postgresql/#{node[:postgresql][:version]}/main/"
      code <<-EOH
        invoke-rc.d postgresql stop
        rsync -av --exclude=pg_xlog * #{server[:ipaddress]}:/var/lib/postgresql/#{node[:postgresql][:version]}/main/
        touch .initial_transfer_complete
        invoke-rc.d postgresql start
      EOH
      not_if do
        File.exists?("/var/lib/postgresql/#{node[:postgresql][:version]}/main/.initial_transfer_complete")
      end
    end

end
