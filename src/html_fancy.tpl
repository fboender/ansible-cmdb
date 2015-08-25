<%
##
## Column definitions
##
import datetime
cols = [
  {"title": "Name", "func": col_name, "visible": True},
  {"title": "DTAP", "func": col_dtap, "visible": True},
  {"title": "Groups", "func": col_groups, "visible": False},
  {"title": "FQDN", "func": col_fqdn, "visible": True},
  {"title": "OS", "func": col_os, "visible": True},
  {"title": "Main IP", "func": col_main_ip, "visible": True},
  {"title": "All IPv4", "func": col_all_ip, "visible": False},
  {"title": "Arch", "func": col_arch, "visible": False},
  {"title": "Mem", "func": col_mem, "visible": True},
  {"title": "CPUs", "func": col_cpus, "visible": False},
  {"title": "Virt", "func": col_virt, "visible": False},
  {"title": "Disk usage", "func": col_disk_usage, "visible": False},
  {"title": "Comment", "func": col_comment, "visible": True},
  {"title": "Ext ID", "func": col_ext_id, "visible": True},
]
%>
##
## Column functions
##
<%def name="col_name(host)">
  <a href="#${host["name"]}">${host["name"]}</a>
</%def>
<%def name="col_dtap(host)">
  ${host['hostvars'].get('dtap', '')}
</%def>
<%def name="col_groups(host)">
  ${'<br>'.join(host.get('groups', ''))}
</%def>
<%def name="col_fqdn(host)">
  ${host['ansible_facts'].get('ansible_fqdn', '')}
</%def>
<%def name="col_os(host)">
  ${host['ansible_facts'].get('ansible_distribution', '')} ${host['ansible_facts'].get('ansible_distribution_version', '')}
</%def>
<%def name="col_arch(host)">
  ${host['ansible_facts'].get('ansible_architecture', '')} / ${host['ansible_facts'].get('ansible_userspace_architecture', '')}
</%def>
<%def name="col_mem(host)">
  ${'%0.1fg' % ((int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1000.0))}
</%def>
<%def name="col_cpus(host)">
  ${host['ansible_facts'].get('ansible_processor_count', 0)}
