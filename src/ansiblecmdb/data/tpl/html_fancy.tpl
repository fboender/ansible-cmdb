<%
##
## Column definitions
##
import datetime
cols = [
  {"title": "Name",       "id": "name",       "func": col_name,       "visible": True},
  {"title": "DTAP",       "id": "dtap",       "func": col_dtap,       "visible": True},
  {"title": "Groups",     "id": "groups",     "func": col_groups,     "visible": False},
  {"title": "FQDN",       "id": "fqdn",       "func": col_fqdn,       "visible": True},
  {"title": "OS",         "id": "os",         "func": col_os,         "visible": True},
  {"title": "Main IP",    "id": "main_ip",    "func": col_main_ip,    "visible": True},
  {"title": "All IPv4",   "id": "all_ipv4",   "func": col_all_ip,     "visible": False},
  {"title": "Arch",       "id": "arch",       "func": col_arch,       "visible": False},
  {"title": "Mem",        "id": "mem",        "func": col_mem,        "visible": True},
  {"title": "CPUs",       "id": "cpus",       "func": col_cpus,       "visible": False},
  {"title": "Virt",       "id": "virt",       "func": col_virt,       "visible": False},
  {"title": "Disk usage", "id": "disk_usage", "func": col_disk_usage, "visible": False},
  {"title": "Comment",    "id": "comment",    "func": col_comment,    "visible": True},
  {"title": "Ext ID",     "id": "ext_id",     "func": col_ext_id,     "visible": True},
  {"title": "Kernel",     "id": "kernel",     "func": col_kernel,     "visible": True},
  {"title": "Timestamp",  "id": "timestamp",  "func": col_gathered,   "visible": True},
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
<%def name="col_os(host)">
  ${host['ansible_facts'].get('ansible_distribution', '')} ${host['ansible_facts'].get('ansible_distribution_version', '')}
</%def>
<%def name="col_kernel(host)">
  ${host['ansible_facts'].get('ansible_kernel', '')}
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
<%def name="col_gathered(host)">
  % if 'ansible_date_time' in host['ansible_facts']:
    ${host['ansible_facts']['ansible_date_time'].get('iso8601')}
  % endif
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
    *, body {
      font-family: sans-serif; font-weight: lighter;
    }
    a { text-decoration: none; }
    header {
      position: fixed;
      top: 0px;
      left: 0px;
      right: 0px;
      background-color: #0071b8;
      overflow: auto;
      color: #E0E0E0;
      padding: 15px;
      z-index: 1000;
    }
    header h1 {
      font-size: x-large;
      float: left;
      line-height: 32px;
      font-weight: bold;
    }
    header #generated {
      float: right;
      line-height: 32px;
      font-size: small;
    }
    header #top {
        display: none;
    }
    header #top a {
        line-height: 32px;
        margin-left: 64px;
        color: #FFFFFF;
        border-bottom: 1px solid #909090;
    }
    #generated .datetime {
      font-weight: bold;
      margin-left: 12px;
    }
    #col_toggles {
      margin: 32px;
      margin-top: 100px;
    }
    h2 {
      display: block;
      margin-bottom: 32px;
      color: #606060;
    }
    #col_toggle_buttons {
      margin-left: 32px;
      font-weight: normal;
      line-height: 40px;
    }
    #col_toggles a {
      line-height: 40px;
    }
    #col_toggles a {
      display: inline-block;
      background-color: #009688;
      line-height: 32px;
      padding: 0px 15px 0px 15px;
      margin-right: 6px;
      font-size: small;
      box-shadow: 2px 2px 0px 0px rgba(0,0,0,0.35);
      color: #FFFFFF;
    }
    #col_toggles a.col-invisible{
      background-color: #B0B0B0;
      box-shadow: 0 0px 0px 0;
    }

    #host_overview {
      margin: 32px;
    }
    #jquery_sucks{
      margin-left: 32px;
    }
    #host_overview table {
      width: 100%;
      clear: both;
    }
    #host_overview th, #host_overview td {
      font-size: small;
      padding: 8px 12px 8px 12px;
    }
    #host_overview thead th {
      text-align: left;
      color: #707070;
      font-size: x-small;
      font-weight: bold;
      cursor: pointer;
      background-repeat: no-repeat;
      background-position: center right;
      background-image: url("${res_url}/images/sort_both.png");
    }
    #host_overview thead th.sorting_desc {
      background-image: url("${res_url}/images/sort_desc.png");
    }
    #host_overview thead th.sorting_asc {
      background-image: url("${res_url}/images/sort_asc.png");
    }
    #host_overview tr {
      border-bottom: 1px solid #F0F0F0;
    }
    #host_overview tr:hover {
      background-color: #F0F0F0;
    }
    #host_overview tbody td {
      color: #000000;
    }
    #host_overview tbody a {
      text-decoration: none;
      color: #005c9d;
    }
    #host_overview_tbl_filter {
      float: right;
      font-size: small;
      color: #808080;
    }
    #host_overview_tbl_filter label input {
      margin-left: 12px;
    }
    #host_overview_tbl_info {
      font-size: x-small;
      margin-top: 16px;
      color: #C0C0C0;
    }
    .bar {
      clear: both;
    }
    .prog_bar_full {
      float: left;
      display: block;
      height: 12px;
      border: 1px solid #000000;
      padding: 1px;
      margin-right: 4px;
      color: white;
      text-align: center;
    }
    .prog_bar_used { display: block; height: 12px; background-color: #8F4040; }

    #hosts {
      margin-left: 32px;
      margin-bottom: 120px;
    }
    #hosts h3 {
      margin-top: 128px;
      padding-bottom: 16px;
      font-size: xx-large;
      border-bottom: 1px solid #D0D0D0;
    }
    #hosts h4 {
      font-size: large;
      font-weight: bold;
      color: #404040;
      margin-top: 32px;
      margin-bottom: 32px;
    }
    #hosts th {
      text-align: left;
      color: #909090;
      padding-bottom: 10px;
    }
    #hosts td {
      padding-left: 16px;
      color: #303030;
      padding-bottom: 10px;
    }
    .error { color: #FF0000; }
    #host_overview tbody td.error a {
        color: #FF0000;
    }
    #disk_usage_detail { font-size: small; }
    footer {
      display: block;
      position: fixed;
      bottom: 0px;
      right: 0px;
      left: 0px;
      background-color: #d5d5d5;
      overflow: auto;
      color: #505050;
      padding: 4px;
      font-size: x-small;
      text-align: right;
      padding-right: 8px;
    }
    footer a {
      font-weight: bold;
      text-decoration: none;
      color: #202020;
    }
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
      <a href="" class="col-toggle col-${visible}" data-column="${loop.index}">${col['title']}</a>
    % endfor
  </div>
