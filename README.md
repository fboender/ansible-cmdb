Ansible Configuration Management Database
=========================================

About
-----

Ansible-cmdb takes the output of Ansible's fact gathering and converts it into
a static HTML overview page containing system configuration information.

It supports multiple templates and extending information gathered by Ansible
with custom data.

![](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot.png)

[HTML example](https://rawgit.com/fboender/ansible-cmdb/master/example/html_fancy.html) output.

Installation
------------

Get the package for your distribution from the [Releases page](https://github.com/fboender/ansible-cmdb/releases)

For **Debian / Ubuntu** systems:

    sudo dpkg -i ansible-cmdb*.deb

For **Redhat / Centos** systems:

    sudo yum install ansible-cmdb*.rpm

For **Other** systems:

    tar -vxzf ansible-cmdb*.tar.gz
    cd ansible-cmdb*
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

The default template is `html_fancy`, which uses Jquery. 

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

### Inventory scanning

Ansible-cmdb can read your inventory file (`hosts`, by default), inventory
directory or dynamic inventory and extract useful information from it such as:

- All the groups a host belongs to.
- Host variables. These are optional key/value pairs for each host which can be
  used in playbooks. They are scanned by ansible-cmdb and get added to a hosts
  discovered facts under the 'hostvars' section.

Reading the inventory is done using the `-i` switch to ansible-cmdb.  It takes
a single parameter: your hosts file, directory containing your hosts files or
path to your dynamic inventory script.

For example:

    $ ansible-cmdb -i ./hosts out/ > overview.html

If a `host_vars` dir exists at that location, it will also be read.

The ''html_fancy'' template uses four extra fields:

- `groups`: A list of Ansible groups the host belongs too
- `dtap`: Whether a host is a development, test, acceptance or production
   system.
- `comment`: A comment for the host.
- `ext_id`: An external unique identifier for the host.

For example, lets say we have the following `hosts` file:

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

ansible-cmdb offers multiple templates. You can choose your template with the
`-t` or `--template` argument:

    ansible-cmdb -t tpl_custom out/ > overview.html

The 'html_fancy' template is the default.  

Ansible-cmdb currently provides the following templates out of the box:

* `html_fancy`: A fancy HTML page that uses JQuery and DataTables to give you a
  searchable, sortable table overview of all hosts with detailed information
  just a click away.

  It takes a parameter `local_js` which, if set, will load resources from the
  local disk instead of over the network. To enable it, call ansible-cmdb with:

      ansible-cmdb -t html_fancy -p local_js=1 out > overview.html

  It can be easily extended by copying it and modifying the `cols` definition
  at the top.

* `txt_table`: A quick text table summary of the available hosts with some
  minimal information.

You can create your own template or extend an existing one by copying it and
refering to the full path to the template when using the `-t` option:

    $ ansible-cmdb -t /home/fboender/my_template out/ > my_template.html

### Fact caching

Ansible can cache facts from hosts when running playbooks. This is configured
like:

    [defaults]
    fact_caching=jsonfile
    fact_caching_connection = /path/to/facts/dir

You can use these cached facts as facts directories with ansible-cmdb by
specifying the `-f` (`--fact-cache`) option:

    $ ansible-cmdb -f /path/to/facts/dir > overview.html

Please note that the `--fact-cache` option will apply to *all* fact directories
you specify. This means you can't mix fact-cache fact directories and normal
`setup` fact directories. Also, if you wish to manually extend facts (see the
`Extending` chapter), you must ommit the `ansible_facts` key and put items in
the root of the JSON.

### Columns

Some templates, such as txt_table and html_fancy,  support columns. If a
template supports columns, you can use the `--columns` / `-c` command line
option to specify which columns to show. 

The `--columns` takes a comma-separated list of columns which should be shown.
The columns must be specified by their `id` field. For information on what `id`
fields are supported by a template, take a look in the template. Usually it's
the column title, but in lowercase and with spaces replaced by underscores.

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

### Extending

You can specify multiple directories that need to be scanned for output. This
lets you add more custom information to existing hosts or even completely new
hosts.

For example, if your normal ansible `setup` output contains:

    $ ls out/
    db1.dev.megacorp.com
    db2.dev.megacorp.com
    test.megacorp.com
    
    $ cat out/test.megacorp.com
    {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": [
                "158.12.198.104"
            ], 
    --snip--

You can create an additional directory with custom information:

    $ mkdir out_cust
    $ cat out_cust/test.megacorp.com
    {
        "software": [
            "Apache2",
            "MySQL5.5"
        ]
    }

Specify both directories when generating the output:

    ./ansible-cmdb out/ out_cust/ > overview.html

Your custom variables will be put in the root of the host information
dictionary:

    "test.megacorp.com": {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": ["185.21.189.140"],
        },
        "changed": false,
        "groups": ["cust.flusso"],
        "software": [
            "Apache2",
            "MySQL5.5"
        ],
        "name": "ad6.flusso.nl"
    }

If you're using the `--fact-cache` option, you must ommit the `ansible_facts`
key and put items in the root of the JSON. This also means that you can only
extend native ansible facts and not information read from the `hosts` file by
ansible-cmdb.


Infrequently Asked Questions
----------------------------

### Solaris machines have no disk information

Ansible currently does not include disk size information for Solaris hosts. As
such, we can't include it in the output of Ansible-cmdb. See issue #24 for more
information.

### Python packaging / Pypi?

Python has some of the most horrendous packaging infrastructure I've ever
encountered in 25 years of programming. As such, anything related to Python
packaging will not be supported.

Development
-----------

### Running from the git repo

If you want to run ansible-cmdb directly from the Git repo:

    $ cd ansible-cmdb
    $ export PYTHONPATH="$(readlink -f lib)"
    $ src/ansible-cmdb

### Inner workings

Here's a quick introducton on how ansible-cmdb works internally.

1. The main section in `ansible-cmdb` reads the commandline params and
   instantiates an `Ansible` object.
1. The `Ansible` object first reads in all the facts by calling
   `Ansible.parse_fact_dir()` for each argument. This includes the user-extended
   facts.
1. If hosts file(s) should be parsed (`-i` option), ansible calls
   `Ansible.parse_hosts_inventory()`. This first reads in all found hosts files
   into one big string, and then it parses it. For this it uses the
   `AnsibleHostParser` class.
1. The `AnsibleHostParser` class first parses the inventory and then creates a
   dictionary with all known ansible node names (hosts) as the keys, but with
   empty values. It then goes through the 'children', 'vars' and normal
   sections from the inventory and applies the found information to the hosts
   dictionary.
1. When `AnsibleHostParser` is done, the `Ansible` class takes all the parsed
   hosts information and updates its own version of the hosts dictionary.
1. Finally, the output is generated by the main section.

Updating a host in the `Ansible` object is done using the `Ansible.update_host`
method. This method does a deep-update of a dictionary. This lets ansible-cmdb
overlay information from the facts dir, extended / manual facts and hosts 
inventory files.

### Make targets

For building, `make` is used. Here are some useful targets:

* `make test`: build some tests.
* `make release`: build a release.
* `make clean`: remove build and other artifacts.

### Build packages and source-ball

To build Debian, RedHat and source-packages for ansible-cmdb you'll need a
Debian based operating system and you'll have to install the following
dependencies:

- git
- make
- python-markdown
- zip
- fakeroot
- alien

You can then build the packages with

    make release REL_VERSION=$VERSION

where `$VERSION` is a (arbitrary) version number.

In order to build releases, your repository will have to be completely clean:
everything must be commited and there must be no untracked files. If you want
to build a test release, you can temporary stash your untracked changes:

    git stash -u

### Contributions

If you wish to contribute code, please consider the following:

* Any form of Python packaging will NOT be supoprted. Merge requests involving
  python packages will not be considered. See issue #23.
* Thank you for even considering contributing. I'm quite newby-friendly, so
  don't hesitate to ask any help! 
* Code should be reasonably PEP8-like. I'm not too strict on this.
* One logical change per merge request.
* By putting in a merge request or putting code in comments, you autoamtically
  grant me permission to include this code in ansible-cmdb under the license
  (MIT) that ansible-cmdb uses.
* Please don't be disappointed or angry if your contributions end up unused.
  It's not that they aren't appreciated, but I can be somewhat strict when it
  comes to code quality, feature-creep, etc.

When in doubt, just open a pull-request and post a comment on what you're
unclear of, and we'll figure it out.
