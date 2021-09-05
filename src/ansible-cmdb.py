#!/usr/bin/env python

# ansible_cmd
#
# Generate host overview (configuration management database) from ansible fact
# gathering output.
#
# Usage:
#
#   $ ansible -m setup --tree out all
#   $ ansible-cmdb out > cmdb.html
#

import optparse
import sys
import os
import logging
import ast
from mako import exceptions
import ansiblecmdb
import ansiblecmdb.util as util
import ansiblecmdb.render as render


# Verify Python version
if sys.version_info < (2, 7):
    sys.stderr.write(
        "Ansible-cmdb requires Python v2.7+. You are running {}. Support for "
        "Python v2.6 supported ended October 2013. You should upgrade to a "
        "newer version.\n".format(sys.version))
    sys.exit(1)


def get_logger():
    """
    Instantiate a logger.
    """
    root = logging.getLogger()
    root.setLevel(logging.WARNING)
    ch = logging.StreamHandler(sys.stderr)
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(message)s')
    ch.setFormatter(formatter)
    root.addHandler(ch)
    return root


def get_data_dir():
    """
    Find out our installation prefix and data directory. These can be in
    different places depending on how ansible-cmdb was installed.
    """
    data_dir_paths = [
        os.path.join(os.path.dirname(ansiblecmdb.__file__), 'data'),
        os.path.join(os.path.dirname(sys.argv[0]), '..', 'lib', 'ansiblecmdb', 'data'),
        '/usr/local/lib/ansiblecmdb/data',
        '/usr/lib/ansiblecmdb/data',
    ]

    data_dir = util.find_path(data_dir_paths, 'tpl/html_fancy.tpl')
    if not data_dir:
        sys.stdout.write("Couldn't find the data dir for the templates. I tried: {0}\n".format(", ".join(data_dir_paths)))
        sys.exit(1)

    return data_dir


def get_hosts_files(option):
    """
    Find out the location of the `hosts` file. This looks in multiple places
    such as the `-i` option, current dir and ansible configuration files. The
    first match is returned as a list.
    """
    if option is not None:
        return option.split(',')

    # Use hosts file from the current dir if it exists
    if os.path.isfile('hosts'):
        return ['hosts']

    # Perhaps it's configured in a configuration file. Try to find a
    # configuration file and see if it contains a `hostsfile` entry.
    config_locations = [
        '.',
        '/etc/ansible/'
    ]
    config_dir = util.find_path(config_locations, 'ansible.cfg')
    log.debug('config_dir = {0}'.format(config_dir))
    if config_dir:
        with open(os.path.join(config_dir, 'ansible.cfg'), 'r') as cf:
            for line in cf:
                if line.startswith('hostfile'):
                    return [line.split('=', 1)[1].strip()]


def get_cust_cols(path):
    """
    Load custom column definitions.
    """
    required_keys = ["title", "id", "sType", "visible"]

    with open(path, 'r') as f:
        try:
            cust_cols = ast.literal_eval(f.read())
        except Exception as err:
            sys.stderr.write("Invalid custom columns file: {}\n".format(path))
            sys.stderr.write("{}\n".format(err))
            sys.exit(1)

    # Validate
    for col in cust_cols:
        for required_key in required_keys:
            if required_key not in col:
                sys.stderr.write("Missing required key '{}' in custom "
                                 "column {}\n".format(required_key, col))
                sys.exit(1)
            if "jsonxs" not in col and "tpl" not in col:
                sys.stderr.write("You need to specify 'jsonxs' or 'tpl' "
                                 "for custom column {}\n".format(col))
                sys.exit(1)

    return cust_cols


def parse_user_params(user_params):
    """
    Parse the user params (-p/--params) and them as a dict.
    """
    if user_params:
        params = {}
        try:
            for param in options.params.split(','):
                param_key, param_value = param.split('=', 1)
                params[param_key] = param_value
        except ValueError as e:
            sys.stdout.write("Invalid params specified. Should be in format: <key=value>[,<key=value>..]\n")
            sys.exit(1)
        return params
    else:
        return {}


