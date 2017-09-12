<%
import sys
import logging

log = logging.getLogger(__name__)

col_space = 2

cols = [
  {"title": "Name",       "id": "name",       "visible": True, "field": lambda h: h.get('name', '')},
  {"title": "OS",         "id": "os",         "visible": True, "field": lambda h: h['ansible_facts'].get('ansible_distribution', '') + ' ' + h['ansible_facts'].get('ansible_distribution_version', '')},
  {"title": "IP",         "id": "ip",         "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')},
  {"title": "Mac",        "id": "mac",        "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_default_ipv4', {}).get('macaddress', '')},
  {"title": "Arch",       "id": "arch",       "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_architecture', 'Unk') + '/' + host['ansible_facts'].get('ansible_userspace_architecture', 'Unk')},
  {"title": "Mem",        "id": "mem",        "visible": True, "field": lambda h: '%0.0fg' % (int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1000.0)},
  {"title": "MemFree",    "id": "memfree",    "visible": True, "field": lambda h: '%0.0fg' % (int(host['ansible_facts'].get('ansible_memfree_mb', 0)) / 1000.0)},
  {"title": "MemUsed",    "id": "memused",    "visible": True, "field": lambda h: '%0.0fg' % (int(host['ansible_facts'].get('ansible_memory_mb', {}).get('real', {}).get('used',0)) / 1000.0)},
  {"title": "CPUs",       "id": "cpus",       "visible": True, "field": lambda h: str(host['ansible_facts'].get('ansible_processor_count', 0))},
  {"title": "Virt",       "id": "virt",       "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_virtualization_type', 'Unk') + '/' + host['ansible_facts'].get('ansible_virtualization_role', 'Unk')},
  {"title": "Disk avail", "id": "disk_avail", "visible": True, "field": lambda h: ', '.join(['{0:0.1f}g'.format(i['size_available']/1048576000) for i in host['ansible_facts'].get('ansible_mounts', []) if 'size_available' in i and i['size_available'] > 1])},
]

# Enable columns specified with '--columns'
if columns is not None:
  for col in cols:
    if col["id"] in columns:
      col["visible"] = True
    else:
      col["visible"] = False

def get_cols():
    return [col for col in cols if col['visible'] is True]

# Find longest value in a column
col_longest = {}

# Init col width to titles' len
for col in get_cols():
  col_longest[col['title']] = len(col['title'])

for hostname, host in hosts.items():
  for col in get_cols():
    try:
      field_value = col['field'](host)
      if len(field_value) > col_longest.get(col['title'], 0):
        col_longest[col['title']] = len(field_value)
    except KeyError:
      pass

# Print out headers
for col in get_cols():
  sys.stdout.write(col['title'].ljust(col_longest[col['title']] + col_space))
sys.stdout.write('\n')

for col in get_cols():
  sys.stdout.write(u'-' * col_longest[col['title']] + (u' ' * col_space))
sys.stdout.write('\n')

# Print out columns
for hostname, host in hosts.items():
  if 'ansible_facts' not in host:
    log.warning(u'{0}: No info collected.'.format(hostname))
  else:
    for col in get_cols():
      sys.stdout.write(col['field'](host).ljust(col_longest[col['title']]) + (' ' * col_space))
  sys.stdout.write('\n')
%>
