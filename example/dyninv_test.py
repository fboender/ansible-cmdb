#!/usr/bin/python

import json

inventory = {
  "dyninv_group_dev" : {
    "hosts" : [ "debian.dev.local" ]
  },
  "dyninv_group_test" : {
    "hosts" : [ "facter.test.local", "custfact.test.local" ],
    "vars" : {
      "net_config" : {
        "eth0" : {
          "bootproto" : "dhcp",
          "onboot" : "yes",
          "nozeroconf" : "yes",
          "persistent_dhclient" : "yes",
          "nm_controlled" : "no"
        }
      }
    }
  }
}

print json.dumps(inventory, indent=2)
