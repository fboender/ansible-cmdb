#!/usr/bin/env python

import sys
import os
from mako.template import Template
from mako.lookup import TemplateLookup

def render(hosts, vars={}, tpl_dirs=[]):
    if not os.path.isdir('out'):
        os.mkdir('out')

    print(vars)
    ### Set the link type for the host overview table's 'host' column (the link that
    ### takes you to the host details).
    ##link_type = "anchor"
    ##if host_details is False:
    ##  link_type = "none"
    lookup = TemplateLookup(directories=tpl_dirs,
                            default_filters=['decode.utf8'],
                            input_encoding='utf-8',
                            output_encoding='utf-8',
                            encoding_errors='replace')

    # Render host overview
    template = lookup.get_template('html_fancy_split_overview.tpl')
    with open('out/index.html', 'w') as f:
        f.write(template.render(hosts=hosts, **vars).lstrip())

    # Render host details
    template = lookup.get_template('html_fancy_split_detail.tpl')
    for hostname, host in hosts.items():
        out_file = os.path.join('out', '{0}.html'.format(hostname))
        with open(out_file, 'w') as f:
            f.write(template.render(host=host, **vars).lstrip())
