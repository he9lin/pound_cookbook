#
# Cookbook Name:: pound
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'yum::epel'

package 'nc'
package 'Pound'

service 'pound' do
  action [:enable, :start]
end

template '/etc/pound.cfg' do
  source 'pound.cfg.erb'
  notifies :restart, 'service[pound]'
end
