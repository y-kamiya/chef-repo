#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "nginx" do
    action :install
end

template "nginx.conf" do
    path "/etc/nginx/nginx.conf"
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 644
    notifies :reload, "service[nginx]"
end

service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end

template "/usr/share/nginx/html/heartbeat" do
    source "heartbeat.erb"
    owner "root"
    group "root"
    mode 644
end

