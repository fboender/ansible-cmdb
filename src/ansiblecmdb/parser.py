import sys
import re
import shlex
import json


class HostsParser(object):
    """
    Parse Ansible hosts inventory contents and generate a dictionary of hosts
    (self.hosts) with the information. Each host will have all the groups that
    it belongs to (including parent groups) and all the variables defined for
    it (including variables from parent groups and 'vars' groups).
    """
    def __init__(self, hosts_contents):
        self.hosts_contents = hosts_contents
        self.hosts = {}

        # Get a list of host, children and vars sections in the hosts file
        try:
            self.sections = self._parse_hosts_contents(hosts_contents)

            # Initialize each unique host found in the hosts file
            for hostname in self._get_distinct_hostnames():
                self.hosts[hostname] = {
                    'groups': set(),
                    'hostvars': {}
                }

            # Go through the different types of sections and apply each section to
            # the hosts it covers. 'Applying a section' means adding the group name
            # and variables defined in the section to each host the section covers.
            for section in filter(lambda s: s['type'] == 'children', self.sections):
                self._apply_section(section, self.hosts)
            for section in filter(lambda s: s['type'] == 'vars', self.sections):
                self._apply_section(section, self.hosts)
            for section in filter(lambda s: s['type'] == 'hosts', self.sections):
                self._apply_section(section, self.hosts)
        except ValueError as e:
            sys.stderr.write("Error while parsing hosts contents: '{}'\n"
                             "Invalid hosts file?\n".format(str(e)))


    def _parse_hosts_contents(self, hosts_contents):
        """
        Parse the inventory contents. This returns a list of sections found in
        the inventory, which can then be used to figure out which hosts belong
        to which groups and such. Each section has a name, a type ('hosts',
        'children', 'vars') and a list of entries for that section. Entries
        consist of a hostname and the variables. For 'vars' sections, the
        hostname is None.

        For example:
            [production:children]
            frontend  purpose="web"
            db        purpose="db"
        Returns:
            {
                'name': 'production',
                'type': 'children',
                'entries': [
                    {'name': 'frontend', 'hostvars': {'purpose': 'web'}},
                    {'name': 'db', 'hostvars': {'purpose': 'db'}},
                ]
            }
        """
        sections = []
        cur_section = {
            'type': 'hosts',
            'name': None,
            'entries': []
        }

        for line in hosts_contents:
            line = line.strip()
            if line.startswith('#') or not line:
                continue
            elif line.startswith('['):
                sections.append(cur_section)
                section_type, name = self._parse_line_section(line)
                cur_section = {
                    'type': section_type,
                    'name': name,
                    'entries': []
                }
            else:
                name, vars = self._parse_line_entry(line, cur_section['type'])
                entry = {
                    'name': name,
                    'hostvars': vars
                }
                cur_section['entries'].append(entry)
        sections.append(cur_section)
        return sections

    def _parse_line_section(self, line):
        """
        Parse a line containing a group definition. Returns a tuple:
        (group_type, group_name), where group_type is in the set ('hosts',
        'children', 'vars').

        For example:
            [prod]
        Returns:
            ('hosts', 'prod')

        For example:
            [prod:children]
        Returns:
            ('children', 'prod')
        """
        m = re.match("\[(.*)\]", line)
        group_def = m.groups()[0]
        if ':' in group_def:
            group_name, group_type = group_def.split(':')
        else:
            group_name = group_def
            group_type = 'hosts'

        return (group_type, group_name)

    def _parse_line_entry(self, line, type):
        """
        Parse a section entry line into its components. In case of a 'vars'
        section, the first field will be None.

        For example:
            [production:children]
            frontend  purpose="web"
        Returns:
            ('frontend', {'purpose': 'web'})
        """
        tokens = shlex.split(line.strip())
        name = None
        if type != 'vars':
            name = tokens.pop(0)
        key_values = self._parse_vars(tokens)
        return (name, key_values)

    def _parse_vars(self, tokens):
        """
        Given an iterable of tokens, returns variables and their values as a
        dictionary.

        For example:
            ['dtap=prod', 'comment=some comment']
        Returns:
            {'dtap': 'prod', 'comment': 'some comment'}
        """
        key_values = {}
        for token in tokens:
            if token == '#':
                # End parsing if we encounter a comment, which lasts
                # until the end of the line.
                break
            else:
                k, v = token.split('=', 1)
                key = k.strip()
                key_values[key] = v.strip()
        return key_values

    def _get_distinct_hostnames(self):
        """
        Return a set of distinct hostnames found in the entire inventory.
        """
        hostnames = []
        for section in self.sections:
            hostnames.extend(self._group_get_hostnames(section['name']))
        return set(hostnames)

    def _apply_section(self, section, hosts):
        """
        Recursively find all the hosts that belong in or under a section and
        add the section's group name and variables to every host.
        """
        # Add the current group name to each host that this section covers.
        if section['name'] is not None:
            for hostname in self._group_get_hostnames(section['name']):
                hosts[hostname]['groups'].add(section['name'])

        # Apply variables
        func_map = {
            "hosts": self._apply_section_hosts,
            "children": self._apply_section_children,
            "vars": self._apply_section_vars,
        }
        func = func_map[section['type']]
        func(section, hosts)

    def _apply_section_hosts(self, section, hosts):
        """
        Add the variables for each entry in a 'hosts' section to the hosts
        belonging to that entry.
        """
        for entry in section['entries']:
            for hostname in self.expand_hostdef(entry['name']):
                host = hosts[hostname]
                for var_key, var_val in entry['hostvars'].items():
                    host['hostvars'][var_key] = var_val

    def _apply_section_children(self, section, hosts):
        """
        Add the variables for each entry in a 'children' section to the hosts
        belonging to that entry.
        """
        for entry in section['entries']:
            for hostname in self._group_get_hostnames(entry['name']):
                host = hosts[hostname]
                for var_key, var_val in entry['hostvars'].items():
                    host['hostvars'][var_key] = var_val

    def _apply_section_vars(self, section, hosts):
        """
        Apply the variables in a 'vars' section to each host belonging to the
        group the section refers to.
        """
        for hostname in self._group_get_hostnames(section['name']):
            host = hosts[hostname]
            for entry in section['entries']:
                for var_key, var_val in entry['hostvars'].items():
                    host['hostvars'][var_key] = var_val

    def _group_get_hostnames(self, group_name):
        """
        Recursively fetch a list of each unique hostname that belongs in or
        under the group. This includes hosts in children groups.
        """
        hostnames = []

        hosts_section = self._get_section(group_name, 'hosts')
        if hosts_section:
            for entry in hosts_section['entries']:
                hostnames.extend(self.expand_hostdef(entry['name']))

        children_section = self._get_section(group_name, 'children')
        if children_section:
            for entry in children_section['entries']:
                hostnames.extend(self._group_get_hostnames(entry['name']))

        return hostnames

    def _get_section(self, name, type):
        """
        Find and return a section with `name` and `type`
        """
        for section in self.sections:
            if section['name'] == name and section['type'] == type:
                return section
        return None

    def expand_hostdef(self, hostdef):
        """
        Expand a host definition (e.g. "foo[001:010].bar.com") into seperate
        hostnames. Supports zero-padding, numbered ranges and alphabetical
        ranges. Multiple patterns in a host defnition are also supported.
        Returns a list of the fully expanded hostnames. Ports are also removed
        from hostnames as a bonus (e.g. "foo.bar.com:8022" -> "foo.bar.com")
        """
        try:
            hosts_todo = [hostdef]
            hosts_done = []

            # Keep going through the todo list of hosts until they no longer have a
            # pattern in them. We only handle the first pattern found in the host for
            # each iteration of the while loop. If more patterns are present, the
            # partially expanded host(s) gets added back to the todo list.
            while hosts_todo:
                host = hosts_todo.pop(0)
                if not '[' in host:
                    hosts_done.append(host)
                    continue

                # Extract the head, first pattern and tail. E.g. foo[0:3].bar.com ->
                # head="foo", pattern="0:3", tail=".bar.com"
                head, rest = host.split('[', 1)
                pattern, tail = rest.split(']', 1)
                start, end = pattern.split(':')
                fill = False
                if start.startswith('0') and len(start) > 0:
                    fill = len(start)

                try:
                    for i in range(int(start), int(end) + 1):
                        if fill:
                            range_nr = str(i).zfill(fill)
                        else:
                            range_nr = i
                        new_host = '{0}{1}{2}'.format(head, range_nr, tail)
                        if '[' in new_host:
                            hosts_todo.append(new_host)
                        else:
                            hosts_done.append(new_host)
                except ValueError:
                    for i in range(ord(start), ord(end) + 1):
                        new_host = '{0}{1}{2}'.format(head, chr(i), tail)
                        if '[' in new_host:
                            hosts_todo.append(new_host)
                        else:
                            hosts_done.append(new_host)

            # Strip port numbers off and return
            return [host_name.split(':')[0] for host_name in hosts_done]
        except Exception as e:
            sys.stderr.write("Couldn't parse host definition '{}': {}\n".format(hostdef, e))
            return []


