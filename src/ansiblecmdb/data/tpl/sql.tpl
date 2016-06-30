<%def name="col_fqdn(host)"><%
  return host['ansible_facts'].get('ansible_fqdn', '')
%></%def>
<%def name="col_main_ip(host)"><%
  default_ipv4 = ''
  if host['ansible_facts'].get('ansible_os_family', '') == 'Windows':
    ipv4_addresses = [ip for ip in host['ansible_facts'].get('ansible_ip_addresses', []) if ':' not in ip]
    if ipv4_addresses:
      default_ipv4 = ipv4_addresses[0]
  else:
    default_ipv4 = host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')
  
  return default_ipv4.strip()
%></%def>
<%def name="col_os_name(host)"><%
  if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
    return host['ansible_facts'].get('ansible_distribution', '')
  else:
    return host['ansible_facts'].get('ansible_distribution', '')
  endif
%></%def>
<%def name="col_os_version(host)"><%
  if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
    return host['ansible_facts'].get('ansible_distribution_release', '')
  else:
    return host['ansible_facts'].get('ansible_distribution_version', '')
  endif
%></%def>
<%def name="col_system(host)"><%
  return host['ansible_facts'].get('ansible_system', '')
%></%def>
<%def name="col_kernel(host)"><%
  return host['ansible_facts'].get('ansible_kernel', '')
%></%def>
<%def name="col_arch_hardware(host)"><%
  return host['ansible_facts'].get('ansible_architecture', '')
%></%def>
<%def name="col_arch_userspace(host)"><%
  return host['ansible_facts'].get('ansible_userspace_architecture', '')
%></%def>
<%def name="col_virt_type(host)"><%
  return host['ansible_facts'].get('ansible_virtualization_type', '?')
%></%def>
<%def name="col_virt_role(host)"><%
  return host['ansible_facts'].get('ansible_virtualization_role', '?')
%></%def>
<%def name="col_cpu_type(host)"><%
  cpu_type = host['ansible_facts'].get('ansible_processor', 0)
  if isinstance(cpu_type, list) and len(cpu_type) > 0:
    return cpu_type[-1]
  else:
    return ''
%></%def>
<%def name="col_vcpus(host)"><%
  if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
    return 0
  else:
    return host['ansible_facts'].get('ansible_processor_vcpus', host['ansible_facts'].get('ansible_processor_cores', 0))
  endif
%></%def>
<%def name="col_ram(host)"><%
  return '%0.1f' % ((int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1024.0))
%></%def>
<%def name="col_disk_total(host)"><%
  for i in host['ansible_facts'].get('ansible_mounts', []):
    if i["mount"] == '/':
      return round(i.get('size_total', 0) / 1073741824.0, 1)
    endif
  endfor
  return 0
%></%def>
<%def name="col_disk_free(host)"><%
  for i in host['ansible_facts'].get('ansible_mounts', []):
    if i["mount"] == '/':
      try:
        disk_free = i["size_total"] - i["size_available"]
        return round(disk_free / 1073741824.0, 1)
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
        "${host['name']}",
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
