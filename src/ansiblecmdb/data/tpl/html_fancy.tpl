<%
##
## Column definitions
##
import datetime
cols = [
  {"title": "Name",       "id": "name",       "func": col_name,       "sType": "string", "visible": True},
  {"title": "Groups",     "id": "groups",     "func": col_groups,     "sType": "string", "visible": False},
  {"title": "DTAP",       "id": "dtap",       "func": col_dtap,       "sType": "string", "visible": False},
  {"title": "Comment",    "id": "comment",    "func": col_comment,    "sType": "string", "visible": False},
  {"title": "Ext ID",     "id": "ext_id",     "func": col_ext_id,     "sType": "string", "visible": False},
  {"title": "FQDN",       "id": "fqdn",       "func": col_fqdn,       "sType": "string", "visible": True},
  {"title": "Main IP",    "id": "main_ip",    "func": col_main_ip,    "sType": "string", "visible": True},
  {"title": "All IPv4",   "id": "all_ipv4",   "func": col_all_ip,     "sType": "string", "visible": False},
  {"title": "OS",         "id": "os",         "func": col_os,         "sType": "string", "visible": True},
  {"title": "Kernel",     "id": "kernel",     "func": col_kernel,     "sType": "string", "visible": False},
  {"title": "Arch",       "id": "arch",       "func": col_arch,       "sType": "string", "visible": False},
  {"title": "Virt",       "id": "virt",       "func": col_virt,       "sType": "string", "visible": True},
  {"title": "CPU type",   "id": "cpu_type",   "func": col_cpu_type,   "sType": "string", "visible": False},
  {"title": "vCPUs",      "id": "vcpus",      "func": col_vcpus,      "sType": "num", "visible": True},
  {"title": "RAM [GiB]",  "id": "ram",        "func": col_ram,        "sType": "num", "visible": True},
  {"title": "Mem Usage",  "id": "mem_usage",  "func": col_mem_usage,  "sType": "string", "visible": False},
  {"title": "Swap Usage", "id": "swap_usage", "func": col_swap_usage, "sType": "string", "visible": False},
  {"title": "Disk usage", "id": "disk_usage", "func": col_disk_usage, "sType": "string", "visible": False},
  {"title": "Timestamp",  "id": "timestamp",  "func": col_gathered,   "sType": "string", "visible": False},
]

# Enable columns specified with '--columns'
if columns is not None:
  for col in cols:
    if col["id"] in columns:
      col["visible"] = True
    else:
      col["visible"] = False
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
<%def name="col_main_ip(host)">
  <%
    default_ipv4 = ''
    if host['ansible_facts'].get('ansible_os_family', '') == 'Windows':
      ipv4_addresses = [ip for ip in host['ansible_facts'].get('ansible_ip_addresses', []) if ':' not in ip]
      if ipv4_addresses:
        default_ipv4 = ipv4_addresses[0]
    else:
      default_ipv4 = host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')
  %>
  ${default_ipv4}
</%def>
<%def name="col_all_ip(host)">
  <%
    if host['ansible_facts'].get('ansible_os_family', '') == 'Windows':
      ipv4_addresses = [ip for ip in host['ansible_facts'].get('ansible_ip_addresses', []) if ':' not in ip]
    else:
      ipv4_addresses = host['ansible_facts'].get('ansible_all_ipv4_addresses', [])
  %>
  ${'<br>'.join(ipv4_addresses)}
</%def>
<%def name="col_os(host)">
  % if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
    ${host['ansible_facts'].get('ansible_distribution', '')} ${host['ansible_facts'].get('ansible_distribution_release', '')}
  % else:
    ${host['ansible_facts'].get('ansible_distribution', '')} ${host['ansible_facts'].get('ansible_distribution_version', '')}
  % endif
</%def>
<%def name="col_kernel(host)">
  ${host['ansible_facts'].get('ansible_kernel', '')}
</%def>
<%def name="col_arch(host)">
  ${host['ansible_facts'].get('ansible_architecture', '')} / ${host['ansible_facts'].get('ansible_userspace_architecture', '')}
</%def>
<%def name="col_virt(host)">
  ${host['ansible_facts'].get('ansible_virtualization_type', '?')} / ${host['ansible_facts'].get('ansible_virtualization_role', '?')}
