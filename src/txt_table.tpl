<%
import sys

col_space = 2

cols = [
  {"title": "Name", "field": lambda h: h['name']},
  {"title": "OS", "field": lambda h: h['ansible_facts']['ansible_distribution'] + ' ' + h['ansible_facts']['ansible_distribution_version']},
  {"title": "IP", "field": lambda h: host['ansible_facts']['ansible_default_ipv4']['address']},
  {"title": "Arch", "field": lambda h: host['ansible_facts']['ansible_architecture'] + '/' + host['ansible_facts']['ansible_userspace_architecture']},
  {"title": "Mem", "field": lambda h: '%0.0fg' % (host['ansible_facts']['ansible_memtotal_mb'] / 1000.0)},
  {"title": "CPUs", "field": lambda h: str(host['ansible_facts']['ansible_processor_count'])},
  {"title": "Virt", "field": lambda h: host['ansible_facts']['ansible_virtualization_type'] + '/' + host['ansible_facts']['ansible_virtualization_role']},
  {"title": "Disk avail", "field": lambda h: ', '.join([str(i['size_available']/1048576000) + 'g' for i in host['ansible_facts']['ansible_mounts'] if i['size_available']/1048576000 > 1])},
]

# Find longest value in a column
col_longest = {}
for hostname, host in hosts.items():
	for col in cols:
		field_value = col['field'](host)
		if len(field_value) > col_longest.get(col['title'], 0):
			col_longest[col['title']] = len(field_value)

# Print out headers
for col in cols:
	sys.stdout.write(col['title'].ljust(col_longest[col['title']] + col_space))
sys.stdout.write('\n')
for col in cols:
	sys.stdout.write('-' * col_longest[col['title']] + (' ' * col_space))
sys.stdout.write('\n')

# Print out columns
for hostname, host in hosts.items():
	for col in cols:
		sys.stdout.write(col['field'](host).ljust(col_longest[col['title']]) + (' ' * col_space))
	sys.stdout.write('\n')
%>
