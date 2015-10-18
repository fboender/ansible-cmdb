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
    version='1.6',
    license='BSD',
    description='Generate host overview from ansible fact gathering output',
    long_description=get_long_description(),
    url='https://github.com/fboender/ansible-cmdb',

    author='Ferry Boender',
    author_email='ferry.boender@gmail.com',

    package_dir={'': 'src'},
    packages=find_packages('src'),
    include_package_data=True,
    data_files=get_data_files('src/ansiblecmdb/data',
                              strip='src/ansiblecmdb/',
                              prefix='ansiblecmdb/'),
    zip_safe=False,
    install_requires=[
        'mako>=1.0',
        'pyyaml>=1.0'
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
        'Topic :: System :: Installation/Setup',
        'Topic :: System :: Systems Administration',
        'Topic :: Utilities',
    ],
)
