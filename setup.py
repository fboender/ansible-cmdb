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
    return open('src/ansiblecmdb/data/VERSION', 'r').read().strip()

def get_data_files(path, strip='', prefix=''):
    data_files = []
    for dirpath, dirnames, filenames in os.walk(path):
        files = [os.path.join(dirpath, filename) for filename in filenames]
        data_files.append( (prefix + dirpath[len(strip):], files) )
    return data_files


if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    print('You should also add a git tag for this version:')
    print(' git tag {0}'.format(get_version()))
    print(' git push --tags')
    sys.exit()


setup(
    name='ansible-cmdb',
    version=get_version(),
    license='MIT',
    description='Generate host overview from ansible fact gathering output',
    long_description=get_long_description(),
    url='https://github.com/fboender/ansible-cmdb',

    author='Ferry Boender',
    author_email='ferry.boender@electricmonk.nl',

    package_dir={'': 'src'},
    packages=find_packages('src'),
    include_package_data=True,
    data_files=get_data_files('src/ansiblecmdb/data',
                              strip='src',
                              prefix='lib/'),
    zip_safe=False,
    install_requires=[
        'mako>=1.0',
        'pyyaml>=1.0',
        'ushlex>=0.99',
        'jsonxs>=0.3',
    ],
    scripts=[
        'src/ansible-cmdb',
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
        'Programming Language :: Python :: 3',
        'Topic :: System :: Installation/Setup',
        'Topic :: System :: Systems Administration',
        'Topic :: Utilities',
    ],
)
