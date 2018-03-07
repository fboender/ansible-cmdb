virtualenv ansible25cmdb
source ansible25cmdb
sudo pip install ansible==2.5.0rc1
sudo pip install ansible-cmdb
ansible -m setup --tree out/ all
ansible-cmdb -t html_fancy_split out/

ansible -m package_facts --tree outpackage/ all
ansible -m setup --tree outsetup/ all
ansible-cmdb t html_fancy_split -i hosts outsetup outpackage > cmdb.html
