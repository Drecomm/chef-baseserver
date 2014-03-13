#
# Cookbook Name:: baseserver
# Recipe:: users
#
# Copyright (C) 2013 Triple-networks
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



begin
  data_bag('users').each do |user|
    userdata = data_bag_item('users', user)

    if userdata['groups'].include?(node['create_users_in_group'])
      puts 'Create user: ' + userdata['id']
    else
      puts 'Ignored user (invalid groups): ' + userdata['id']
    end
  end
rescue Net::HTTPServerException => e
  Chef::Application.fatal!('could not load data bag; #{e}')
end


if Chef::Config[:solo]
  include_recipe 'chef-solo-search'
end

# check for users with the users group
users_manage node['create_users_in_group'] do
  action [ :remove, :create ]
end

#include_recipe 'users::sysadmins'



