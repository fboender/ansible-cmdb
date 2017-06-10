#!/usr/bin/env python

import sys
import os
from mako.template import Template
from mako.lookup import TemplateLookup

def render(hosts, vars={}, tpl_dirs=[]):
    if not os.path.isdir('cmdb'):
        os.mkdir('cmdb')

    lookup = TemplateLookup(directories=tpl_dirs,
                            default_filters=['decode.utf8'],
                            input_encoding='utf-8',
                            output_encoding='utf-8',
                            encoding_errors='replace')

    # Render host overview
    template = lookup.get_template('html_fancy_split_overview.tpl')
    with open('cmdb/index.html', 'w') as f:
        f.write(template.render(hosts=hosts, **vars).lstrip())

    # Render host details
    template = lookup.get_template('html_fancy_split_detail.tpl')
    for hostname, host in hosts.items():
        out_file = os.path.join('cmdb', '{0}.html'.format(hostname))
        with open(out_file, 'w') as f:
            f.write(template.render(host=host, **vars).lstrip())
