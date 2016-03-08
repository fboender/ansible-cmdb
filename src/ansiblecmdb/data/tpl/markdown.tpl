<%def name="col_main_ip(host)"><%
    default_ipv4 = ''
    if host['ansible_facts'].get('ansible_os_family', '') == 'Windows':
      ipv4_addresses = [ip for ip in host['ansible_facts'].get('ansible_ip_addresses', []) if ':' not in ip]
      if ipv4_addresses:
        default_ipv4 = ipv4_addresses[0]
    else:
      default_ipv4 = host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')
    return default_ipv4
%></%def>\
<%def name="col_os(host)"><%
    if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
      return host['ansible_facts'].get('ansible_distribution', '') + " " + host['ansible_facts'].get('ansible_distribution_release', '')
    else:
      return host['ansible_facts'].get('ansible_distribution', '') + " " +  host['ansible_facts'].get('ansible_distribution_version', '')
    endif
%></%def>\
<%def name="col_arch(host)"><%
    return host['ansible_facts'].get('ansible_architecture', '') + " / " + host['ansible_facts'].get('ansible_userspace_architecture', '')
%></%def>\
<%def name="col_virt(host)"><%
    return host['ansible_facts'].get('ansible_virtualization_type', '?') + " / " + host['ansible_facts'].get('ansible_virtualization_role', '?')
%></%def>\
<%def name="col_cpu_type(host)"><%
    cpu_type = host['ansible_facts'].get('ansible_processor', 0)
    if isinstance(cpu_type, list):
      return cpu_type[-1]
    endif
%></%def>\
<%def name="col_vcpus(host)"><%
   return host['ansible_facts'].get('ansible_processor_vcpus', host['ansible_facts'].get('ansible_processor_cores', 0))
%></%def>\
<%def name="col_ram(host)"><%
    return '%0.0f' % ((int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1024.0))
%></%def>\
<%def name="col_disk(host)"><%
  return ', '.join(['{0:0.1f}g'.format(i['size_available']/1048576000) for i in host['ansible_facts'].get('ansible_mounts', []) if 'size_available' in i and i['size_available'] > 1])
%></%def>\
# Host overview

% for hostname, host in sorted(hosts.items()):
* <a href="#${hostname}">${hostname}</a>
% endfor

# Host details

% for hostname, host in sorted(hosts.items()):
${"##"} <a name="${hostname}"></a> ${hostname}

${"###"} General

* **Name**: ${host['name']}
* **Hostname**: ${hostname}
* **FQDN**: ${host['ansible_facts'].get('ansible_fqdn', '')}
* **Main IP**: ${col_main_ip(host)}
* **Operating System**: ${col_os(host)}

${"###"} Groups

% for group in sorted(host.get('groups', '')):
* ${group}
% endfor

${"###"} Custom variables
% for var_name, var_value in host['hostvars'].items():
* **${var_name}**: ${var_value}
% endfor

${"###"} Hardware

* **Architecture**: ${col_arch(host)}
* **Virtualization**: ${col_virt(host)}
* **CPU type**: ${col_cpu_type(host)}
* **VCPUs**: ${col_vcpus(host)}
* **Memory**: ${col_ram(host)} Gb
* **Disk**: ${col_disk(host)}
% endfor