</%def>
<%def name="col_main_ip(host)">
  ${host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')}
</%def>
<%def name="col_all_ip(host)">
  ${'<br>'.join(host['ansible_facts'].get('ansible_all_ipv4_addresses', []))}
</%def>
<%def name="col_virt(host)">
  ${host['ansible_facts'].get('ansible_virtualization_type', '')} / ${host['ansible_facts'].get('ansible_virtualization_role', '')}
</%def>
<%def name="col_disk_usage(host)">
  % for i in host['ansible_facts'].get('ansible_mounts', []):
    % if 'size_total' in i:  # Solaris hosts have no size_total
      % if i['size_total'] > 1:
        <div class="bar">
          <span class="prog_bar_full" style="width:100px">
            <span class="prog_bar_used" style="width:${float((i["size_total"] - i["size_available"])) / i["size_total"] * 100}px"></span>
          </span> ${i['mount']} <span id="disk_usage_detail">(${round((i['size_total'] - i['size_available']) / 1048576000.0, 2)}g / ${round(i['size_total'] / 1048576000.0, 2)}g)</span>
        </div>
      % endif
    % else:
      n/a
      <%
      break  # Don't list any more disks since no 'size_total' is available.
      %>
    % endif
  % endfor
</%def>
<%def name="col_comment(host)">
  ${host['hostvars'].get('comment', '')}
</%def>
<%def name="col_ext_id(host)">
  ${host['hostvars'].get('ext_id', '')}
</%def>
##
## Helper functions for dumping python datastructures
##
<%def name="r_list(l)">
  % for i in l:
    % if type(i) == list:
      ${r_list(i)}
    % elif type(i) == dict:
      ${r_dict(i)}
    % else:
      ${i}
    % endif
  % endfor
</%def>
<%def name="r_dict(d)">
  <table>
    % for k, v in d.items():
      <tr>
        <th>${k.replace('ansible_', '')}</th>
        <td>
        % if type(v) == list:
          ${r_list(v)}
        % elif type(v) == dict:
          ${r_dict(v)}
        % else:
          ${v}
        % endif
        </td>
      </tr>
    % endfor
  </table>
</%def>
<html>
<head>
  <title>Ansible overview</title>
  <style type="text/css">
    body { font-family: sans-serif; }
    h1,h3 { color: #005AC9; }
    h2 { color: #000000; }
    th { text-align: left; vertical-align: top; color: #606060; }
    td { vertical-align: top; color: #707070; }
    .hide { display: none; }
    a { text-decoration: none; }
    a.col-visible { color: #000000; font-weight: bold; margin-right: 12px; }
    a.col-invisible { color: #909090; font-weight: normal; margin-right: 12px; }
    .prog_bar_full { float: left; display: block; height: 12px; border: 1px solid #000000; padding: 1px; margin-right: 4px; color: white; text-align: center; }
    .prog_bar_used { display: block; height: 12px; background-color: #8F4040; }
    .error { color: #FF0000; }
    td.error a { color: #FF0000; }
    #generated { font-size: x-small; }
    #disk_usage_detail { font-size: small; }
  </style>
  <!-- DataTables assets -->
  % if local_js is UNDEFINED:
    <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.5/css/jquery.dataTables.css">
    <script type="text/javascript" charset="utf8" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.5/js/jquery.dataTables.js"></script>
  % else:
    <link rel="stylesheet" type="text/css" href="file://${lib_dir}/static/js/jquery.dataTables.css">
    <script type="text/javascript" charset="utf8" src="file://${lib_dir}/static/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" charset="utf8" src="file://${lib_dir}/static/js/jquery.dataTables.js"></script>
  % endif
  
</head>
<body>
<h1>Host Overview</h1>
<p id="generated">Generated: ${datetime.datetime.now().strftime('%c')}</p>
<div id="columns">
Display columns:
% for col in cols:
  <%
    visible = "visible"
    if col['visible'] is False:
      visible = "invisible"
  %>
  <a href="" class="col-toggle col-${visible}" data-column="${loop.index}">${col['title']}</a>
% endfor
</div>

<table id="host_overview" class="demo display dataTable compact">
<thead>
  <tr>
    % for col in cols:
      <th>${col['title']}</th>
    % endfor
  </tr>
</thead>
<tbody>
  % for hostname, host in hosts.items():
    <tr>
      % if 'ansible_facts' not in host:
        <td class="error">${col_name(host)}</td>
        % for cnt in range(len(cols) - 1):
            <td>&nbsp;</td>
        % endfor
      % else:
        % for col in cols:
          <td>${col["func"](host)}</td>
        % endfor
      % endif
    </tr>
% endfor
</tbody>
</table>

<h1>Hosts</h1>
% for hostname, host in hosts.items():
  % if 'ansible_facts' not in host:
    <a name="${host['name']}"><h2 id="${host['name']}">${host['name']}</h2></a>
    <p>No host information collected</p>
    % if 'msg' in host:
      <p class="error">${host['msg']}</p>
    % endif
  % else:
    <a name="${host['name']}"><h2 id="${host['name']}">${host['name']}</h2></a>
    <h3>General</h3>
    <table>
      <tr><th>Node name</th><td>${host['ansible_facts'].get('ansible_nodename', '')}</td></tr>
      <tr><th>Form factor</th><td>${host['ansible_facts'].get('ansible_form_factor', '')}</td></tr>
      <tr><th>Virtualisation role</th><td>${host['ansible_facts'].get('ansible_virtualization_role', '')}</td></tr>
      <tr><th>Virtualisation type</th><td>${host['ansible_facts'].get('ansible_virtualization_type', '')}</td></tr>
    </table>

    <h3>Custom variables</h3>
    <table>
        % for var_name, var_value in host['hostvars'].items():
          <tr><th>${var_name}</th><td>${var_value}</td></tr>
        % endfor
    </table>

    <h3>Hardware</h3>
    <table>
      <tr><th>Vendor</th><td>${host['ansible_facts'].get('ansible_system_vendor', '')}</td></tr>
      <tr><th>Product name</th><td>${host['ansible_facts'].get('ansible_product_name', '')}</td></tr>
      <tr><th>Product serial</th><td>${host['ansible_facts'].get('ansible_product_serial', '')}</td></tr>
      <tr><th>Architecture</th><td>${host['ansible_facts'].get('ansible_architecture', '')}</td></tr>
      <tr><th>Machine</th><td>${host['ansible_facts'].get('ansible_machine', '')}</td></tr>
      <tr><th>Processor count</th><td>${host['ansible_facts'].get('ansible_processor_count', '')}</td></tr>
      <tr><th>Processor cores</th><td>${host['ansible_facts'].get('ansible_processor_cores', '')}</td></tr>
      <tr><th>Processor threads per core</th><td>${host['ansible_facts'].get('ansible_processor_threads_per_core', '')}</td></tr>
      <tr><th>Processor virtual CPUs</th><td>${host['ansible_facts'].get('ansible_processor_vcpus', '')}</td></tr>
      <tr><th>Mem total mb</th><td>${host['ansible_facts'].get('ansible_memtotal_mb', '')}</td></tr>
      <tr><th>Mem free mb</th><td>${host['ansible_facts'].get('ansible_memfree_mb', '')}</td></tr>
      <tr><th>Swap total mb</th><td>${host['ansible_facts'].get('ansible_swaptotal_mb', '')}</td></tr>
      <tr><th>Swap free mb</th><td>${host['ansible_facts'].get('ansible_swapfree_mb', '')}</td></tr>
    </table>

    <h3>Operating System</h3>
    <table>
      <tr><th>System</th><td>${host['ansible_facts'].get('ansible_system', '')}</td></tr>
      <tr><th>OS Family</th><td>${host['ansible_facts'].get('ansible_os_family', '')}</td></tr>
      <tr><th>Distribution</th><td>${host['ansible_facts'].get('ansible_distribution', '')}</td></tr>
      <tr><th>Distribution version</th><td>${host['ansible_facts'].get('ansible_distribution_version', '')}</td></tr>
      <tr><th>Distribution release</th><td>${host['ansible_facts'].get('ansible_distribution_release', '')}</td></tr>
      <tr><th>Kernel</th><td>${host['ansible_facts'].get('ansible_kernel', '')}</td></tr>
      <tr><th>Userspace bits</th><td>${host['ansible_facts'].get('ansible_userspace_bits', '')}</td></tr>
      <tr><th>Userspace_architecture</th><td>${host['ansible_facts'].get('ansible_userspace_architecture', '')}</td></tr>
      <tr><th>Date time</th><td>${host['ansible_facts'].get('ansible_date_time', {}).get('iso8601', '')}</td></tr>
      <tr><th>Locale / Encoding</th><td>${host['ansible_facts'].get('ansible_env', {}).get('LC_ALL', 'Unknown')}</td></tr>
      <tr><th>SELinux?</th><td>${host['ansible_facts'].get('ansible_selinux', '')}</td></tr>
      <tr><th>Package manager</th><td>${host['ansible_facts'].get('ansible_pkg_mgr', '')}</td></tr>
    </table>

    <h3>Network</h3>
    <table>
      <tr><th>Hostname</th><td>${host['ansible_facts'].get('ansible_hostname', '')}</td></tr>
      <tr><th>Domain</th><td>${host['ansible_facts'].get('ansible_domain', '')}</td></tr>
      <tr><th>FQDN</th><td>${host['ansible_facts'].get('ansible_fqdn', '')}</td></tr>
      <tr><th>All IPv4</th><td>${'<br>'.join(host['ansible_facts'].get('ansible_all_ipv4_addresses', []))}</td></tr>
      <tr>
        <th>Interfaces</th>
        <td>
          <table>
              % for iface in host['ansible_facts'].get('ansible_interfaces', []):
                <tr>
                  <th>${iface}</th>
                  <td>
                    % try:
                      ${r_dict(host['ansible_facts']['ansible_%s' % (iface)])}
                    % except KeyError:
                      No information available
                    % endtry
                  </td>
                </tr>
              % endfor
          </table>
        </td>
      </tr>
    </table>

    <h3>Storage</h3>
    <table>
      <tr>
        <th>Devices</th>
        <td>
          ${r_dict(host['ansible_facts'].get('ansible_devices', {}))}
        </td>
      </tr>
      <tr>
        <th>Mounts</th>
        <td>
          ${r_list(host['ansible_facts'].get('ansible_mounts', []))}
        </td>
      </tr>
    </table>
  % endif
% endfor

<script>
$(document).ready( function () {
  var table = $('#host_overview').DataTable({
    paging: false,
    columnDefs: [
      % for col in cols:
        { "targets": [${loop.index}], "visible": ${str(col['visible']).lower()} },
      % endfor
    ]
  });

  $('a.col-toggle').on('click', function(e) {
    e.preventDefault();
    var column = table.column( $(this).attr('data-column') );
    column.visible( ! column.visible() );
    var newClass = ['col-invisible','col-visible'][Number(column.visible())];
    console.log(e.target.className = 'col-toggle ' + newClass);
  });
} );
</script>

</body>
</html>
