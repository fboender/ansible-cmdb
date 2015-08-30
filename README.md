Ansible Configuration Management Database
=========================================

About
-----

This script takes the output of Ansible's `setup` module and converts it into a
static HTML overview page containing system configuration information.

It supports multiple templates and extending information gathered by Ansible
with custom data.

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

The default template is `html_fancy`, which uses Jquery. By default it can
therefor not be opened in your browser using `file:///`, but must be served
over HTTP or HTTPS. If you wish to view it locally, you can instruct the
template to use local javascript resources. The *Templates* section has
information on how to do that.

### Full usage

    Usage: ../src/ansible-cmdb [option] <dir> > output.html
    
    Options:
      -h, --help            show this help message and exit
      -t TEMPLATE, --template=TEMPLATE
                            Template to use. Default is 'html_fancy'
      -i INVENTORY, --inventory=INVENTORY
                            Inventory hosts file to read extra info from
      -f, --fact-cache      <dir> contains fact-cache files
      -p PARAMS, --params=PARAMS
                            Params to send to template

### Inventory scanning

Ansible-cmdb can read your inventory file (`hosts`, by default) and extract
useful information from it such as:

- All the groups a host belongs to.
- Host variables. These are optional key/value pairs for each host which can be
  used in playbooks. They are scanned by ansible-cmdb and get added to a hosts
  discovered facts under the 'hostvars' section.


Reading the hosts inventory file is done using the `-i` switch to ansible-cmdb.
It takes a single parameter: your hosts file or directory containing your hosts
files. For example:

    $ ansible-cmdb -i ./hosts out/ > overview.html

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

### Templates

ansible-cmdb offers multiple templates. You can choose your template with the
`-t` or `--template` argument:

	ansible-cmdb -t tpl_custom out/ > overview.html

The 'html_fancy' template is the default. It can be easily extended by copying
it and modifying the `cols` definition at the top. It should be served over
HTTP, as it uses CDN Jquery libs (unless you specify the `local_js` parameter).

Ansible-cmdb currently provides the following templates out of the box:

* `html_fancy`: A fancy HTML page that used JQuery and DataTables to give you a
  searchable, sortable table overview of all hosts with detailed information
  just a click away.

  It takes a parameter `local_js` which, if set, will load resources from the
  local disk instead of over the network. To enable it, call ansible-cmdb with:

      ansible-cmdb -t html_fancy -p local_js=1 out > overview.html

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

### Extending

You can specify multiple directories that need to be scanned for output. This
lets you add more custom information by creating a directory that looks like
the output of Ansible's 'setup' module, but contains fake entries with your own
information.

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

