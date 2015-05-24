group node['etcd']['group']

user node['etcd']['user'] do
  shell "/sbin/nologin"
  home node['etcd']['data_dir']
  group node['etcd']['group']
end

version = node['etcd']['version']
source_path = "/usr/src/etcd-#{version}"
source_file = "#{source_path}.tar.gz"

template "/etc/init.d/etcd" do
  source "etcd.initscript.erb"
  owner "root"
  group "root"
  mode "0755"
end

remote_file source_file do
  source "https://github.com/coreos/etcd/releases/download/#{version}/etcd-#{version}-linux-amd64.tar.gz"
  checksum node['etcd']['sha256']
  owner "root"
  group "root"
  mode "0644"

  not_if { ::File.exists?(source_file) }

  notifies :run, resource(:bash => "extract-etcd"), :immediately
end

bash "extract-etcd" do
  user "root"
  group "root"
  cwd "/usr/src"

  code <<-EOF
    mkdir -p #{source_path}
    tar -xzf #{source_file} -C #{source_path}
    mv -f #{source_path}/etcd{,ctl} /usr/bin/
  EOF

  notifies :enable, resources(:service => "etcd"), :immediately
  notifies :start,  resources(:service => "etcd"), :immediately

  action :nothing
end

service "etcd" do
  supports  :status  => true,
            :restart => false,
            :reload  => false

  action :nothing
end