class DynInvParser(object):
    """
    Parse output of a dyanmic inventory script.
    """
    def __init__(self, dynvinv_contents):
        self.dynvinv_contents = dynvinv_contents
        self.hosts = {}
        self.dynvinv_json = json.loads(self.dynvinv_contents)

        for k, v in self.dynvinv_json.items():
            if k.startswith('_meta'):
                # Meta member contains hostvars
                self._parse_meta(v)
            elif k.startswith('_'):
                # Some unknown private member we don't support
                pass
            elif k == "all":
                # The 'all' group is not interesting for ansible-cmdb
                pass
            else:
                # Group definition
                self._parse_group(k, v)

    def _get_host(self, hostname):
        """
        Get an existing host or otherwise initialize a new empty one.
        """
        if not hostname in self.hosts:
            self.hosts[hostname] = {
                'groups': set(),
                'hostvars': {}
            }
        return self.hosts[hostname]

    def _parse_group(self, group_name, group):
        """
        Parse a group definition from a dynamic inventory. These are top-level
        elements which are not '_meta(data)'.
        """
        if type(group) == dict:
            # Group member with hosts and variable definitions.
            for hostname in group.get('hosts', []):
                self._get_host(hostname)['groups'].add(group_name)
            for var_key, var_val in group.get('vars', {}).items():
                self._get_host(hostname)['hostvars'][var_key] = var_val
        elif type(group) == list:
            # List of hostnames for this group
            for hostname in group:
                self._get_host(hostname)['groups'].add(group_name)
        else:
            sys.stderr.write("Invalid element found in dynamic "
                             "inventory output: {}".format(type(group)))

    def _parse_meta(self, meta):
        """
        Parse the _meta element from a dynamic host inventory output.
        """
        for hostname, hostvars in meta.get('hostvars', {}).items():
            for var_key, var_val in hostvars.items():
                self._get_host(hostname)['hostvars'][var_key] = var_val
