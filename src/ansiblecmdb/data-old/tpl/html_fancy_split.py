#!/usr/bin/env python

import sys
import os
import codecs
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
    out_file = os.path.join('cmdb', 'index.html')
    output = template.render(hosts=hosts, **vars).lstrip().decode('utf8')
    with codecs.open(out_file, 'w', encoding='utf8') as f:
        f.write(output)

    # Render host details
    template = lookup.get_template('html_fancy_split_detail.tpl')
    for hostname, host in hosts.items():
        out_file = os.path.join('cmdb', u'{0}.html'.format(hostname))
        output = template.render(host=host, **vars).lstrip().decode('utf8')
        with codecs.open(out_file, 'w', encoding='utf8') as f:
            f.write(output)
