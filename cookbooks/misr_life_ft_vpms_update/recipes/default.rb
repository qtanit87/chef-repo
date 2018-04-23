#
# Cookbook Name:: misr_life_ft_vpms_update
# Recipe:: default
#
# Copyright (c) 2018 The Authors, All Rights Reserved.
execute "restart vpms service" do
  	
	command "sh /u01/integral/scripts/mli_life_ft_vpms_restart.sh"
end
