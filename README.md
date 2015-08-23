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

    $ ansible-cmdb -i ./hosts out/ > cmdb.html

The ''html_fancy'' template uses four extra fields:

- `groups`: A list of Ansible groups the host belongs too
- `dtap`: Whether a host is a development, test, acceptance or production system.
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

Your custom variables will be put in the root of the host information dictionary:

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
