## -*- coding: utf-8 -*-
<%! from ansiblecmdb.util import to_bool %>

<%namespace name="defs" file="/html_fancy_defs.html" import="*" />

<%
# Default parameter values
local_js = to_bool(context.get('local_js', '0'))
collapsed = to_bool(context.get('collapsed', '0'))
host_details = to_bool(context.get('host_details', '1'))
skip_empty = to_bool(context.get('skip_empty', '0'))

# Get column definitions from html_fancy_defs.html
cols = var_cols(columns, exclude_columns)

# Set the Javascript resource URL (local disk or CDN)
if local_js is False:
  res_url = "https://cdn.datatables.net/1.10.2/"
else:
  res_url = "file://" + data_dir + "/static/"

# Set the link type for the host overview table's 'host' column (the link that
# takes you to the host details).
link_type = "anchor"
if host_details is False:
  link_type = "none"
%>

<% html_header("Ansible Overview", local_js, res_url) %>
<% html_header_bar("Host overview") %>
<% html_col_toggles(cols) %>
<% html_host_overview(cols, hosts, skip_empty=skip_empty, link_type=link_type) %>
% if host_details is True:
  <% html_host_details(hosts, collapsed=collapsed, skip_empty=skip_empty) %>
% endif
<% html_footer_bar(version) %>

<script>
$(document).ready( function () {
  <% js_init_host_overview(cols) %>
  <% js_ev_collapse() %>

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

<% html_footer() %>
