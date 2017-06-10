## -*- coding: utf-8 -*-
<%! from ansiblecmdb.util import to_bool %>

<%namespace name="defs" file="/html_fancy_defs.html" import="*" />

<%
# Default parameter values
local_js = to_bool(context.get('local_js', '0'))
collapsed = to_bool(context.get('collapsed', '0'))

# Set the Javascript resource URL (local disk or CDN)
if local_js is False:
  res_url = "https://cdn.datatables.net/1.10.2/"
else:
  res_url = "file://" + data_dir + "/static/"
%>

<% html_header(host['name'], local_js, res_url) %>
<% html_header_bar(host['name']) %>
<div id="hosts">
  <% html_host_detail(host) %>
</div>
<% html_footer_bar(version) %>

<script>
$(document).ready( function () {
  <% js_ev_collapse() %>
});
</script>

<% html_footer() %>
