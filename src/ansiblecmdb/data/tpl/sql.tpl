<%
from jsonxs import jsonxs
%>
<%def name="col_fqdn(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_fqdn', default='')
%></%def>
<%def name="col_main_ip(host)"><%
  default_ipv4 = ''
  if jsonxs(host, 'ansible_facts.ansible_os_family', default='') == 'Windows':
    ipv4_addresses = [ip for ip in jsonxs(host, 'ansible_facts.ansible_ip_addresses', default=[]) if ':' not in ip]
    if ipv4_addresses:
      default_ipv4 = ipv4_addresses[0]
  else:
    default_ipv4 = jsonxs(host, 'ansible_facts.ansible_default_ipv4.address', default='')
  
  return default_ipv4.strip()
%></%def>
<%def name="col_os_name(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_distribution', default='')
%></%def>
<%def name="col_os_version(host)"><%
  if jsonxs(host, 'ansible_facts.ansible_distribution', default='') in ["OpenBSD"]:
    return jsonxs(host, 'ansible_facts.ansible_distribution_release', default='')
  else:
    return jsonxs(host, 'ansible_facts.ansible_distribution_version', default='')
  endif
%></%def>
<%def name="col_system(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_system', default='')
%></%def>
<%def name="col_kernel(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_kernel', default='')
%></%def>
<%def name="col_arch_hardware(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_architecture', default='')
%></%def>
<%def name="col_arch_userspace(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_userspace_architecture', default='')
%></%def>
<%def name="col_virt_type(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_virtualization_type', default='?')
%></%def>
<%def name="col_virt_role(host)"><%
  return jsonxs(host, 'ansible_facts.ansible_virtualization_role', default='?')
%></%def>
<%def name="col_cpu_type(host)"><%
  cpu_type = jsonxs(host, 'ansible_facts.ansible_processor', default=0)
  if isinstance(cpu_type, list) and len(cpu_type) > 0:
    return cpu_type[-1]
  else:
    return ''
%></%def>
<%def name="col_vcpus(host)"><%
  if jsonxs(host, 'ansible_facts.ansible_distribution', default='') in ["OpenBSD"]:
    return jsonxs(host, 'ansible_facts.ansible_processor_count', default=0)
  else:
    return jsonxs(host, 'ansible_facts.ansible_processor_vcpus', default=jsonxs(host, 'ansible_facts.ansible_processor_cores', default=0))
  endif
%></%def>
<%def name="col_ram(host)"><%
  return '%0.1f' % ((int(jsonxs(host, 'ansible_facts.ansible_memtotal_mb', default=0)) / 1024.0))
%></%def>
<%def name="col_disk_total(host)"><%
  for i in jsonxs(host, 'ansible_facts.ansible_mounts', default=[]):
    if i["mount"] == '/':
      return round(i.get('size_total', 0) / 1073741824.0, 1)
    endif
  endfor
  return 0
%></%def>
<%def name="col_disk_free(host)"><%
  for i in jsonxs(host, 'ansible_facts.ansible_mounts', default=[]):
    if i["mount"] == '/':
      try:
        return round(i["size_available"] / 1073741824.0, 1)
      except:
        return 0
      endtry
    endif
  endfor
  return 0
%></%def>
DROP TABLE IF EXISTS hosts;
CREATE TABLE hosts (
    name VARCHAR(255),
    fqdn VARCHAR(255),
    main_ip VARCHAR(15),
    os_name VARCHAR(80),
    os_version VARCHAR(40),
    system VARCHAR(40),
    kernel VARCHAR(40),
    arch_hardware VARCHAR(12),
    arch_userspace VARCHAR(12),
    virt_type VARCHAR(20),
    virt_role VARCHAR(20),
    cpu_type VARCHAR(60),
    vcpus INT,
    ram FLOAT,
    disk_total FLOAT,
    disk_free FLOAT
);

% for hostname, host in hosts.items():
    INSERT INTO hosts (
        name,
        fqdn,
        main_ip,
        os_name,
        os_version,
        system,
        kernel,
        arch_hardware,
        arch_userspace,
        virt_type,
        virt_role,
        cpu_type,
        vcpus,
        ram,
        disk_total,
        disk_free
    ) VALUES (
        "${jsonxs(host, 'name', default='Unknown')}",
        "${col_fqdn(host)}",
        "${col_main_ip(host)}",
        "${col_os_name(host)}",
        "${col_os_version(host)}",
        "${col_system(host)}",
        "${col_kernel(host)}",
        "${col_arch_hardware(host)}",
        "${col_arch_userspace(host)}",
        "${col_virt_type(host)}",
        "${col_virt_role(host)}",
        "${col_cpu_type(host)}",
        ${col_vcpus(host)},
        ${col_ram(host)},
        ${col_disk_total(host)},
        ${col_disk_free(host)}
    );
%endfor
