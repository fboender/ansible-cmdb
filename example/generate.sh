#!/bin/sh

../src/ansible-cmdb -i hosts out > html_fancy.html
../src/ansible-cmdb -t txt_table -i hosts out > txt_table.txt
