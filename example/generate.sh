#!/bin/sh -x

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd $SCRIPT_DIR
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
