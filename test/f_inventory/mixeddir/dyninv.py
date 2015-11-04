#!/usr/bin/python

import sys

inv = """\
{
    "databases": {
        "hosts": ["host1.example.com", "host2.example.com"],
        "vars": {
            "a": true
        }
    },
    "webservers": [ "host2.example.com", "host3.example.com" ],
    "atlanta": {
        "hosts": [ "host1.example.com", "host4.example.com", "host5.example.com" ],
        "vars": {
            "b": false
        },
        "children": [ "marietta", "5points" ]
    },
    "marietta": [ "host6.example.com" ],
    "5points": [ "host7.example.com" ],
    "_meta" : {
        "hostvars": {
            "moocow.example.com": {
                "asdf" : 1234
            },
            "llama.example.com": {
                "asdf" : 5678
            }
        }
    }
}
"""

sys.stdout.write(inv)
