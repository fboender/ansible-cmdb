import sys
import os
import json
import stat
import subprocess
import codecs
import logging

import ansiblecmdb.util as util
import ansiblecmdb.parser as parser


class Ansible(object):
    """
    The Ansible class is responsible for gathering host information.
    """
    def __init__(self, fact_dirs, inventory_paths=None, fact_cache=False, debug=False):
        """
        `fact_dirs` is a list of paths to directories containing facts gathered
        by ansible's 'setup' module.

        `inventory_paths` is a list with files or directories containing the
        inventory. It will be scanned to extract groups, variables and
        additional facts. If entries point to a file, it's read as a
        hosts file. If it's a directory, it is scanned for hosts files and
        dynamic inventory scripts.
        """
        self.fact_dirs = fact_dirs
        if inventory_paths is None:
            self.inventory_paths = []
        else:
            self.inventory_paths = inventory_paths
        self.fact_cache = fact_cache  # fact dirs are fact-caches
        self.debug = debug
        self.hosts = {}
        self.log = logging.getLogger()

        # Process facts gathered by Ansible's setup module of fact caching.
        for fact_dir in self.fact_dirs:
            self._parse_fact_dir(fact_dir, self.fact_cache)

        # Scan the inventory for known hosts.
        for inventory_path in self.inventory_paths:
            self._handle_inventory(inventory_path)

    def _handle_inventory(self, inventory_path):
        """
        Scan inventory. As Ansible is a big mess without any kind of
        preconceived notion of design, there are several (and I use that word
        lightly) different ways inventory_path can be handled:

          - a non-executable file: handled as a Ansible 'hosts' file.
          - an executable file: handled as a dynamic inventory file.
          - a directory: scanned for Ansible 'hosts' and dynamic inventory
            files.
        """
        if os.path.isfile(inventory_path) and \
           util.is_executable(inventory_path):
            # It's a file and it's executable. Handle as dynamic inventory script
            self._parse_dyn_inventory(inventory_path)
        elif os.path.isfile(inventory_path):
            # Static inventory hosts file
            self._parse_hosts_inventory(inventory_path)
        elif os.path.isdir(inventory_path):
            # Scan directory
            for fname in os.listdir(inventory_path):
                # Skip files that end with certain extensions or characters
                if any(fname.endswith(ext) for ext in ["~", ".orig", ".bak", ".ini", ".cfg", ".retry", ".pyc", ".pyo"]):
                    continue

                self._handle_inventory(os.path.join(inventory_path, fname))
        else:
            raise IOError("Invalid inventory file / dir: '{0}'".format(inventory_path))
        self._parse_hostvar_dir(inventory_path)

    def _parse_hosts_inventory(self, inventory_path):
        """
        Read all the available hosts inventory information into one big list
        and parse it.
        """
        hosts_contents = []
        if os.path.isdir(inventory_path):
            for fname in os.listdir(inventory_path):
                path = os.path.join(inventory_path, fname)
                if os.path.isdir(path):
                    continue
                with codecs.open(path, 'r', encoding='utf8') as f:
                    hosts_contents += f.readlines()
        else:
            with codecs.open(inventory_path, 'r', encoding='utf8') as f:
                hosts_contents = f.readlines()

        # Parse inventory and apply it to the hosts
        hosts_parser = parser.HostsParser(hosts_contents)
        for hostname, key_values in hosts_parser.hosts.items():
            self.update_host(hostname, key_values)

    def _parse_hostvar_dir(self, inventory_path):
        """
        Parse host_vars dir, if it exists. This requires the yaml module, which
        is imported on-demand, since it's not a default module.
        """
        self.log.debug("Parsing host vars (dir): {0}".format(inventory_path))
        path = os.path.join(os.path.dirname(inventory_path), 'host_vars')
        if not os.path.exists(path):
            return

        try:
            import yaml
        except ImportError:
            import yaml3 as yaml

        flist = []
        for (dirpath, dirnames, filenames) in os.walk(path):
            flist.extend(filenames)
            break

        for fname in flist:
            f_path = os.path.join(path, fname)

            # Check for ansible-vault files, because they're valid yaml for
            # some reason... (psst, the reason is that yaml sucks)
            first_line = open(f_path, 'r').readline()
            if first_line.startswith('$ANSIBLE_VAULT'):
                sys.stderr.write("Skipping encrypted vault file {0}\n".format(f_path))
                continue

            try:
                f = codecs.open(f_path, 'r', encoding='utf8')
                invars = yaml.safe_load(f)
                f.close()
                self.update_host(fname, {'hostvars': invars})
            except Exception as err:
                sys.stderr.write("Yaml couldn't load '{0}'. Skipping\n".format(f_path))

    def _parse_fact_dir(self, fact_dir, fact_cache=False):
        """
        Walk through a directory of JSON files and extract information from
        them. This is used for both the Ansible fact gathering (setup module)
        output and custom variables.
        """
        self.log.debug("Parsing fact dir: {0}".format(fact_dir))
        if not os.path.isdir(fact_dir):
            raise IOError("Not a directory: '{0}'".format(fact_dir))

        flist = []
        for (dirpath, dirnames, filenames) in os.walk(fact_dir):
            flist.extend(filenames)
            break

        for fname in flist:
            if fname.startswith('.'):
                continue
            self.log.debug("Reading host facts from {0}".format(os.path.join(fact_dir, fname)))
            hostname = fname

            fd = codecs.open(os.path.join(fact_dir, fname), 'r', encoding='utf8')
            s = fd.readlines()
            fd.close()
            try:
                x = json.loads(''.join(s))
                # for compatibility with fact_caching=jsonfile
                # which omits the "ansible_facts" parent key added by the setup module
                if fact_cache:
                    x = json.loads('{ "ansible_facts": ' + ''.join(s) + ' }')
                self.update_host(hostname, x)
                self.update_host(hostname, {'name': hostname})
            except ValueError as e:
                # Ignore non-JSON files (and bonus errors)
                sys.stderr.write("Error parsing: %s: %s\n" % (fname, e))

    def _parse_dyn_inventory(self, script):
        """
        Execute a dynamic inventory script and parse the results.
        """
        self.log.debug("Reading dynamic inventory {0}".format(script))
        try:
            proc = subprocess.Popen([script, '--list'],
                                    stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE,
                                    close_fds=True)
            stdout, stderr = proc.communicate(input)
            if proc.returncode != 0:
                sys.stderr.write("Dynamic inventory script '{0}' returned "
                                 "exitcode {1}\n".format(script,
                                                        proc.returncode))
                for line in stderr:
                    sys.stderr.write(line)

            dyninv_parser = parser.DynInvParser(stdout.decode('utf8'))
            for hostname, key_values in dyninv_parser.hosts.items():
                self.update_host(hostname, key_values)
        except OSError as err:
            sys.stderr.write("Exception while executing dynamic inventory script '{0}':\n\n".format(script))
            sys.stderr.write(str(err) + '\n')

    def update_host(self, hostname, key_values):
        """
        Update a hosts information. This is called by various collectors such
        as the ansible setup module output and the hosts parser to add
        informatio to a host. It does some deep inspection to make sure nested
        information can be updated.
        """
        host_info = self.hosts.get(hostname, {'name': hostname, 'hostvars': {}})
        util.deepupdate(host_info, key_values)
        self.hosts[hostname] = host_info