</%def>
<%def name="col_cpu_type(host)">
  <% cpu_type = host['ansible_facts'].get('ansible_processor', 0)%>
  % if isinstance(cpu_type, list) and len(cpu_type) > 0:
    ${ cpu_type[-1] }
  % endif
</%def>
<%def name="col_vcpus(host)">
  % if host['ansible_facts'].get('ansible_distribution', '') in ["OpenBSD"]:
    0
  % else:
    ${host['ansible_facts'].get('ansible_processor_vcpus', host['ansible_facts'].get('ansible_processor_cores', 0))}
  % endif
</%def>
<%def name="col_ram(host)">
  ${'%0.1f' % ((int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1024.0))}
</%def>
<%def name="col_mem_usage(host)">
  % try:
    <%
    i = host['ansible_facts'].get('ansible_memory_mb') 
    sort_used = '%f' % (float(i["nocache"]["used"]) / i["real"]["total"])
    used = float(i["nocache"]["used"]) / i["real"]["total"] * 100
    detail_used = round((i["nocache"]["used"]) / 1024.0, 1)
    detail_total = round(i["real"]["total"] / 1024.0, 1)
    %>
    <div class="bar">
      ## hidden sort helper
      <span style="display:none">${sort_used}</span>
      <span class="prog_bar_full" style="width:100px">
        <span class="prog_bar_used" style="width:${used}px"></span>
      </span>
      <span class="usage_detail">(${detail_used} / ${detail_total} GiB)</span>
    </div>
  % except:
    n/a
  % endtry
</%def>
<%def name="col_swap_usage(host)">
  % try:
    <%
      i = host['ansible_facts'].get('ansible_memory_mb')
      sort_used = '%f' % (float(i["swap"]["used"]) / i["swap"]["total"])
      used = float(i["swap"]["used"]) / i["swap"]["total"] * 100
      detail_used = round((i["swap"]["used"]) / 1024.0, 1)
      detail_total = round(i["swap"]["total"] / 1024.0, 1)
    %>
    <div class="bar">
      ## hidden sort helper
      <span style="display:none">${sort_used}</span>
      <span class="prog_bar_full" style="width:100px">
        <span class="prog_bar_used" style="width:${used}px"></span>
      </span>
      <span class="usage_detail">(${detail_used} / ${detail_total} GiB)</span>
    </div>
  % except:
    n/a
  % endtry
</%def>
<%def name="col_disk_usage(host)">
  % for i in host['ansible_facts'].get('ansible_mounts', []):
    % try:
      <%
        sort_used = '%f' % (float((i["size_total"] - i["size_available"])) / i["size_total"])
        used = float((i["size_total"] - i["size_available"])) / i["size_total"] * 100
        detail_used = round((i['size_total'] - i['size_available']) / 1073741824.0, 1)
        detail_total = round(i['size_total'] / 1073741824.0, 1)
      %>
      ## hidden sort helper
      <span style="display:none">${sort_used}</span>
      <div class="bar">
        <span class="prog_bar_full" style="width:100px">
          <span class="prog_bar_used" style="width:${used}px"></span>
        </span> ${i['mount']} <span class="usage_detail">(${detail_used} / ${detail_total} GiB)</span>
      </div>
    % except:
      n/a
      <%
      break  ## Stop listing disks, since there was an error.
      %>
    % endtry
  % endfor
</%def>
<%def name="col_comment(host)">
  ${host['hostvars'].get('comment', '')}
</%def>
<%def name="col_ext_id(host)">
  ${host['hostvars'].get('ext_id', '')}
</%def>
<%def name="col_gathered(host)">
  % if 'ansible_date_time' in host['ansible_facts']:
    ${host['ansible_facts']['ansible_date_time'].get('iso8601')}
  % endif
</%def>

##
## Detailed host information blocks
##
<%def name="host_general(host)">
  <h4>General</h4>
  <table>
    <tr><th>Node name</th><td>${host['ansible_facts'].get('ansible_nodename', '')}</td></tr>
    <tr><th>Form factor</th><td>${host['ansible_facts'].get('ansible_form_factor', '')}</td></tr>
    <tr><th>Virtualization role</th><td>${host['ansible_facts'].get('ansible_virtualization_role', '')}</td></tr>
    <tr><th>Virtualization type</th><td>${host['ansible_facts'].get('ansible_virtualization_type', '')}</td></tr>
  </table>
