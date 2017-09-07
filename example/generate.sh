#!/bin/sh

set -x
set -e

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd $SCRIPT_DIR
export PYTHONPATH=../lib

##
## Default example
##

# Python v2
python2 ../src/ansible-cmdb -q -i hosts out > gen_html_fancy_2.html
python2 ../src/ansible-cmdb -q -p local_js=1 -i hosts out > gen_html_fancy_localjs_2.html
python2 ../src/ansible-cmdb -q -t txt_table -i hosts out > gen_txt_table_2.txt
python2 ../src/ansible-cmdb -q -t csv -i hosts out > gen_csv_2.csv
python2 ../src/ansible-cmdb -q -t markdown -i hosts out > gen_markdown_2.md
python2 ../src/ansible-cmdb -q -t sql -i hosts out > gen_sql_2.md
python2 ../src/ansible-cmdb -q -t html_fancy_split -i hosts out > gen_html_fancy_split_2.md
python2 ../src/ansible-cmdb -q -i hosts -f out_factcache > gen_fact_cache_2.html


# Python v3
python3 ../src/ansible-cmdb -q -i hosts out > gen_html_fancy_3.html
python3 ../src/ansible-cmdb -q -p local_js=1 -i hosts out > gen_html_fancy_localjs_3.html
python3 ../src/ansible-cmdb -q -t txt_table -i hosts out > gen_txt_table_3.txt
python3 ../src/ansible-cmdb -q -t csv -i hosts out > gen_csv_3.csv
python3 ../src/ansible-cmdb -q -t markdown -i hosts out > gen_markdown_3.md
python3 ../src/ansible-cmdb -q -t sql -i hosts out > gen_sql_3.md
python3 ../src/ansible-cmdb -q -t html_fancy_split -i hosts out
python3 ../src/ansible-cmdb -q -i hosts -f out_factcache > gen_fact_cache_3.html
