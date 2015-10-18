#!/bin/sh

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd $SCRIPT_DIR
export PYTHONPATH=../lib

##
## Default example
##

# Python v2
echo "python2 ../src/ansible-cmdb -i hosts out > html_fancy_2.html"
python2 ../src/ansible-cmdb -i hosts out > html_fancy_2.html
echo "python2 ../src/ansible-cmdb -p local_js=1 -i hosts out > html_fancy_localjs_2.html"
python2 ../src/ansible-cmdb -p local_js=1 -i hosts out > html_fancy_localjs_2.html
echo "python2 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table_2.txt"
python2 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table_2.txt

# Python v3
echo "python3 ../src/ansible-cmdb -i hosts out > html_fancy_3.html"
python3 ../src/ansible-cmdb -i hosts out > html_fancy_3.html
echo "python3 ../src/ansible-cmdb -p local_js=1 -i hosts out > html_fancy_localjs_3.html"
python3 ../src/ansible-cmdb -p local_js=1 -i hosts out > html_fancy_localjs_3.html
echo "python3 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table_3.txt"
python3 ../src/ansible-cmdb -t txt_table -i hosts out > txt_table_3.txt
