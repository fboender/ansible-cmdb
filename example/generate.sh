#!/bin/sh

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd $SCRIPT_DIR
export PYTHONPATH=../lib

##
## Default example
##

# Python v2
echo "python2 ../src/ansible-cmdb -i hosts out > gen_html_fancy_2.html"
python2 ../src/ansible-cmdb -i hosts out > gen_html_fancy_2.html
echo "python2 ../src/ansible-cmdb -p local_js=1 -i hosts out > gen_html_fancy_localjs_2.html"
python2 ../src/ansible-cmdb -p local_js=1 -i hosts out > gen_html_fancy_localjs_2.html
echo "python2 ../src/ansible-cmdb -t txt_table -i hosts out > gen_txt_table_2.txt"
python2 ../src/ansible-cmdb -t txt_table -i hosts out > gen_txt_table_2.txt
echo "python2 ../src/ansible-cmdb -t csv -i hosts out > gen_csv_2.csv"
python2 ../src/ansible-cmdb -t csv -i hosts out > gen_csv_2.csv
echo "python2 ../src/ansible-cmdb -t markdown -i hosts out > gen_markdown_2.md"
python2 ../src/ansible-cmdb -t markdown -i hosts out > gen_markdown_2.md

# Python v3
echo "python3 ../src/ansible-cmdb -i hosts out > gen_html_fancy_3.html"
python3 ../src/ansible-cmdb -i hosts out > gen_html_fancy_3.html
echo "python3 ../src/ansible-cmdb -p local_js=1 -i hosts out > gen_html_fancy_localjs_3.html"
python3 ../src/ansible-cmdb -p local_js=1 -i hosts out > gen_html_fancy_localjs_3.html
echo "python3 ../src/ansible-cmdb -t txt_table -i hosts out > gen_txt_table_3.txt"
python3 ../src/ansible-cmdb -t txt_table -i hosts out > gen_txt_table_3.txt
echo "python3 ../src/ansible-cmdb -t csv -i hosts out > gen_csv_3.csv"
python3 ../src/ansible-cmdb -t csv -i hosts out > gen_csv_3.csv
echo "python3 ../src/ansible-cmdb -t markdown -i hosts out > gen_markdown_3.md"
python3 ../src/ansible-cmdb -t markdown -i hosts out > gen_markdown_3.md
