#
# Cookbook Name:: ws_deployment
# Recipe:: default
#
# Copyright 2018, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

##############create builds folder#############################################

if not Dir.exists?("#{node.ws_deployment.Home_Deploy_Folder}/builds")
	bash 'create-folder-builds_ws-Batchjob' do
	cwd "#{node.ws_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.ws_deployment.Home_Deploy_Folder}/builds
	EOH
	end
end	

if not Dir.exists?("#{node.ws_deployment.Home_Deploy_Folder}/ws")
	bash 'create-ws_deploy_folderb' do
	cwd "#{node.ws_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.ws_deployment.Home_Deploy_Folder}/ws
	EOH
	end
end	
	
if Dir.exists?("#{node.ws_deployment.Home_Deploy_Folder}/ws")
	bash 'clear_ws_deploy_folder' do
	cwd "#{node.ws_deployment.Home_Deploy_Folder}/ws"
	code <<-EOH
		rm -rf *
	EOH
	end
end

######################### Copy Packages #############################################

bash 'create-download_package_script' do
cwd "#{node.ws_deployment.Home_Deploy_Folder}"
code <<-EOH
	rm -rf download_packages.sh
	echo "cd #{node.ws_deployment.Home_Deploy_Folder}/builds" >>download_packages.sh
	echo "export AWS_ACCESS_KEY_ID=AKIAJIBR4WNHSY3IS3AQ" >>download_packages.sh
	echo "export AWS_SECRET_ACCESS_KEY=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" >>download_packages.sh
	echo "export AWS_DEFAULT_REGION=ap-southeast-2" >>download_packages.sh
	echo "aws s3 cp s3://bnd-package/#{node.ws_deployment.S3} . --recursive" >>download_packages.sh
	chmod +x download_packages.sh		
EOH
end

execute "execute_download_package_script" do

        command "sh #{node.ws_deployment.Home_Deploy_Folder}/download_packages.sh"
end

######################### Config ws #############################################

bash 'Copy_ws_Package_To_Deploy_Folder' do
 cwd "#{node.ws_deployment.Home_Deploy_Folder}/builds"
 code <<-EOH
 cp -rf #{node.ws_deployment.ws_name}.aar "#{node.ws_deployment.Home_Deploy_Folder}/ws"
 EOH
end

bash 'Copy_online_config_To_Deploy_Folder' do
 cwd "#{node.ws_deployment.Home_Deploy_Folder}"
 code <<-EOH
	 cp -rf #{node.ws_deployment.conf_location}/logback.xml "#{node.ws_deployment.Home_Deploy_Folder}/ws"
	 cp -rf #{node.ws_deployment.conf_location}/META-INF "#{node.ws_deployment.Home_Deploy_Folder}/ws"
	 cp -rf #{node.ws_deployment.conf_location}/WEB-INF "#{node.ws_deployment.Home_Deploy_Folder}/ws"
	 cp -rf #{node.ws_deployment.conf_location}/axis2.war "#{node.ws_deployment.Home_Deploy_Folder}/ws"
 EOH
end

bash 'update ws config' do
  cwd "#{node.ws_deployment.Home_Deploy_Folder}/ws"
  code <<-EOH
	jar -uvf #{node.ws_deployment.ws_name}.aar logback.xml
	jar -uvf #{node.ws_deployment.ws_name}.aar META-INF/services.xml
	mv #{node.ws_deployment.ws_name}.aar WEB-INF/services
	jar -uvf axis2.war WEB-INF/services/#{node.ws_deployment.ws_name}.aar
  
  EOH
end

bash 'Remove_Running_ws_package' do
 cwd "#{node.ws_deployment.App_Deployments_Location}"
 code <<-EOH
	rm -rf * 
 EOH
end

bash 'Copy_ws_Packages_To_Deploy_Folder' do
 cwd "#{node.ws_deployment.Home_Deploy_Folder}/ws"
 code <<-EOH
 	cp -rf axis2.war "#{node.ws_deployment.App_Deployments_Location}" 
	chown -R oracle:oinstall #{node.ws_deployment.App_Deployments_Location}/*
	
 EOH
end

bash 'cleanup_folders' do
cwd "#{node.ws_deployment.Home_Deploy_Folder}"
  code <<-EOH
	rm -rf #{node.ws_deployment.Home_Deploy_Folder}/builds
	rm -rf #{node.ws_deployment.Home_Deploy_Folder}/ws
  EOH
end