</%def>
<%def name="host_groups(host)">
  % if len(host.get('groups', [])) != 0:
    <h4>Groups</h4>
    <ul>
      % for group in sorted(host.get('groups', [])):
        <li>${group}</li>
      % endfor
    </ul>
  % endif
</%def>
<%def name="host_custvars(host)">
  % if len(host['hostvars']) != 0:
    <h4>Custom variables</h4>
    <table>
        % for var_name, var_value in host['hostvars'].items():
          <tr>
            <th>${var_name}</th>
            <td>
              % if type(var_value) == dict:
                ${r_dict(var_value)}
              % elif type(var_value) == list:
                ${r_list(var_value)}
              % else:
                ${var_value}
              % endif
        % endfor
    </table>
  % endif
</%def>
<%def name="host_localfacts(host)">
  % if len(host['ansible_facts'].get('ansible_local', {}).items()) != 0:
    <h4>Host local facts</h4>
    ${r_dict(host['ansible_facts'].get('ansible_local', {}))}
  % endif
</%def>
<%def name="host_factorfacts(host)">
  <%
  facter_facts = {}
  for key, value in host['ansible_facts'].items():
    if key.startswith('facter_'):
      facter_facts[key] = value
  %>
  % if len(facter_facts) != 0:
    <h4>Facter facts</h4>
    ${r_dict(facter_facts)}
  % endif
</%def>
<%def name="host_customfacts(host)">
  % if len(host.get('custom_facts', {}).items()) != 0:
    <h4>Custom facts</h4>
    ${r_dict(host['custom_facts'])}
  % endif
</%def>
<%def name="host_hardware(host)">
  <h4>Hardware</h4>
  <table>
    <tr><th>Vendor</th><td>${host['ansible_facts'].get('ansible_system_vendor', '')}</td></tr>
    <tr><th>Product name</th><td>${host['ansible_facts'].get('ansible_product_name', '')}</td></tr>
    <tr><th>Product serial</th><td>${host['ansible_facts'].get('ansible_product_serial', '')}</td></tr>
    <tr><th>Architecture</th><td>${host['ansible_facts'].get('ansible_architecture', '')}</td></tr>
    <tr><th>Form factor</th><td>${host['ansible_facts'].get('ansible_form_factor', '')}</td></tr>
    <tr><th>Virtualization role</th><td>${host['ansible_facts'].get('ansible_virtualization_role', '')}</td></tr>
    <tr><th>Virtualization type</th><td>${host['ansible_facts'].get('ansible_virtualization_type', '')}</td></tr>
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
</%def>
<%def name="host_os(host)">
  <h4>Operating System</h4>
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
</%def>
<%def name="host_network(host)">
  <h4>Network</h4>
  <table class="net_info">
    <tr><th>Hostname</th><td>${host['ansible_facts'].get('ansible_hostname', '')}</td></tr>
    <tr><th>Domain</th><td>${host['ansible_facts'].get('ansible_domain', '')}</td></tr>
    <tr><th>FQDN</th><td>${host['ansible_facts'].get('ansible_fqdn', '')}</td></tr>
    <tr><th>All IPv4</th><td>${'<br>'.join(host['ansible_facts'].get('ansible_all_ipv4_addresses', []))}</td></tr>
  </table>
  % if host['ansible_facts'].get('ansible_os_family', '') != "Windows":
    <table class="net_overview">
      <tr>
        <th>IPv4 Networks</th>
        <td>
          <table class="net_overview">
            <tr>
              <th>dev</th>
              <th>address</th>
              <th>network</th>
              <th>netmask</th>
            </tr>
            % for iface_name in sorted(host['ansible_facts'].get('ansible_interfaces', [])):
              <% iface = host['ansible_facts'].get('ansible_' + iface_name, {}) %>
              % for net in [iface.get('ipv4', {})] + iface.get('ipv4_secondaries', []):
                % if 'address' in net:
                  <tr>
                    <td>${iface_name}</td>
                    <td>${net['address']}</td>
                    <td>${net['network']}</td>
                    <td>${net['netmask']}</td>
                  </tr>
                % endif
              % endfor
            % endfor
          </table>
        </td>
      </tr>
    </table>
  % endif
  <table class="net_iface_details">
    <tr>
      <th>Interface details</th>
      <td>
        <table>
            % for iface in sorted(host['ansible_facts'].get('ansible_interfaces', [])):
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
</%def>
<%def name="host_storage(host)">
  <h4>Storage</h4>
  <table>
    <tr>
      <th>Devices</th>
      <td>
        % if type(host['ansible_facts'].get('ansible_devices')) == list:
          ${r_list(host['ansible_facts'].get('ansible_devices', []))}
        % else:
          ${r_dict(host['ansible_facts'].get('ansible_devices', {}))}
        % endif
      </td>
    </tr>
    <tr>
      <th>Mounts</th>
      <td>
        ${r_list(host['ansible_facts'].get('ansible_mounts', []))}
      </td>
    </tr>
  </table>
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

