yum -y install wget curl

rpm -ivh https://packages.chef.io/files/stable/chef-server/12.15.8/el/7/chef-server-core-12.15.8-1.el7.x86_64.rpm

chef-server-ctl reconfigure

chef-server-ctl status

chef-server-ctl user-create #{user} #{first_name} #{last_name} #{email} '#{password}' --filename #{filename}

chef-server-ctl org-create short_name '#{organization}' --association_user #{user} --filename #{organization}-validator.pem