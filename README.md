Ansible Configuration Management Database
=========================================

![Status: Stable](https://img.shields.io/badge/status-stable-green.svg)
![Build Status](http://build.electricmonk.nl/job/ansible-cmdb/shield)
![Activity: Active development](https://img.shields.io/badge/activity-active%20development-green.svg)
![License: GPLv3](https://img.shields.io/badge/license-GPLv3-blue.svg)

About
-----

Ansible-cmdb takes the output of Ansible's fact gathering and converts it into
a static HTML overview page (and other things) containing system configuration
information.

It supports multiple types of output (html, csv, sql, etc) and extending
information gathered by Ansible with custom data. For each host it also shows
the groups, host variables, custom variables and machine-local facts.

![](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-overview.png)

![](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-detail.png)

[HTML example](https://rawgit.com/fboender/ansible-cmdb/master/example/html_fancy.html) output.


Features
--------

(Not all features are supported by all templates)

* Multiple formats / templates:
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
* Host overview and detailed host information.
* Host and group variables.
* Gathered host facts and manual custom facts.
* Adding and extending facts of existing hosts and manually adding entirely
  new hosts.


Documentation
-------------

All documentation can be viewed at [readthedocs.io](http://ansible-cmdb.readthedocs.io/en/latest/).

* [Full documentation](http://ansible-cmdb.readthedocs.io/en/latest/)
* [Requirements and installation](http://ansible-cmdb.readthedocs.io/en/latest/installation/)
* [Usage](http://ansible-cmdb.readthedocs.io/en/latest/usage/)
* [Contributing and development](http://ansible-cmdb.readthedocs.io/en/latest/dev/)


License
-------

Ansible-cmdb is licensed under the GPLv3:

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    For the full license, see the LICENSE file.
