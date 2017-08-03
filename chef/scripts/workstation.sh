yum -y install wget curl git

rpm -ivh https://packages.chef.io/files/stable/chefdk/2.0.28/el/7/chefdk-2.0.28-1.el7.x86_64.rpm

chef verify

echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
cd ~
chef generate repo chef

git config --global user.name "#{git.user}"
git config --global user.email "#{git.email}"
