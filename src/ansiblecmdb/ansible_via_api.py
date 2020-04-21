from ansible.parsing.dataloader import DataLoader
from ansible.inventory.manager import InventoryManager
from ansible.vars.manager import VariableManager

from ansiblecmdb import Ansible


class AnsibleViaAPI(Ansible):
    """
    Gather Ansible host information using the Ansible Python API.

    `fact_dirs` is a list of paths to directories containing facts
    gathered by Ansible's 'setup' module.

    `inventory_paths` is a list with files or directories containing the
    inventory.
    """
    def load_inventories(self):
        """Load host inventories using the Ansible Python API."""
        loader = DataLoader()
        inventory = InventoryManager(loader=loader, sources=self.inventory_paths)
        variable_manager = VariableManager(loader=loader, inventory=inventory)

        # some Ansible variables we don't need.
        ignore = ['ansible_playbook_python',
                  'groups',
                  'inventory_dir',
                  'inventory_file',
                  'omit',
                  'playbook_dir']

        # Handle limits here because Ansible understands more complex
        # limit syntax than ansible-cmdb (e.g. globbing matches []?*
        # and :& and matches).  Remove any extra hosts that were
        # loaded by facts.  We could optimize a bit by arranging to
        # load facts after inventory and skipping loading any facts
        # files for hosts not included in limited hosts, but for now
        # we do the simplest thing that can work.
        if self.limit:
            inventory.subset(self.limit)
            limited_hosts = inventory.get_hosts()
            for h in self.hosts.keys():
                if h not in limited_hosts:
                    del self.hosts[h]

        for host in inventory.get_hosts():
            vars = variable_manager.get_vars(host=host)
            for key in ignore:
                vars.pop(key, None)

            hostname = vars['inventory_hostname']
            groupnames = vars.pop('group_names', [])
            merge_host_key_val(self.hosts, hostname, 'name', hostname)
            merge_host_key_val(self.hosts, hostname, 'groups', set(groupnames))
            merge_host_key_val(self.hosts, hostname, 'hostvars', vars)

    def get_hosts(self):
        """
        Return a dict of parsed hosts info, with the limit applied if required.
        """
        # We override this method since we already applied the limit
        # when we loaded the inventory.
        return self.hosts


def merge_host_key_val(hosts_dict, hostname, key, val):
    """
    Update hosts_dict[`hostname`][`key`] with `val`, taking into
    account all the possibilities of missing keys and merging
    `val` into an existing list, set or dictionary target value.
    When merging into a dict target value any matching keys will
    be overwritten by the new value.  Merging into a list or set
    target value does not remove existing entries but instead adds
    the new values to the collection.  If the target value is
    is not a dict or collection it will be overwritten.

    This will be called with key in ['hostvars', 'groups', 'name'],
    although the implementation would work with any hashable key.
    """
    if hostname not in hosts_dict:
        hosts_dict[hostname] = {
            'name': hostname,
            'hostvars': {},
            'groups': set()
        }

    hostdata = hosts_dict[hostname]
    if key not in hostdata:
        hostdata[key] = val
        return

    # We handle the list case because the analogous util.deepupdate
    # does.  It might be needed in deepupdate for facts, but the
    # host inventory that we build is all dicts and sets.
    target = hostdata[key]
    if hasattr(target, 'update'):
        target.update(val)   # merge into target dict
    elif hasattr(target, 'union'):
        target.union(val)    # union into target set
    elif hasattr(target, 'extend'):
        target.extend(val)   # extend target list
    else:
        hostdata[key] = val  # overwrite non-mergeable target value
