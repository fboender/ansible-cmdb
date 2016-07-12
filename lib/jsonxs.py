#!/usr/bin/env python

"""
jsonxs uses a path expression string to get and set values in JSON and Python
datastructures.

For example:

    >>> d = {
    ...   'feed': {
    ...     'id': 'my_feed',
    ...     'url': 'http://example.com/feed.rss',
    ...     'tags': ['devel', 'example', 'python'],
    ...     'short.desc': 'A feed',
    ...   }
    ... }

    # Get the value for a path expression
    >>> jsonxs(d, 'feed.tags[-1]')
    'python'

    # Access paths with special chars in them
    >>> jsonxs(d, 'feed.short\.desc')
    'A feed'

    # Set the value for a path expression
    >>> jsonxs(d, 'feed.id', ACTION_SET, 'your_feed')
    >>> d['feed']['id']
    'your_feed'

    # Replace a value in a list
    >>> jsonxs(d, 'feed.tags[-1]', ACTION_SET, 'javascript')
    >>> d['feed']['tags']
    ['devel', 'example', 'javascript']

    # Create a new key in a dict
    >>> jsonxs(d, 'feed.author', ACTION_SET, 'Ferry Boender')
    >>> d['feed']['author']
    'Ferry Boender'

    # Delete a value from a list
    >>> jsonxs(d, 'feed.tags[0]', ACTION_DEL)
    >>> d['feed']['tags']
    ['example', 'javascript']

    # Delete a key/value pair from a dictionary
    >>> jsonxs(d, 'feed.url', ACTION_DEL)
    >>> 'url' in d['feed']
    False

    # Append a value to a list
    >>> jsonxs(d, 'feed.tags', ACTION_APPEND, 'programming')
    >>> d['feed']['tags']
    ['example', 'javascript', 'programming']

    # Insert a value to a list
    >>> jsonxs(d, 'feed.tags[1]', ACTION_INSERT, 'tech')
    >>> d['feed']['tags']
    ['example', 'tech', 'javascript', 'programming']

    # Create a dict value
    >>> jsonxs(d, 'feed.details', ACTION_MKDICT)
    >>> d['feed']['details'] == {}
    True

    # Create a list value
    >>> jsonxs(d, 'feed.details.users', ACTION_MKLIST)
    >>> d['feed']['details']['users'] == []
    True

    # Fill the newly created list
    >>> jsonxs(d, 'feed.details.users', ACTION_APPEND, 'fboender')
    >>> jsonxs(d, 'feed.details.users', ACTION_APPEND, 'ppeterson')
    >>> d['feed']['details']['users']
    ['fboender', 'ppeterson']
"""


ACTION_GET = 'get'
ACTION_SET = 'set'
ACTION_DEL = 'del'
ACTION_APPEND = 'append'
ACTION_INSERT = 'insert'
ACTION_MKDICT = 'mkdict'
ACTION_MKLIST = 'mklist'


def tokenize(expr):
    """
    Parse a string expression into a set of tokens that can be used as a path
    into a Python datastructure.
    """
    tokens = []
    escape = False
    cur_token = ''

    for c in expr:
        if escape == True:
            cur_token += c
            escape = False
        else:
            if c == '\\':
                # Next char will be escaped
                escape = True
                continue
            elif c == '[':
                # Next token is of type index (list)
                if len(cur_token) > 0:
                    tokens.append(cur_token)
                    cur_token = ''
            elif c == ']':
                # End of index token. Next token defaults to a key (dict)
                if len(cur_token) > 0:
                    tokens.append(int(cur_token))
                    cur_token = ''
            elif c == '.':
                # End of key token. Next token defaults to a key (dict)
                if len(cur_token) > 0:
                    tokens.append(cur_token)
                    cur_token = ''
            else:
                # Append char to token name
                cur_token += c
    if len(cur_token) > 0:
        tokens.append(cur_token)

    return tokens


def jsonxs(data, expr, action=ACTION_GET, value=None, default=None):
    """
    Get, set, delete values in a JSON structure. `expr` is a JSONpath-like
    expression pointing to the desired value. `action` determines the action to
    perform. See the module-level `ACTION_*` constants. `value` should be given
    if action is `ACTION_SET`. If `default` is set and `expr` isn't found,
    return `default` instead. This will override all exceptions.
    """
    tokens = tokenize(expr)

    # Walk through the list of tokens to reach the correct path in the data
    # structure.
    try:
        prev_path = None
        cur_path = data
        for token in tokens:
            prev_path = cur_path
            if not token in cur_path and action in [ACTION_SET, ACTION_MKDICT, ACTION_MKLIST]:
                # When setting values or creating dicts/lists, the key can be
                # missing from the data struture
               continue
            cur_path = cur_path[token]
    except Exception:
        if default is not None:
            return default
        else:
            raise

    # Perform action the user requested.
    if action == ACTION_GET:
        return cur_path
    elif action == ACTION_DEL:
        del prev_path[token]
    elif action == ACTION_SET:
        prev_path[token] = value
    elif action == ACTION_APPEND:
        prev_path[token].append(value)
    elif action == ACTION_INSERT:
        prev_path.insert(token, value)
    elif action == ACTION_MKDICT:
        prev_path[token] = {}
    elif action == ACTION_MKLIST:
        prev_path[token] = []
    else:
        raise ValueError("Invalid action: {}".format(action))


if __name__ == "__main__":
    import doctest
    doctest.testmod()
