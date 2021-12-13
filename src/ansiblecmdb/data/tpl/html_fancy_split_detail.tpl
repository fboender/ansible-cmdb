## -*- coding: utf-8 -*-
<%! from ansiblecmdb.util import to_bool %>
<%! import os %>

<%namespace name="defs" file="/html_fancy_defs.html" import="*" />

<%
# Default parameter values
local_js = to_bool(context.get('local_js', '0'))
collapsed = to_bool(context.get('collapsed', '0'))

# Set the Javascript resource URL (local disk or CDN)
if local_js is False:
  res_url = os.getenv('STATIC_ROOT_URL', "./")
  jquery_res_uri = os.getenv('STATIC_ROOT_URL', "js/jquery-1.10.2.min.js")
  dataTable_res_uri = os.getenv('STATIC_ROOT_URL', "js/jquery.dataTables.js")
else:
  res_url = "."
  jquery_res_uri = "js/jquery-1.10.2.min.js"
  dataTable_res_uri = "js/jquery.dataTables.js"
%>

<% html_header(host['name'], local_js, res_url) %>
<% html_header_bar(host['name']) %>
<div id="hosts">
  <% html_host_detail(host, collapsed=collapsed, skip_empty=skip_empty, is_split=True) %>
</div>
<% html_footer_bar(version) %>

<script>
$(document).ready( function () {
  <% js_ev_collapse() %>
});
</script>

<% html_footer() %>
