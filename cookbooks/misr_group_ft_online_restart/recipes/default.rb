#
# Cookbook Name:: misr_group_ft_online_restart
# Recipe:: default
#
# Copyright 2018, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
ENV['JAVA_HOME'] = '/usr/local/java/jdk1.8.0_152'
ENV['PATH'] = '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/.local/bin:/root/bin'
ENV['MW_HOME'] = '/u01/app/oracle/middleware'
ENV['WLS_HOME'] = '/u01/app/oracle/middleware/wlserver'
ENV['WL_HOME'] = '/u01/app/oracle/middleware/wlserver'
#ENV[''] = ''

execute "restart misr_group_ft_online_service" do
        command "/u01/integral/scripts/restartonlineserver.sh"
# 	command "echo $JAVA_HOME >> /u01/integral/scripts/java"
end
