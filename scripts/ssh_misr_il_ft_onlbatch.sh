cd /integral/chef-repo/
knife ssh name:misr_life_ft_onlinebatch -x root -i /etc/chef/MISR.pem 'bash -l -c chef-client'
#knife ssh name:misr_life_ft_onlinebatch -x oracle -i /etc/chef/MISR.pem 'bash -l -c /u01/integral/scripts/redeployonline.sh'
#knife ssh name:misr_life_ft_onlinebatch -x oracle -i /etc/chef/MISR.pem 'bash -l -c /u01/integral/scripts/restartbatch.sh'
#knife ssh name:misr_life_ft_onlinebatch -x oracle -i /etc/chef/MISR.pem 'bash -l -c /u01/integral/scripts/restartonlineserver.sh'