##
## HTML
##
<%
  if local_js is UNDEFINED:
    res_url = "https://cdn.datatables.net/1.10.2/"
  else:
    res_url = "file://" + data_dir + "/static/"
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Ansible overview</title>
  <style type="text/css">
    /* reset.css */
    html, body, div, span, applet, object, iframe,
    h1, h2, h3, h4, h5, h6, p, blockquote, pre,
    a, abbr, acronym, address, big, cite, code,
    del, dfn, em, img, ins, kbd, q, s, samp,
    small, strike, strong, sub, sup, tt, var,
    b, u, i, center,
    dl, dt, dd, ol, ul, li,
    fieldset, form, label, legend,
    table, caption, tbody, tfoot, thead, tr, th, td,
    article, aside, canvas, details, embed, 
    figure, figcaption, footer, header, hgroup, 
    menu, nav, output, ruby, section, summary,
    time, mark, audio, video { 
      margin: 0; padding: 0; border: 0; font-size: 100%; font: inherit; vertical-align: baseline;
    }
    /* HTML5 display-role reset for older browsers */
    article, aside, details, figcaption, figure, 
    footer, header, hgroup, menu, nav, section { display: block; }
    body { line-height: 1; }
    ol, ul { list-style: none; }
    blockquote, q { quotes: none; }
    blockquote:before, blockquote:after,
    q:before, q:after { content: ''; content: none; }
    table { border-collapse: collapse; border-spacing: 0; }

    /* ansible-cmdb */
    *, body { font-family: sans-serif; font-weight: lighter; }
    a { text-decoration: none; }

    header { position: fixed; top: 0px; left: 0px; right: 0px; background-color: #0071b8; overflow: auto; color: #E0E0E0; padding: 15px; z-index: 1000; }
    header h1 { font-size: x-large; float: left; line-height: 32px; font-weight: bold; }
    header #generated { float: right; line-height: 32px; font-size: small; }
    header #top { display: none; }
    header #top a { line-height: 32px; margin-left: 64px; color: #FFFFFF; border-bottom: 1px solid #909090; }
    header #generated .datetime { font-weight: bold; margin-left: 12px; }

    footer { display: block; position: fixed; bottom: 0px; right: 0px; left: 0px; background-color: #d5d5d5; overflow: auto; color: #505050; padding: 4px; font-size: x-small; text-align: right; padding-right: 8px; }
    footer a { font-weight: bold; text-decoration: none; color: #202020; }

    #col_toggles { margin: 32px; margin-top: 100px; }
    #col_toggles h2 { display: block; margin-bottom: 32px; color: #606060; }
    #col_toggle_buttons { margin-left: 32px; font-weight: normal; line-height: 40px; }
    #col_toggles a { line-height: 40px; }
    #col_toggles a { display: inline-block; background-color: #009688; line-height: 32px; padding: 0px 15px 0px 15px; margin-right: 6px; box-shadow: 2px 2px 0px 0px rgba(0,0,0,0.35); color: #FFFFFF; }
    #col_toggles a.col-invisible { background-color: #B0B0B0; box-shadow: 0 0px 0px 0; }

    #host_overview { margin: 32px; }
    #host_overview_tbl_wrapper{ margin-left: 16px; }
    #host_overview table { width: 100%; clear: both; }
    #host_overview tr { border-bottom: 1px solid #F0F0F0; }
    #host_overview tr:hover { background-color: #F0F0F0; }
    #host_overview thead th { text-align: left; color: #707070; font-weight: bold; cursor: pointer; background-repeat: no-repeat; background-position: center right; background-image: url("${res_url}/images/sort_both.png"); }
    #host_overview thead th.sorting_desc { background-image: url("${res_url}/images/sort_desc.png"); }
    #host_overview thead th.sorting_asc { background-image: url("${res_url}/images/sort_asc.png"); }
    #host_overview tbody td { color: #000000; padding: 8px 12px 8px 12px; }
    #host_overview tbody a { text-decoration: none; color: #005c9d; }
    #host_overview_tbl_filter { float: right; color: #808080; }
    #host_overview_tbl_filter label input { margin-left: 12px; }
    #host_overview_tbl_filter #filter_link a { color: #000000; background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAoUlEQVR4Xu2TIQ6EMBBF/+4dOUBFBYoboBHoBsuRUCgcnpDg3/Y7ICQVK3ebvPxJ30xH9QXom/PO/PoDAjSOY8pwIwFFr2EYUobjONj33bjGd3Ylr77v2bYNp7Hwhifs3HOeUdu2LMuCE1DXdedtl612cJ1R0zRM04TT1HVNjPERO/ecZxRCSBnmeWZdV+Ma39mVvABVVZUy3EhA0f//gvQB4y08WIiD/goAAAAASUVORK5CYII=) no-repeat left center; padding: 5px 0 5px 25px; }
    #host_overview_tbl_info { margin-top: 16px; color: #C0C0C0; }
    #host_overview .bar { clear: both; }
    #host_overview .prog_bar_full { float: left; display: block; height: 12px; border: 1px solid #000000; padding: 1px; margin-right: 4px; color: white; text-align: center; }
    #host_overview .prog_bar_used { display: block; height: 12px; background-color: #8F4040; }
    #host_overview tbody td.error a { color: #FF0000; }
    #host_overview span.usage_detail { color: #606060; }

    #hosts { margin-left: 32px; margin-bottom: 120px; }
    #hosts a { color: #000000; }
    #hosts h3 { margin-top: 128px; padding-bottom: 16px; font-size: xx-large; border-bottom: 1px solid #D0D0D0; }
    #hosts h4 { font-size: large; font-weight: bold; color: #404040; margin-top: 32px; margin-bottom: 32px; }
    #hosts th { text-align: left; color: #909090; padding-bottom: 10px; }
    #hosts td { padding-left: 16px; color: #303030; padding-bottom: 10px; }
    #hosts ul { list-style: square; margin-left: 48px; }
    #hosts table.net_overview td,th { text-align: left; padding: 0px 0px 8px 16px; margin: 0px; }
    #hosts table.net_overview { margin: 16px 0px 16px 0px; }
    #hosts .error { color: #FF0000; }
  </style>
  <!-- DataTables assets -->
  % if local_js is UNDEFINED:
    <script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
  % else:
    <script type="text/javascript" charset="utf8" src="${res_url}/js/jquery-1.10.2.min.js"></script>
  % endif
  <script type="text/javascript" charset="utf8" src="${res_url}/js/jquery.dataTables.js"></script>
</head>
<body>

<header>
  <h1>Host Overview</h1>
  <span id="top"><a href="#">Back to top</a></span>
  <span id="generated">Generated on <span class="datetime">${datetime.datetime.now().strftime('%c')}</span></span>
</header>

<div id="col_toggles">
  <h2>Shown columns</h2>
  <div id="col_toggle_buttons">
    % for col in cols:
      <%
        visible = "visible"
        if col['visible'] is False:
          visible = "invisible"
      %>
      <a href="" class="col-toggle col-${visible}" data-column="${loop.index}" data-column-id="${col["id"]}">${col['title']}</a>
    % endfor
  </div>
</div>

<div id="host_overview">
  <h2>Host overview</h2>
  <div id="host_overview_tbl_wrapper">
    <table id="host_overview_tbl" class="demo display dataTable compact">
    <thead>
      <tr>
        % for col in cols:
          <th>${col['title']}</th>
        % endfor
      </tr>
    </thead>
    <tbody>
      % for hostname, host in hosts.items():
        <%
        log.debug("Rendering host overview for {0}".format(hostname))
        %>
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
  </div>
</div>

<div id="hosts">
  % for hostname, host in hosts.items():
    <%
    log.debug("Rendering host details for {0}".format(hostname))
    %>
    <a href="#${host['name']}" name="${host['name']}"><h3 id="${host['name']}">${host['name']}</h3></a>
    % if 'ansible_facts' not in host:
      <p>No host information collected</p>
      % if 'msg' in host:
        <p class="error">${host['msg']}</p>
      % endif
      <% host_groups(host) %>
      <% host_custvars(host) %>
    % else:
      <% host_general(host) %>
      <% host_groups(host) %>
      <% host_custvars(host) %>
      <% host_localfacts(host) %>
      <% host_factorfacts(host) %>
      <% host_customfacts(host) %>
      <% host_hardware(host) %>
      <% host_os(host) %>
      <% host_network(host) %>
      <% host_storage(host) %>
    % endif
  % endfor
</div>

<footer>
  <p>Generated by <a href="https://github.com/fboender/ansible-cmdb">ansible-cmdb</a> v${version} &dash; &copy; Ferry Boender 2015</p>
</footer>

<script>
function getQueryParams(qs) {
  qs = qs.split('+').join(' ');
  var params = {},
    tokens,
    re = /[?&]?([^=]+)=([^&]*)/g;
  while (tokens = re.exec(qs)) {
    params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
  }
  return params;
}

$(document).ready( function () {
  // Get persisted column visibility from localStorage.
  var columnVisibility = localStorage.getItem("columnVisibility");
  if (columnVisibility == null) {
    columnVisibility = {
      % for col in cols:
        "${col["id"]}": ${str(col["visible"]).lower()},
      % endfor
    };
    localStorage.setItem("columnVisibility", JSON.stringify(columnVisibility));
  } else {
    columnVisibility = JSON.parse(columnVisibility);
  }

  // Initialize the DataTables jQuery plugin on the host overview table
  var table = $('#host_overview_tbl').DataTable({
    paging: false,
    columnDefs: [
      % for col in cols:
        {
          "targets": [${loop.index}],
          "visible": ${str(col['visible']).lower()},
          "sType": "${col['sType']}" 
        },
      % endfor
    ],
    "fnInitComplete": function() {
      // Focus the input field
      $("#host_overview_tbl_filter input").focus();

      // Set the search box value to the query string 'search' part
      var qp = getQueryParams(document.location.search);
      if ("search" in qp) {
        $("#host_overview_tbl_filter input").val(qp.search);
        this.fnFilter(qp.search);
      }
    }
  });

  // Display or hide columns based on localStorage preferences.
  for (var columnId in columnVisibility) {
    var columnButton = $("a[data-column-id='" + columnId +"']");
    var columnNr = columnButton.attr('data-column');
    var column = table.column(columnNr);
    column.visible(columnVisibility[columnId]);
    var newClass = ['col-invisible','col-visible'][Number(column.visible())];
    columnButton.get(0).className = 'col-toggle ' + newClass;
  }

  // Show a direct link to the search term
  table.on( 'search.dt', function () {
    $('#filter_link').remove();
    if (table.search() == "") {
    } else {
      $('#host_overview_tbl_filter label').after('&nbsp; <span id="filter_link"><a title="Direct link to search" href="?search='+table.search()+'">&nbsp;</a></span>');
    }
  } );

  // Show and hide columns on button clicks
  $('a.col-toggle').on('click', function(e) {
    e.preventDefault();
    var columnId = $(this).attr('data-column-id')
    var column = table.column( $(this).attr('data-column') );
    column.visible( ! column.visible() );
    var newClass = ['col-invisible','col-visible'][Number(column.visible())];
    e.target.className = 'col-toggle ' + newClass;

    // Storage column visibility in localStorage.
    columnVisibility[columnId] = column.visible();
    localStorage.setItem("columnVisibility", JSON.stringify(columnVisibility));
  });

  // Show host name in header bar when scrolling
  $( window ).scroll(function() {
    var scrollTop = $(window).scrollTop();
    var curElem = false;
    $( "#hosts h3" ).each(function( index ) {
      var el = $(this);
      if ((el.offset().top - 128) <= scrollTop) {
        curElem = el;
      } else {
        return false;
      }
    });
    if (curElem) {
      $("header h1").text(curElem.text());
      $('#top').show();
    } else {
      $("header h1").text("Host Overview");
      $('#top').hide();
    };
  });
});
</script>

</body>
</html>
