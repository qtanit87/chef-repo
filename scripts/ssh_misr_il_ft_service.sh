cd /integral/chef-repo/
knife ssh name:misr_il_ft_service -x root -i /etc/chef/MISR.pem 'bash -l -c chef-client'
