## About

[Ansible-cmdb](https://github.com/fboender/ansible-cmdb) takes the output of
Ansible's [fact
gathering](http://docs.ansible.com/ansible/latest/modules/setup_module.html)
and converts it into a static HTML overview page (and other things) containing
system configuration information.

It supports multiple types of output (html, csv, sql, etc) and extending
information gathered by Ansible with custom data. For each host it also shows
the groups, host variables, custom variables and machine-local facts.

## Example output

![](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-overview.png)

![](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-detail.png)

[HTML example](https://rawgit.com/fboender/ansible-cmdb/master/example/html_fancy.html) output.

## Output formats

Supported output formats / templates:

* Fancy HTML (`--template html_fancy`), as seen in the screenshots above.
* Fancy HTML Split (`--template html_fancy_split`), with each host's details
  in a separate file (for large number of hosts).
* CSV (`--template csv`), the trustworthy and flexible comma-separated format.
* JSON (`--template json`), a dump of all facts in JSON format.
* Markdown (`--template markdown`), useful for copy-pasting into Wiki's and
  such.
* Markdown Split ('--template markdown_split'), with each host's details
  in a seperate file (for large number of hosts).
* SQL (`--template sql`), for importing host facts into a (My)SQL database.
* Plain Text table (`--template txt_table`), for the console gurus.
* and of course, any custom template you're willing to make.
