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

Installation
------------

Ansible-cmdb requires **Python v2.7+ / 3.0+**.

Ansible-cmdb can be installed using `pip` (the Python package manager), with
stand-alone packages for your distribution or through brew and plain old `make
install`.

### Through Pip

For **installation via Pip**:

Install `pip` [for your
  distribution](https://packaging.python.org/install_requirements_linux/) if
  you don't have it yet.

Install Ansible-cmdb through Pip:

    sudo pip install ansible-cmdb

You can also upgrade Ansible-cmdb through Pip:

    sudo pip install --upgrade ansible-cmdb

### Through distribution packages

Get the package for your distribution from the [Releases
page](https://github.com/fboender/ansible-cmdb/releases) (Not required for
MacOS X install)

For **Debian / Ubuntu** systems:

    sudo dpkg -i ansible-cmdb*.deb

For **Redhat / Centos** systems:

    sudo yum --disablerepo=* install ansible-cmdb*.rpm

For **Arch** systems:
    [aur/ansible-cmdb](https://aur.archlinux.org/packages/ansible-cmdb/)

### For other systems

For **MacOS X** systems:

    brew install ansible-cmdb

For **Other** systems:

    tar -vxzf ansible-cmdb*.tar.gz
    cd ansible-cmdb*
    sudo make install

Installation from **Git** repository:

    git clone git@github.com:fboender/ansible-cmdb.git
    cd ansible-cmdb
    sudo make install


Usage
-----

### Basic

First, generate Ansible output for your hosts:

    mkdir out
    ansible -m setup --tree out/ all

Next, call ansible-cmdb on the resulting `out/` directory to generate the CMDB
overview page:

    ansible-cmdb out/ > overview.html

The default template is `html_fancy`, which uses jQuery. 

### Full usage

    Usage: ansible-cmdb [option] <dir> > output.html
    
    Options:
      --version             show program's version number and exit
      -h, --help            show this help message and exit
      -t TEMPLATE, --template=TEMPLATE
                            Template to use. Default is 'html_fancy'
      -i INVENTORY, --inventory=INVENTORY
                            Inventory to read extra info from
      -f, --fact-cache      <dir> contains fact-cache files
      -p PARAMS, --params=PARAMS
                            Params to send to template
      -d, --debug           Show debug output
      -c COLUMNS, --columns=COLUMNS
                            Show only given columns
      --exclude-cols=EXCLUDE_COLUMNS
                            Exclude cols from output


### Inventory scanning

Ansible-cmdb can read your inventory file (`hosts`, by default), inventory
directory or dynamic inventory and extract useful information from it such as:

- All the groups a host belongs to.
- Host variables. These are optional key/value pairs for each host which can be
  used in playbooks. They are scanned by ansible-cmdb and get added to a hosts
  discovered facts under the 'hostvars' section.

Reading the inventory is done using the `-i` switch to ansible-cmdb.  It takes
a single parameter: your hosts file, directory containing your hosts files or
path to your dynamic inventory script. You may specify multiple inventory
files by separating them with a comma (do not include spaces!).

For example:

    $ ansible-cmdb -i ./hosts out/ > overview.html

If a `host_vars` and / or `group_vars` directory exists at that location, they
will also be read.

The ''html_fancy'' template uses four extra fields:

- `groups`: A list of Ansible groups the host belongs to.
- `dtap`: Whether a host is a development, test, acceptance or production
   system.
- `comment`: A comment for the host.
- `ext_id`: An external unique identifier for the host.

For example, let's say we have the following `hosts` file:

    [cust.megacorp]
    db1.dev.megacorp.com   dtap=dev  comment="Old database server"
    db2.dev.megacorp.com   dtap=dev  comment="New database server"
    test.megacorp.com      dtap=test 
    acc.megacorp.com       dtap=acc  comment="24/7 support"
    megacorp.com           dtap=prod comment="Hosting by Foo" ext_id="SRV_10029"
    
    [os.redhat]
    megacorp.com
    acc.megacorp.com
    test.megacorp.com
    db2.dev.megacorp.com
    
    [os.debian]
    db1.dev.megacorp.com

The host `acc.megacorp.com` will have groups 'cust.megacorp' and 'os.redhat',
will have a comment saying it has 24/7 support and will be marked as a `acc`
server. Megacorp.com host will have an external ID of "SRV_10029", which will
be required by for communicating with Foo company about hosting.

See http://docs.ansible.com/intro_inventory.html#host-variables for more
information on host variables.

Any variables set for your hosts will become available in the html_fancy
template under the "Custom variables" heading.

### Templates

#### Specifying templates

ansible-cmdb offers multiple templates. You can choose your template with the
`-t` or `--template` argument:

    ansible-cmdb -t tpl_custom out/ > overview.html

The 'html_fancy' template is the default.  

Templates can be referred to by name or by relative/absolute path to the
`.tpl` file. This lets you implement your own templates. For example:

    $ ansible-cmdb -t /home/fboender/my_template out/ > my_template.html

#### Template parameters

Some templates support parameters that influence their output. Parameters are
specified using the `-p` or `--parameter` option to `ansible-cmdb`. Multiple
parameters may be specified by separating them with commas. There must be *no*
spaces in the parameters.

For example, to specify the `html_fancy` template with local Javascript
libraries and closed trees:

    ansible-cmdb -t html_fancy -p local_js=1,collapsed=1 out > overview.html


#### Standard available templates

Ansible-cmdb currently provides the following templates out of the box:

* **`html_fancy`**: A dynamic, modern HTML page containing all hosts.
* **`html_fancy_split`**: A dynamic, modern HTML page with each host's details in a separate file.
* **`txt_table`**: A quick text table summary of the available hosts with some minimal information.
* **`json`**: Dumps all hosts including groups, variable, custom info in JSON format.
* **`csv`**: The CSV template outputs a CSV file of your hosts.
* **`markdown`**: The Markdown template generates host information in the Markdown format.
* **`sql`**: The SQL template generates an .sql file that can be loaded into an SQLite or MySQL database.

**html_fancy**:

`html_fancy` is currently the default template.

A fancy HTML page that uses jQuery and DataTables to give you a searchable,
sortable table overview of all hosts with detailed information just a click
away.

It takes optional parameters:

* `local_js=0|1`: Load resources from local disk (default=`0`). If set, will load resources from the local disk instead of over the network.
* `collapsed=0|1`: Controls whether host information is collapsed by default or not. A value of `1` will collapse all host information by defaultcontrols whether host information is collapsed by default or not. A value of `1` will collapse all host information by default. (default='0')
* `host_details=0|1`: Render host details or not. (default=`1`)
* `skip_empty=0|1`: Skip hosts for which no facts were gathered (unreachable, etc). (default=`0`).

**html_fancy_split**:

This template is basically the same as the **html_fancy** template, but it
generates a `cmdb/` directory with an `index.html` file and a separate html
file for each host's details.

Usage:

    ansible-cmdb -t html_fancy_split -i hosts out/ 

It accepts the same parameters as the `html_fancy` template.

**sql**:

The `sql` template generates an .sql file that can be loaded into an SQLite or MySQL database.

    $ ansible-cmdb -t sql -i hosts out > cmdb.sql
    $ echo "CREATE DATABASE ansiblecmdb" | mysql 
    $ mysql ansiblecmdb < cmdb.sql

### Fact caching

Ansible can cache facts from hosts when running playbooks. This is configured
in Ansible like:

    [defaults]
    fact_caching=jsonfile
    fact_caching_connection = /path/to/facts/dir

You can use these cached facts as facts directories with ansible-cmdb by
specifying the `-f` (`--fact-cache`) option:

    $ ansible-cmdb -f /path/to/facts/dir > overview.html

Please note that the `--fact-cache` option will apply to *all* fact directories
you specify. This means you can't mix fact-cache fact directories and normal
`setup` fact directories. Also, if you wish to manually extend facts (see the
`Extending` chapter), you must omit the `ansible_facts` key and put items in
the root of the JSON.

### Columns

Some templates, such as txt_table and html_fancy,  support columns. If a
template supports columns, you can use the `--columns` / `-c` command line
option to specify which columns to show. 

The `--columns` takes a comma-separated list of columns (no spaces!) which
should be shown.  The columns must be specified by their `id` field. For
information on what `id` fields are supported by a template, take a look in the
template. Usually it's the column title, but in lowercase and with spaces
replaced by underscores.

For example:

    $ ansible-cmdb -t txt_table --columns name,os,ip,mem,cpus facts/
    Name                    OS             IP             Mem  CPUs
    ----------------------  -------------  -------------  ---  -  
    jib.electricmonk.nl     Linuxmint 17   192.168.0.3    16g  1  
    app.uat.local           Debian 6.0.10  192.168.57.1   1g   1  
    eek.electricmonk.nl     Ubuntu 14.04   192.168.0.10   3g   1  
    db01.prod.local         Debian 6.0.10  192.168.58.1   0g   1  
    debian.dev.local        Debian 6.0.10  192.168.56.2   1g   1  
    db02.prod.local         Debian 6.0.10  192.168.58.2   0g   1  
    centos.dev.local        CentOS 6.6     192.168.56.8   1g   1  
    win.dev.local           Windows 2012   10.0.0.3       4g   0  
    host5.example.com       Debian 6.0.10  192.168.57.1   1g   1  
    db03.prod.local         Debian 6.0.10  192.168.58.3   0g   1  
    zoltar.electricmonk.nl  Ubuntu 14.04   194.187.79.11  4g   2 

For interactive templates (`html_fancy` and friends), the `--columns` option
merely hides the columns by default. It doesn't remote them from the output,
unlike the `csv` and other static templates. If you want to exclude columns
from `html_fancy` and friends, use the `--exclude-cols` option. It works the
same as `--columns`. For example:

    ansible-cmdb -t html_fancy_split \
                 --exclude-cols mem_usage,swap_usage,disk_usage,physdisk_size \
                 -i hosts \
                 facts/

### Extending

You can specify multiple directories that need to be scanned for facts. This
lets you override, extend and fill in missing information on hosts. You can
also use this to create completely new hosts or to add custom facts to your
hosts.

Extended facts are basically the same as normal Ansible fact files. When you
specify multiple fact directories, Ansible-cmdb scans all of the in order and
overlays the facts. 

Note that the host *must still* be present in your hosts file, or it will not
generate anything.

If you're using the `--fact-cache` option, you must omit the `ansible_facts`
key and put items in the root of the JSON. This also means that you can only
extend native ansible facts and not information read from the `hosts` file by
ansible-cmdb.


#### Override / fill in facts

Sometimes Ansible doesn't properly gather certain facts for hosts. For
instance, OpenBSD facts don't include the `userspace_architecture` fact. You
can add it manually to a host.

Create a directory for your extended facts:

    $ mkdir out_extend

Create a file in it for a host. The file must be named the same as it appears
in your `hosts` file:

    $ vi out_extend/openbsd.dev.local
    {
      "ansible_facts": {
          "ansible_userspace_architecture": "x86_64"
      }
    }

Specify both directories when generating the output:

    ./ansible-cmdb out/ out_extend/ > overview.html

Your OpenBSD host will now include the 'Userspace Architecture' fact.


#### Manual hosts

For example, lets say you have 100 linux machines, but only one windows machine.
It's not worth setting up ansible on that one windows machine, but you still
want it to appear in your overview...

Create a directory for you custom facts:

    $ mkdir out_manual

Create a file in it for your windows host:

    $ vi out_manual/win.dev.local
    {
      "groups": [
      ],
      "ansible_facts": {
        "ansible_all_ipv4_addresses": [
          "10.10.0.2",
          "191.37.104.122"
        ], 
        "ansible_default_ipv4": {
          "address": "191.37.104.122"
        }, 
        "ansible_devices": {
        }, 
        "ansible_distribution": "Windows", 
        "ansible_distribution_major_version": "2008", 
        "ansible_distribution_release": "", 
        "ansible_distribution_version": "2008", 
        "ansible_domain": "win.dev.local", 
        "ansible_fips": false, 
        "ansible_form_factor": "VPS", 
        "ansible_fqdn": "win.dev.local", 
        "ansible_hostname": "win", 
        "ansible_machine": "x86_64", 
        "ansible_nodename": "win.dev.local", 
        "ansible_userspace_architecture": "x86_64", 
        "ansible_userspace_bits": "64", 
        "ansible_virtualization_role": "guest", 
        "ansible_virtualization_type": "xen", 
        "module_setup": true
      }, 
      "changed": false
    }

Now you can create the overview including the windows host by specifying two
fact directories:

    ./ansible-cmdb out/ out_manual/ > overview.html


#### Custom facts

You can add custom facts (not to be confused with 'custom variables') to you
hosts. These facts will be displayed in the `html_fancy` template by default
under the 'Custom facts' header.

**Note** that these are not the same as Host local facts. Host local facts are
facts that Ansible reads from each of your host's `/etc/ansible/facts.d`
directory. Those are also included in Ansible-cmdb's html_fancy templates, but
under the "Host local facts" heading. The custom facts explained here are
manually defined on the host where you run ansible-cmdb, and have little to do
with Ansible itself.

Let's say you want to add information about installed software to your facts.

Create a directory for you custom facts:

    $ mkdir out_custom

Create a file in it for the host where you want to add the custom facts:

    $ vi custfact.test.local
    {
      "custom_facts": {
        "software": {
          "apache": {
            "version": "2.4",
            "install_src": "backport_deb"
          },
          "mysql-server": {
            "version": "5.5",
            "install_src": "manual_compile"
          },
          "redis": {
            "version": "3.0.7",
            "install_src": "manual_compile"
          }
        }
      }
    }

For this to work the facts **must** be listed under the **custom_facts** key.

Generate the overview:

    ./ansible-cmdb out/ out_custom/ > overview.html

The software items will be listed under the "*Custom facts*" heading.


Infrequently Asked Questions
----------------------------

### Solaris machines have no disk information

Ansible currently does not include disk size information for Solaris hosts. As
such, we can't include it in the output of Ansible-cmdb. See issue #24 for more
information.


Contributing and Development
----------------------------

See the [Development documentation](DEVELOPMENT.md) for information on contributing and
development.

Licensing and credits
---------------------

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

Ansible-cmdb started as a short Python script, which I blogged about here:

    http://www.electricmonk.nl/log/2015/01/21/host-inventory-overview-using-ansibles-facts/

Cris van Pelt then took that and expanded it into a HTML page. Eventually I
forked it to Github and made it public, adding features. Many people
collaborated to make Ansible-cmdb into what it is today. For a full list, see
the annotations in the CHANGELOG.
