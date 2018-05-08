"""
Custom Yaml library wrapper, because Yaml is a bag of shit.
"""

try:
    import yaml
except ImportError:
    import yaml3 as yaml

class StupidYAMLShit(yaml.SafeLoader):
    """
    FUCK PYYAML. This class overrides some insanely deep shit which took at
    least two hours to get working. This class overrides SafeLoader and handles
    tags (e.g. '!bullshit') nonsense in PyYAML, because obviously there is no
    ignore_tags option or a simple callback that actually works. That would be
    user-friendly, and user-friendliness is insanity, amirite?!

    Also, there is no single entry point to hook into this, so we need to
    specifically inherit from *SafeLoader* and not from *Loader*. Thanks for
    wasting some more of my fucking time PyYAML, you turd.

    On a pyyaml-rage-induced side note: How many apps are vulnerable because
    all the PyYaml docs mention 'load' and not 'safe_load'? Was this diseased
    pile of gunk written by a PHP programmer?!

    """
    def handle_tag(self, node_name, node):
        # I just *know* there are gonna be problems with simply returning a
        # Scalar, but I don't give a fuck at this point.
        if node_name == "vault":
            new_node = yaml.ScalarNode(node_name, 'ENCRYPTED CONTENTS REDACTED')
        else:
            new_node = yaml.ScalarNode(node_name, node.value)

        return self.construct_scalar(new_node)


# Fugly!
StupidYAMLShit.add_multi_constructor(
    u'!',
    StupidYAMLShit.handle_tag)


def safe_load(contents):
    return yaml.load(contents, Loader=StupidYAMLShit)
