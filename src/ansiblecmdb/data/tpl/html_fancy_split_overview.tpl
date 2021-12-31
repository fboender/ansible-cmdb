## -*- coding: utf-8 -*-
<%! from ansiblecmdb.util import to_bool %>
<%! import os %>

<%namespace name="defs" file="/html_fancy_defs.html" import="*" />

<%
# Default parameter values
local_js = to_bool(context.get('local_js', '0'))
collapsed = to_bool(context.get('collapsed', '0'))
host_details = to_bool(context.get('host_details', '1'))
skip_empty = to_bool(context.get('skip_empty', '0'))

# Get column definitions from html_fancy_defs.html
cols = var_cols(columns, exclude_columns)

# Extend default columns with custom columns
cols.extend(cust_cols)

# Set the Javascript resource URL (local disk or CDN)
if local_js is False:
  res_url = os.getenv('STATIC_ROOT_URL', ".")
  jquery_res_uri = os.getenv('JQUERY_RES_URI', "js/jquery-1.10.2.min.js")
  dataTable_res_uri = os.getenv('DATATABLE_RES_URI', "js/jquery.dataTables.js")
else:
  res_url = "."
  jquery_res_uri = "js/jquery-1.10.2.min.js"
  dataTable_res_uri = "js/jquery.dataTables.js"

# Set the link type for the host overview table's 'host' column (the link that
# takes you to the host details).
link_type = "external"
if host_details is False:
  link_type = "none"
%>

<% html_header("Ansible Overview", local_js, res_url, jquery_res_uri, dataTable_res_uri) %>
<% html_header_bar("Host overview") %>
<% html_col_toggles(cols) %>
<% html_host_overview(cols, hosts, skip_empty=skip_empty, link_type=link_type) %>
<script>
$(document).ready( function () {
  <% js_init_host_overview(cols) %>
  <% js_ev_collapse() %>
});
<% js_export_to_csv() %>
  //paste this code under the head tag or in a separate js file.
  // Wait for window load
  $(window).load(function() {
    // Animate loader off screen
    $(".se-pre-con").fadeOut("slow");;
  });
</script>
<% html_footer() %>
