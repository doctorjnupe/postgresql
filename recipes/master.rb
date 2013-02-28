#
# Cookbook Name:: postgresql
# Recipe:: master
#
# Copy data files from master to standby. Should only happen once.
if node[:postgresql][:master] && (not node[:postgresql][:standby_ips].empty?)
  node[:postgresql][:standby_ips].each do |address|
    bash "Copy Master data files to Standby" do
      user "root"
      cwd "/var/lib/postgresql/#{node[:postgresql][:version]}/main/"
      code <<-EOH
        invoke-rc.d postgresql stop
        rsync -av --exclude=pg_xlog * #{address}:/var/lib/postgresql/#{node[:postgresql][:version]}/main/
        touch .initial_transfer_complete
        invoke-rc.d postgresql start
      EOH
      not_if do
        File.exists?("/var/lib/postgresql/#{node[:postgresql][:version]}/main/.initial_transfer_complete")
      end
    end
  end
end
