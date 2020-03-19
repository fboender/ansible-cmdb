import os
import tempfile
import shutil
import logging
import base64
import codecs
import pickle
import ansiblecmdb.util as util

class AnsibleHosts(object):
    """
    Container class to store and retrieve ansible hosts as objects.
    Implements dictionary functionality by overriding its default methods
    Serves as a replacement for single dictionary of hosts and their attributes
    so that hosts data is linerly fetched from disk rather than keeping the whole
    dictionary in memory. Enables processing of 10K+ hosts inventories.
    """
    def __init__(self):
        self.log = logging.getLogger(__name__)
        # set include/exclude limit
        self.limit = None
        # create temporary file
        self._tmp_dir = tempfile.mkdtemp()
        self.log.debug("Created temporary directory {0}".format(self._tmp_dir))

    def __del__(self):
        # delete temporary directory
        self.log.debug("Removing temporary directory {0}".format(self._tmp_dir))
        shutil.rmtree(self._tmp_dir)

    def __getitem__(self, key):
        """
        Enable dictionary-style access to the items, ex. hosts['example.com']
        """
        filename = os.path.join(self._tmp_dir, self._hostname2filename(key))
        if os.path.isfile(filename):
            host_data = self._load_data_from_file(filename)
            if self._host_matches_limits(host_data):
                return host_data
            else:
                raise KeyError('{0} host does not match limits.'.format(key))
        else:
            raise KeyError('{0} does not exist.'.format(key))
        
    def get(self, key, default={}):
        """
        Get single host data as a dictionary using hostname
        """
        filename = os.path.join(self._tmp_dir, self._hostname2filename(key))
        if os.path.isfile(filename):
            host_data = self._load_data_from_file(filename)
            if self._host_matches_limits(host_data):
                return host_data
        return default

    def __contains__(self, key):
        """
        Enable dictionary-style check for key existence, ex. 'example.com' in hosts
        """
        filename = os.path.join(self._tmp_dir, self._hostname2filename(key))
        return os.path.isfile(filename)

    def __setitem__(self, key, value):
        """
        Enable dictionary-style value update, ex. hosts['example.com'] = newValue
        """
        self.update_host(key, value)
    
    def __iter__(self):
        """
        Make the object iterable
        """
        return iter(self.items())
        
    def __len__(self):
        """
        Implement len method for the dictionary object
        """
        i = 0
        for name in os.listdir(self._tmp_dir):
            if os.path.isfile(os.path.join(self._tmp_dir, name)):
                i += 1
        return i

    def update(self, other=None, **kwargs):
        """
        Override default dictionary update method
        """
        if other is not None:
            if isinstance(other, dict):
                for k, v in other.items():
                    self._set_host_data(k, v)
            else:
                for k, v in other:
                    self._set_host_data(k, v)
                    
        for k, v in kwargs.items():
            self._set_host_data(k, v)

    def update_host(self, hostname, key_values, overwrite=True):
        """
        Update a hosts information. This is called by various collectors such
        as the ansible setup module output and the hosts parser to add
        informatio to a host. It does some deep inspection to make sure nested
        information can be updated.
        """
        
        default_empty_host_data = {
            'name': hostname,
            'hostvars': {},
        }
        
        host_data = self.get(hostname, default_empty_host_data)
        util.deepupdate(host_data, key_values, overwrite=overwrite)
        
        self._set_host_data(hostname, host_data)
        
    def items(self):
        """
        Walk through the temporary directory and yield hosts data one by one
        """
        for name in os.listdir(self._tmp_dir):
            filename = os.path.join(self._tmp_dir, name)
            if os.path.isfile(filename):
                host_data = self._load_data_from_file(filename)
                if self._host_matches_limits(host_data):
                    hostname = host_data['name']
                    yield(hostname, host_data)

    def _hostname2filename(self, hostname):
        """
        Create host storage file from its hostname but convert to base64 to
        filter non ascii characters
        """
        filename = base64.urlsafe_b64encode(hostname.encode('utf-8')).decode()
        return filename

    def _parse_limit(self, limit):
        """
        Parse a host / group limit in the form of a string (e.g.
        'all:!cust.acme') into a dict of things to be included and things to be
        excluded.
        """
        
        limit_parsed = {
            'include': [],
            'exclude': []
        }
        
        elems = limit.split(":")
        for elem in elems:
            if elem.startswith('!'):
                limit_parsed['exclude'].append(elem[1:])
            else:
                limit_parsed['include'].append(elem)
                
        self.log.debug("Hosts limits applied: {0}".format(limit_parsed))
        return limit_parsed

    def _host_matches_limits(self, host):
        """
        Test if the host satisfies given include/exclude limits
        """

        # return true if limit is not set
        if self.limit is None:
            return True

        # add hostname and host groups to a single names list
        names = []
        if 'groups' in host:
            names = host['groups']
        names.append(host['name'])

        # return false if hostname or group is in exclude list
        for exclude in self.limit['exclude']:
            if exclude in names:
                return False

        # return true of include list is empty
        if not self.limit['include']:
            return True

        # return true if hostname or group matches include list
        for include in self.limit['include']:
            if include in names:
                return True

        # return false if include limit not matched
        return False

    def setLimit(self, limit):
        """
        Set include/exclude limit to filter the hosts returned from get(), items(), etc.
        """
        if limit is None:
            return
        self.limit = self._parse_limit(limit)
        
    def hosts_all(self):
        """
        Return a list of all hostnames.
        """
        for hostname, hostinfo in self.items():
            yield hostname
            
    def hosts_in_group(self, groupname):
        """
        Return a list of hostnames that are in a group.
        """
        if groupname == 'all':
            for hostname, hostinfo in self.items():
                yield hostname
        else:
            for hostname, hostinfo in self.items():
                if 'groups' in hostinfo:
                    if groupname in hostinfo['groups']:
                        yield hostname

    def _set_host_data(self, hostname, host_data):
        """
        Check if host data matched the limit and save it to file
        """
        if self._host_matches_limits(host_data):
            filename = os.path.join(self._tmp_dir, self._hostname2filename(hostname))
            self._save_data_to_file(host_data, filename)

    def _save_data_to_file(self, data, filename):
        """
        Write host data to file
        """
        with codecs.open(filename, 'wb') as handle:
            self.log.debug("Writing host data to file: {0}".format(filename))
            pickle.dump(data, handle)
            
    def _load_data_from_file(self, filename):
        """
        Load host data from file
        """
        self.log.debug("Reading host data from file {0}".format(filename))
        with codecs.open(filename, 'rb') as handle:
            return pickle.load(handle)