if __name__ == "__main__":
    log = get_logger()
    data_dir = get_data_dir()
    tpl_dir = os.path.join(data_dir, 'tpl')
    static_dir = os.path.join(data_dir, 'static')
    version = open(os.path.join(data_dir, 'VERSION')).read().strip()

    parser = optparse.OptionParser(version="%prog v{0}".format(version))
    parser.set_usage(os.path.basename(sys.argv[0]) + " [option] <dir> > output.html")
    parser.add_option("-t", "--template", dest="template", action="store", default='html_fancy', help="Template to use. Default is 'html_fancy'")
    parser.add_option("-i", "--inventory", dest="inventory", action="store", default=None, help="Inventory to read extra info from")
    parser.add_option("-f", "--fact-cache", dest="fact_cache", action="store_true", default=False, help="<dir> contains fact-cache files")
    parser.add_option("-p", "--params", dest="params", action="store", default=None, help="Params to send to template")
    parser.add_option("-d", "--debug", dest="debug", action="store_true", default=False, help="Show debug output")
    parser.add_option("-q", "--quiet", dest="quiet", action="store_true", default=False, help="Don't report warnings")
    parser.add_option("-c", "--columns", dest="columns", action="store", default=None, help="Show only given columns")
    parser.add_option("-C", "--cust-cols", dest="cust_cols", action="store", default=None, help="Path to a custom columns definition file")
    parser.add_option("-l", "--limit", dest="limit", action="store", default=None, help="Limit hosts to pattern")
    parser.add_option("--exclude-cols", dest="exclude_columns", action="store", default=None, help="Exclude cols from output")
    parser.add_option("--use-ansible-api", dest="use_ansible_api", action="store_true", default=False,
                      help="Use the Ansible python API to read the inventory files")

    (options, args) = parser.parse_args()

    if len(args) < 1:
        parser.print_usage()
        sys.stderr.write("The <dir> argument is mandatory\n")
        sys.exit(1)

    if options.quiet:
        log.setLevel(logging.ERROR)
    elif options.debug:
        log.setLevel(logging.DEBUG)

    hosts_files = get_hosts_files(options.inventory)

    cust_cols = []
    if options.cust_cols is not None:
        cust_cols = get_cust_cols(options.cust_cols)

    # Handle template params
    params = {
        'lib_dir': data_dir,  # Backwards compatibility for custom templates < ansible-cmdb v1.7
        'data_dir': data_dir,
        'version': version,
        'log': log,
        'columns': None,
        'exclude_columns': None,
        'cust_cols': cust_cols
    }
    params.update(parse_user_params(options.params))
    if options.columns is not None:
        params['columns'] = options.columns.split(',')
    if options.exclude_columns is not None:
        params['exclude_columns'] = options.exclude_columns.split(',')

    # Log some debug information
    log.debug('data_dir = {0}'.format(data_dir))
    log.debug('tpl_dir = {0}'.format(tpl_dir))
    log.debug('static_dir = {0}'.format(static_dir))
    log.debug('inventory files = {0}'.format(hosts_files))
    log.debug('template params = {0}'.format(params))

    if options.use_ansible_api:
        ansible = ansiblecmdb.AnsibleViaAPI(args, hosts_files, options.fact_cache,
                                            limit=options.limit, debug=options.debug)
    else:
        ansible = ansiblecmdb.Ansible(args, hosts_files, options.fact_cache,
                                      limit=options.limit, debug=options.debug)

    # Render a template with the gathered host info
    renderer = render.Render(options.template, ['.', tpl_dir])
    if renderer.tpl_file is None:
        sys.stderr.write("Template '{0}' not found at any of \n  {1}\n".format(options.template, "\n  ".join(renderer.tpl_possibilities)))
        sys.exit(1)

    # Make sure we always output in UTF-8, regardless of the user's locale /
    # terminal encoding. This is different in Python 2 and 3.
    try:
        output = renderer.render(ansible.get_hosts(), params)
        if output:
            if sys.version_info[0] == 3:
                sys.stdout.buffer.write(output.lstrip())
            else:
                sys.stdout.write(output.lstrip())
    except Exception as err:
        full_err = exceptions.text_error_template().render().replace("\n", "\n    ")
        debug_cmd = "{0} -d {1}".format(sys.argv[0], ' '.join(sys.argv[1:]))
        debug_txt = ("Whoops, it looks like something went wrong while rendering the template.\n\n"
                     "The reported error was: {0}: {1}\n\nThe full error was:{2}\n"
                     "The output is probably not correct.\n\n".format(err.__class__.__name__, err, full_err))
        if err.__class__.__name__ == "KeyError":
            debug_txt += "!!! This is probably a problem with missing information in your host facts\n\n"
        if not options.debug:
            debug_txt += ("You can re-run ansible-cmdb with the -d switch to turn on debugging\n"
                          "to get an insight in what might be going wrong:\n\n"
                          "  {0}\n\n".format(debug_cmd))
        debug_txt += \
"""\
You can report a bug on the issue tracker:

  https://github.com/fboender/ansible-cmdb/issues

Please include the debugging output (-d switch) in the report!

If you can, also include the hosts file and the facts file for the last host
that rendered properly ('Rendering host...' in the output. If these files must
remain confidential, you can send them to ferry.boender@gmail.com instead.
"""
        sys.stderr.write(debug_txt)
        sys.exit(1)
