#!/usr/bin/env python
import os
import sys
from setuptools import setup, find_namespace_packages

def get_long_description():
    path = os.path.join(os.path.dirname(__file__), 'README.md')
    with open(path) as f:
        return f.read()

if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    print('You should also add a git tag for this version:')
    print(' git tag {0}'.format(get_version()))
    print(' git push --tags')
    sys.exit()

setup(
    name='ansible-cmdb',
    use_scm_version=True,
    setup_requires=['setuptools_scm'],
    license='GPLv3',
    description='Generate host overview from ansible fact gathering output',
    long_description=get_long_description(),
    url='https://github.com/fboender/ansible-cmdb',

    author='Ferry Boender',
    author_email='ferry.boender@electricmonk.nl',

    package_dir={'': 'src'},
    packages=find_namespace_packages('src'),
    package_data={
        'ansiblecmdb.data': ['*.*'],
        'ansiblecmdb.data.static.images': ['*.*'],
        'ansiblecmdb.data.static.js': ['*.*'],
        'ansiblecmdb.data.tpl': ['*.*']
    },
    include_package_data=True,
    zip_safe=False,
    install_requires=['mako', 'pyyaml', 'ushlex', 'jsonxs'],
    scripts=[
        'src/ansible-cmdb',
        'src/ansible-cmdb.py'
    ],

    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
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
