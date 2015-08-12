<%
import sys

col_space = 2

cols = [
  {"title": "Name", "field": lambda h: h.get('name', '')},
  {"title": "OS", "field": lambda h: h['ansible_facts'].get('ansible_distribution', '') + ' ' + h['ansible_facts'].get('ansible_distribution_version', '')},
  {"title": "IP", "field": lambda h: host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')},
  {"title": "Arch", "field": lambda h: host['ansible_facts'].get('ansible_architecture', 'Unk') + '/' + host['ansible_facts'].get('ansible_userspace_architecture', 'Unk')},
  {"title": "Mem", "field": lambda h: '%0.0fg' % (host['ansible_facts'].get('ansible_memtotal_mb', 0) / 1000.0)},
  {"title": "CPUs", "field": lambda h: str(host['ansible_facts'].get('ansible_processor_count', 0))},
  {"title": "Virt", "field": lambda h: host['ansible_facts'].get('ansible_virtualization_type', 'Unk') + '/' + host['ansible_facts'].get('ansible_virtualization_role', 'Unk')},
  {"title": "Disk avail", "field": lambda h: ', '.join([str(i['size_available']/1048576000) + 'g' for i in host['ansible_facts'].get('ansible_mounts', []) if i['size_available']/1048576000 > 1])},
]

# Find longest value in a column
col_longest = {}
for hostname, host in hosts.items():
	for col in cols:
		try:
			field_value = col['field'](host)
			if len(field_value) > col_longest.get(col['title'], 0):
				col_longest[col['title']] = len(field_value)
		except KeyError:
			pass

# Print out headers
for col in cols:
	sys.stdout.write(col['title'].ljust(col_longest[col['title']] + col_space))
sys.stdout.write('\n')

for col in cols:
	sys.stdout.write('-' * col_longest[col['title']] + (' ' * col_space))
sys.stdout.write('\n')

# Print out columns
for hostname, host in hosts.items():
	if 'ansible_facts' not in host:
		sys.stdout.write('{}: No info collected'.format(hostname))
	else:
		for col in cols:
			sys.stdout.write(col['field'](host).ljust(col_longest[col['title']]) + (' ' * col_space))
	sys.stdout.write('\n')
%>
