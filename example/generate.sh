#!/bin/sh -x

export PYTHONPATH=../lib

##
## Default example
##

# Python v2
python2 ../src/ansible-cmdb -i hosts out > html_fancy.html
python2 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table.txt

# Python v3
python3 ../src/ansible-cmdb -i hosts out > html_fancy.html
python3 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table.txt

##
## Complicated hosts file
##

# Python v2
python2 ../src/ansible-cmdb -i hosts_complicated out > html_fancy_complicated.html
python2 ../src/ansible-cmdb -t txt_table -i hosts_complicated out > txt_table_complicated.txt

# Python v3
python3 ../src/ansible-cmdb -i hosts_complicated out > html_fancy_complicated.html
python3 ../src/ansible-cmdb -t txt_table -i hosts_complicated out > txt_table_complicated.txt

##
## Directory of hosts files
##

# Python v2
python2 ../src/ansible-cmdb -i hostsdir out > html_fancy_hostsdir.html
python2 ../src/ansible-cmdb -t txt_table -i hostsdir out > txt_table_hostsdir.txt

# Python v3
python3 ../src/ansible-cmdb -i hostsdir out > html_fancy_hostsdir.html
python3 ../src/ansible-cmdb -t txt_table -i hostsdir out > txt_table_hostsdir.txt
