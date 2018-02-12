<%
import datetime
%>\
<%def name="r_list(l, depth=0)"><%
  t = ""
  for v in l:
    if type(v) == list:
      t += r_list(v, depth+1)
    elif type(v) == dict:
      t += r_dict(v, depth+1)
    else:
      t += "* {}\n".format(v)
  return t
%></%def>\
<%def name="r_dict(d, depth=0)"><%
  t = ""
  for k, v in d.items():
    t += ("    " * depth) + "* **{0}**: ".format(k)
    if type(v) == list:
      t += "\n{0}".format(r_list(v, depth + 1))
    elif type(v) == dict:
      t += "\n{0}".format(r_dict(v, depth + 1))
    else:
      t += "{0}\n".format(v)
  return t
%></%def>\
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
%></%def>
${"#"} <a name="host_overview"></a> Host overview

% for hostname, host in sorted(hosts.items()):
* <a href="#${hostname}">${hostname}</a>
% endfor

# Host details

% for hostname, host in sorted(hosts.items()):
${"##"} <a name="${hostname}"></a> ${hostname}

% if 'ansible_facts' not in host:
No information collected
% else:
<a href="#host_overview">Back to top</a>

${"###"} General

* **Node name**: ${host['ansible_facts'].get('ansible_nodename', 'Unknown')}
* **Form factor**: ${host['ansible_facts'].get('ansible_form_factor', 'Unknown')}
* **Virtualization role**: ${host['ansible_facts'].get('ansible_virtualization_role', 'Unknown')}
* **Virtualization type**: ${host['ansible_facts'].get('ansible_virtualization_type', 'Unknown')}

${"###"} Groups

% for group in sorted(host.get('groups', '')):
* ${group}
% endfor

${"###"} Custom variables
% for var_name, var_value in host.get('hostvars', {}).items():
* **${var_name}**: ${var_value}
% endfor

${"###"} Host local facts
${r_dict(host['ansible_facts'].get('ansible_local', {}), 0)}

${"###"} Hardware

* **Vendor**: ${host['ansible_facts'].get('ansible_system_vendor', '')}
* **Product name**: ${host['ansible_facts'].get('ansible_product_name', '')}
* **Product serial**: ${host['ansible_facts'].get('ansible_product_serial', '')}
* **Architecture**: ${host['ansible_facts'].get('ansible_architecture', '')}
* **Form factor**: ${host['ansible_facts'].get('ansible_form_factor', '')}
* **Virtualization role**: ${host['ansible_facts'].get('ansible_virtualization_role', '')}
* **Virtualization type**: ${host['ansible_facts'].get('ansible_virtualization_type', '')}
* **Machine**: ${host['ansible_facts'].get('ansible_machine', '')}
* **Processor count**: ${host['ansible_facts'].get('ansible_processor_count', '')}
* **Processor cores**: ${host['ansible_facts'].get('ansible_processor_cores', '')}
* **Processor threads per core**: ${host['ansible_facts'].get('ansible_processor_threads_per_core', '')}
* **Processor virtual CPUs**: ${host['ansible_facts'].get('ansible_processor_vcpus', '')}
* **Mem total mb**: ${host['ansible_facts'].get('ansible_memtotal_mb', '')}
* **Mem free mb**: ${host['ansible_facts'].get('ansible_memfree_mb', '')}
* **Swap total mb**: ${host['ansible_facts'].get('ansible_swaptotal_mb', '')}
* **Swap free mb**: ${host['ansible_facts'].get('ansible_swapfree_mb', '')}

${"###"} Operating System

* **System**: <td>${host['ansible_facts'].get('ansible_system', '')}
* **OS Family**: <td>${host['ansible_facts'].get('ansible_os_family', '')}
* **Distribution**: <td>${host['ansible_facts'].get('ansible_distribution', '')}
* **Distribution version**: <td>${host['ansible_facts'].get('ansible_distribution_version', '')}
* **Distribution release**: <td>${host['ansible_facts'].get('ansible_distribution_release', '')}
* **Kernel**: <td>${host['ansible_facts'].get('ansible_kernel', '')}
* **Userspace bits**: <td>${host['ansible_facts'].get('ansible_userspace_bits', '')}
* **Userspace_architecture**: <td>${host['ansible_facts'].get('ansible_userspace_architecture', '')}
* **Date time**: <td>${host['ansible_facts'].get('ansible_date_time', {}).get('iso8601', '')}
* **Locale / Encoding**: <td>${host['ansible_facts'].get('ansible_env', {}).get('LC_ALL', 'Unknown')}
* **SELinux?**: <td>${host['ansible_facts'].get('ansible_selinux', '')}
* **Package manager**: <td>${host['ansible_facts'].get('ansible_pkg_mgr', '')}

${"###"} Network

* **Hostname**: ${host['ansible_facts'].get('ansible_hostname', '')}
* **Domain**: ${host['ansible_facts'].get('ansible_domain', '')}
* **FQDN**: ${host['ansible_facts'].get('ansible_fqdn', '')}
* **Main IP**: ${col_main_ip(host)}
* **All IPv4**:
% for ipv4 in host['ansible_facts'].get('ansible_all_ipv4_addresses', []):
    - ${ipv4}
% endfor

% for iface in sorted(host['ansible_facts'].get('ansible_interfaces', [])):
* **${iface}**:
${r_dict(host['ansible_facts'].get('ansible_%s' % (iface), {}), 1)}
% endfor

${"###"} Storage

% if type(host['ansible_facts'].get('ansible_devices', [])) == list:
${r_list(host['ansible_facts'].get('ansible_devices', []))}
% else:
${r_dict(host['ansible_facts'].get('ansible_devices', {}))}
% endif

% endif
% endfor

Generated by [ansible-cmdb](https://github.com/fboender/ansible-cmdb) v%%MASTER%% on ${datetime.datetime.now().strftime('%c')}. &copy; Ferry Boender
