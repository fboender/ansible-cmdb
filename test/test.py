import sys
import unittest
import imp
import os

sys.path.insert(0, os.path.realpath('../lib'))
sys.path.insert(0, os.path.realpath('../src'))
import ansiblecmdb


class ExtendTestCase(unittest.TestCase):
    """
    Test the extending of facts.
    """
    def testExtendOverrideParams(self):
        """
        Test that we can override a native fact
        """
        fact_dirs = ['f_extend/out_setup', 'f_extend/extend']
        ansible = ansiblecmdb.Ansible(fact_dirs)
        env_editor = ansible.hosts['debian.dev.local']['ansible_facts']['ansible_env']['EDITOR']
        self.assertEqual(env_editor, 'nano')

    def testExtendAddParams(self):
        """
        Test that we can add new facts
        """
        fact_dirs = ['f_extend/out_setup', 'f_extend/extend']
        ansible = ansiblecmdb.Ansible(fact_dirs)
        software = ansible.hosts['debian.dev.local']['software']
        self.assertIn('Apache2', software)


class HostParseTestCase(unittest.TestCase):
    """
    Test specifics of the hosts inventory parser
    """
    def testChildGroupHosts(self):
        """
        Test that children groups contain all hosts they should.
        """
        fact_dirs = ['f_hostparse/out']
        inventories = ['f_hostparse/hosts']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        groups = ansible.hosts['db.dev.local']['groups']
        self.assertIn('db', groups)
        self.assertIn('dev', groups)
        self.assertIn('dev_local', groups)

    def testChildGroupVars(self):
        """
        Test that all vars applied against a child group are set on the hosts.
        """
        fact_dirs = ['f_hostparse/out']
        inventories = ['f_hostparse/hosts']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        host_vars = ansible.hosts['db.dev.local']['hostvars']
        self.assertEqual(host_vars['function'], 'db')
        self.assertEqual(host_vars['dtap'], 'dev')

    def testExpandHostDef(self):
        """
        Verify that host ranges are properly expanded. E.g. db[01-03].local ->
        db01.local, db02.local, db03.local.
        """
        fact_dirs = ['f_hostparse/out']
        inventories = ['f_hostparse/hosts']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        self.assertIn('web02.dev.local', ansible.hosts)
        self.assertIn('fe03.dev02.local', ansible.hosts)


class InventoryTestCase(unittest.TestCase):
    def testHostsDir(self):
        """
        Verify that we can specify a directory as the hosts inventory file and
        that all files are parsed.
        """
        fact_dirs = ['f_inventory/out']
        inventories = ['f_inventory/hostsdir']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        host_vars = ansible.hosts['db.dev.local']['hostvars']
        groups = ansible.hosts['db.dev.local']['groups']
        self.assertEqual(host_vars['function'], 'db')
        self.assertIn('db', groups)

    def testDynInv(self):
        """
        Verify that we can specify a path to a dynamic inventory as the
        inventory file, and it will be executed, it's output parsed and added
        as available hosts.
        """
        fact_dirs = ['f_inventory/out'] # Reuse f_hostparse
        inventories = ['f_inventory/dyninv.py']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        self.assertIn('host5.example.com', ansible.hosts)
        host_vars = ansible.hosts['host5.example.com']['hostvars']
        groups = ansible.hosts['host5.example.com']['groups']
        self.assertEqual(host_vars['b'], False)
        self.assertIn("atlanta", groups)

    def testMixedDir(self):
        """
        Verify that a mixed dir of hosts files and dynamic inventory scripts is
        parsed correctly.
        """
        fact_dirs = ['f_inventory/out']
        inventories = ['f_inventory/mixeddir']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories)
        # results from dynamic inventory
        self.assertIn("host4.example.com", ansible.hosts)
        self.assertIn("moocow.example.com", ansible.hosts)
        # results from normal hosts file.
        self.assertIn("web03.dev.local", ansible.hosts)
        # INI file ignored.
        self.assertNotIn("ini_setting", ansible.hosts)


class FactCacheTestCase(unittest.TestCase):
    """
    Test that we properly read fact-cached output dirs.
    """
    def testFactCache(self):
        fact_dirs = ['f_factcache/out']
        inventories = ['f_factcache/hosts']
        ansible = ansiblecmdb.Ansible(fact_dirs, inventories, fact_cache=True)
        host_vars = ansible.hosts['debian.dev.local']['hostvars']
        groups = ansible.hosts['debian.dev.local']['groups']
        ansible_facts = ansible.hosts['debian.dev.local']['ansible_facts']
        self.assertIn('dev', groups)
        self.assertEqual(host_vars['dtap'], 'dev')
        self.assertIn('ansible_env', ansible_facts)


if __name__ == '__main__':
    unittest.main(exit=True)

    try:
        os.unlink('../src/ansible-cmdbc') # FIXME: Where is this coming from? Our weird import I assume.
    except Exception:
        pass
