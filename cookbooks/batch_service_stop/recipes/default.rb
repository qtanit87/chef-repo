#
# Cookbook Name:: batch_service_stop
# Recipe:: default
#
# Copyright (c) 2018 The Authors, All Rights Reserved.
execute 'stop batch process' do
	command "sh #{node['batch_service_stop']['script']}"
end
