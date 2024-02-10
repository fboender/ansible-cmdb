<%
import yaml

class CustDumper(yaml.SafeDumper):
    def represent_data(self, data):
        if isinstance(data, set):
            return self.represent_list(data)
        return super().represent_data(data)

print(yaml.dump(hosts, Dumper=CustDumper))
%>