</div>

<div id="host_overview">
  <h2>Host overview</h2>
  <div id="jquery_sucks">
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
    % if 'ansible_facts' not in host:
      <a name="${host['name']}"><h3 id="${host['name']}">${host['name']}</h3></a>
      <p>No host information collected</p>
      % if 'msg' in host:
        <p class="error">${host['msg']}</p>
      % endif
    % else:
      <a name="${host['name']}"><h3 id="${host['name']}">${host['name']}</h3></a>
      <h4>General</h4>
      <table>
        <tr><th>Node name</th><td>${host['ansible_facts'].get('ansible_nodename', '')}</td></tr>
        <tr><th>Form factor</th><td>${host['ansible_facts'].get('ansible_form_factor', '')}</td></tr>
        <tr><th>Virtualisation role</th><td>${host['ansible_facts'].get('ansible_virtualization_role', '')}</td></tr>
        <tr><th>Virtualisation type</th><td>${host['ansible_facts'].get('ansible_virtualization_type', '')}</td></tr>
      </table>

      <h4>Custom variables</h4>
      <table>
          % for var_name, var_value in host['hostvars'].items():
            <tr><th>${var_name}</th><td>${var_value}</td></tr>
          % endfor
      </table>

      <h4>Hardware</h4>
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

      <h4>Network</h4>
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

      <h4>Storage</h4>
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
</div>

<footer>
  <p>Generated by <a href="https://github.com/fboender/ansible-cmdb">ansible-cmdb</a> v${version} &dash; &copy; Ferry Boender 2015</p>
</footer>

<script>
$(document).ready( function () {
  // Initialize the DataTables jQuery plugin on the host overview table
  var table = $('#host_overview_tbl').DataTable({
    paging: false,
    columnDefs: [
      % for col in cols:
        { "targets": [${loop.index}], "visible": ${str(col['visible']).lower()} },
      % endfor
    ],
    "fnInitComplete": function() {
      // Focus the input field
      $("#host_overview_tbl_filter input").focus();
    }

  });

  // Show and hide columns on button clicks
  $('a.col-toggle').on('click', function(e) {
    e.preventDefault();
    var column = table.column( $(this).attr('data-column') );
    column.visible( ! column.visible() );
    var newClass = ['col-invisible','col-visible'][Number(column.visible())];
    e.target.className = 'col-toggle ' + newClass;
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
