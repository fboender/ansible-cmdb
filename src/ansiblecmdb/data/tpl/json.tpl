<%
import json

class CustEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, set):
            return list(obj)
        return json.JSONEncoder.default(self, obj)

print json.dumps(hosts, indent=2, cls=CustEncoder)
%>
