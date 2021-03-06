#
# Cookbook Name:: deploygroupV2_132
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
######################### Get_NewBuild ##############################################
if not Dir.exists?("#{node.life_online_batch_deployment.Home_Deploy_Folder}/builds")
	bash 'create-folder-builds_Admin-Batchjob' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.life_online_batch_deployment.Home_Deploy_Folder}/builds
	EOH
	end
end	

######################### Copy Packages #############################################

if not Dir.exists?("#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin")
	bash 'create-admin_deploy_folderb' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.life_online_batch_deployment.Home_Deploy_Folder}/admin
	EOH
	end
end	
	
if Dir.exists?("#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin")
	bash 'clear_admin_deploy_folder' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin"
	code <<-EOH
		rm -rf *
	EOH
	end
end
	
if not Dir.exists?("#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob")
	bash 'create-folder-deploy_batchjob' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob
	EOH
	end
end

if Dir.exists?("#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob")
	bash 'clear_batchjob_deploy_folder' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
	code <<-EOH
		rm -rf *
	EOH
	end
end

if not Dir.exists?("#{node.life_online_batch_deployment.Batch_Job_Location}")
	bash 'create-folder-batchjob_app' do
	cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
	code <<-EOH
		mkdir -p #{node.life_online_batch_deployment.Batch_Job_Location}
	EOH
	end
end

bash 'create-download_package_script' do
cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
code <<-EOH
	rm -rf download_packages.sh
	echo "cd #{node.life_online_batch_deployment.Home_Deploy_Folder}/builds" >>download_packages.sh
	echo "export AWS_ACCESS_KEY_ID=AKIAJIBR4WNHSY3IS3AQ" >>download_packages.sh
	echo "export AWS_SECRET_ACCESS_KEY=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" >>download_packages.sh
	echo "export AWS_DEFAULT_REGION=ap-southeast-2" >>download_packages.sh
	echo "aws s3 cp s3://bnd-package/#{node.life_online_batch_deployment.S3} . --recursive" >>download_packages.sh
	chmod +x download_packages.sh		
EOH
end

execute "execute_download_package_script" do

        command "sh #{node.life_online_batch_deployment.Home_Deploy_Folder}/download_packages.sh"
end


######################### Config Admin #############################################
bash 'Copy_Admin_Packages_To_Deploy_Folder' do
 cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/builds"
 code <<-EOH
 cp -rf #{node.life_online_batch_deployment.Web_Admin_warName}.war "#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin"
 EOH
end

bash 'Copy_online_config_To_Deploy_Folder' do
 cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
 code <<-EOH
 cp -rf #{node.life_online_batch_deployment.online_conf}/WEB-INF "#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin"
 EOH
end

bash 'update admin config' do
  cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin"
  code <<-EOH
  jar -uvf #{node.life_online_batch_deployment.Web_Admin_warName}.war WEB-INF/web.xml 
  jar -uvf #{node.life_online_batch_deployment.Web_Admin_warName}.war WEB-INF/weblogic.xml 
  jar -uvf #{node.life_online_batch_deployment.Web_Admin_warName}.war WEB-INF/classes/logback.xml 
  
  EOH
end

bash 'Remove_Running_Admin_package' do
 cwd "#{node.life_online_batch_deployment.App_Deployments_Location}"
 code <<-EOH
 
 rm -rf #{node.life_online_batch_deployment.Web_Admin_warName}.war 
 EOH
end

bash 'Copy_Admin_Packages_To_Deploy_Folder' do
 cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/admin"
 code <<-EOH
 
 cp -rf #{node.life_online_batch_deployment.Web_Admin_warName}.war "#{node.life_online_batch_deployment.App_Deployments_Location}" -f
 chown -R oracle:oracle #{node.life_online_batch_deployment.App_Deployments_Location}/*
 rm -rf * 
 EOH
end

######################### Config Batch Job ##########################################
bash 'Copy_Batchjob_Zip_Packages_To_Deploy_Folder' do
  cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/builds"
  code <<-EOH
	cp -rf csc-smart400-batch.zip "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
 
  EOH
end

bash 'Extract_Batchjob_Zip_Packages_To_Deploy_Folder' do
  cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
  code <<-EOH
	jar xf #{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob/*.zip
  EOH
end

bash 'Copy_batch_config_To_Deploy_Folder' do
 cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}"
 code <<-EOH
	cp -rf #{node.life_online_batch_deployment.batch_conf}/logback.xml "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
 EOH
end

bash 'update batch config' do
  cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
  code <<-EOH
	jar -uvf csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar logback.xml
    
  EOH
end

 
bash 'Remove_Running_batch_package' do
 cwd "#{node.life_online_batch_deployment.Batch_Job_Location}"
 code <<-EOH
	rm -rf *
 EOH
end 

bash 'Copy_Packages_To_DeployLocation' do
  cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/batchjob"
  code <<-EOH
	mv csc-smart400-batch "#{node.life_online_batch_deployment.Batch_Job_Location}" -f
	chown -R oracle:oracle #{node.life_online_batch_deployment.Batch_Job_Location}/*
	rm -rf *
  EOH
end

bash 'cleanup_build_folder' do
cwd "#{node.life_online_batch_deployment.Home_Deploy_Folder}/builds"
  code <<-EOH
		rm -rf *
  EOH
end


