## Requirements

Ansible-cmdb requires **Python v2.7+ / 3.0+**.

In theory, it should work on any system that can run Python, including BSD,
Linux, Windows, Solaris and MacOS. In practice, ansible-cmdb is developed on
Ubuntu 16.04 and tested on the latest stable versions of Debian, Ubuntu and
Centos.

## Installation


Ansible-cmdb can be installed using `pip`, the [Python package
manager](https://pypi.org/project/pip/). There are also stand-alone packages
for various Linux distributions. Alternatively, you can use brew or plain old
`make install`.

### Through Pip

For **installation via Pip**:

Install `pip` [for your distribution](https://packaging.python.org/install_requirements_linux/)
if you don't have it yet.

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

Support for all other package managers (RPM, etc) has been dropped. Please use
the `pip` method instead, or install from tar.gz.

### For other systems

For **MacOS X** systems:

    brew install ansible-cmdb

For **Other** systems:

    tar -vxzf ansible-cmdb*.tar.gz
    cd ansible-cmdb*
    sudo make install

Installation from **Git** repository:

    git clone https://github.com/fboender/ansible-cmdb.git
    cd ansible-cmdb
	sudo bash -c ". build.sla && install"
