#
# Cookbook Name:: lvs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "/etc/sysctl.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "sysctl.conf.erb"
    action :create
end

service "sysctl" do
    start_command "sysctl -p"
    action :start
end

template "/tmp/iptables.rules" do
    owner "root"
    group "root"
    mode "0644"
    source "iptables.rules.erb"
    action :create
end

bash "restart_iptables" do
    user "root"
    code <<-EOC
        iptables-restore < /tmp/iptables.rules
    EOC
end

package "keepalived" do
    action :install
end

template "/etc/keepalived/keepalived.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "keepalived.conf.erb"
    action :create
end

service "keepalived" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end
