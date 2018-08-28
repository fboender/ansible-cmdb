## Solaris machines have no disk information

Ansible currently does not include disk size information for Solaris hosts. As
such, we can't include it in the output of Ansible-cmdb. See issue #24 for more
information.

## The output HTML file doesn't work on other computers.

When you transfer the output HTML file of ansible-cmdb and try to open it in
the browser on another computer, you'll find that it doesn't work properly.

This is because HTML files opened on a local computer (those that start with a
`file://` url) are not allowed to fetch the required Javascript files from the
internet (urls that start with `http://` and `https://`). For this reason,
Ansible-cmdb installs those required files when you install ansible-cmdb.
Naturally, another PC won't have those files locally available.

The solution is to generate the output with the `-p local_js=0` parameter and
host the resulting HTML file(s) on a webserver somewhere.
