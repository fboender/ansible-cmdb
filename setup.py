#!/usr/bin/env python
import os
import sys
import re
from distutils.core import setup
from setuptools import find_packages


def get_long_description():
    path = os.path.join(os.path.dirname(__file__), 'README.md')
    with open(path) as f:
        return f.read()


def get_version():
    setup_py = open('setup.py').read()
    return re.search('version=[\'"]([0-9]+\.[0-9]+(|\.[0-9]+))[\'"]', setup_py, re.MULTILINE).group(1)


if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    print('You should also add a git tag for this version:')
    print(' git tag {0}'.format(get_version()))
    print(' git push --tags')
    sys.exit()


setup(
    name='ansible-cmdb',
    version='1.6',
    license='BSD',
    description='Generate host overview from ansible fact gathering output',
    long_description=get_long_description(),
    url='https://github.com/fboender/ansible-cmdb',

    author='Ferry Boender',
    author_email='ferry.boender@gmail.com',

    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        'ansible>=1.0',
        'mako>=1.0'
    ],
    scripts=[
        'src/ansible-cmdb',
        # FIXME: The template files shouldn't be installed as scripts.
        # One solution is to create an ansible-cmdb python module with a thin command line wrapper. The templates can
        # then be installed along side the module.
        'src/html_fancy.tpl',
        'src/txt_table.tpl'
    ],

    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Operating System :: POSIX',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Topic :: System :: Installation/Setup',
        'Topic :: System :: Systems Administration',
        'Topic :: Utilities',
    ],
)
