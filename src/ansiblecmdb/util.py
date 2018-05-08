import copy
import os
import stat


def is_executable(path):
    """
    Determine whether `path` points to an executable file.
    """
    return stat.S_IXUSR & os.stat(path)[stat.ST_MODE]


def deepupdate(target, src, overwrite=True):
    """Deep update target list, dict or set or other iterable with src
    For each k,v in src: if k doesn't exist in target, it is deep copied from
    src to target. Otherwise, if v is a list, target[k] is extended with
    src[k]. If v is a set, target[k] is updated with v, If v is a dict,
    recursively deep-update it. If `overwrite` is False, existing values in
    target will not be overwritten.

    Examples:
    >>> t = {'name': 'Ferry', 'hobbies': ['programming', 'sci-fi']}
    >>> deepupdate(t, {'hobbies': ['gaming']})
    >>> print t
    {'name': 'Ferry', 'hobbies': ['programming', 'sci-fi', 'gaming']}
    """
    for k, v in src.items():
        if type(v) == list:
            if not k in target:
                target[k] = copy.deepcopy(v)
            elif overwrite is True:
                target[k].extend(v)
        elif type(v) == dict:
            if not k in target:
                target[k] = copy.deepcopy(v)
            else:
                deepupdate(target[k], v, overwrite=overwrite)
        elif type(v) == set:
            if not k in target:
                target[k] = v.copy()
            elif overwrite is True:
                target[k].update(v.copy())
        else:
            if k not in target or overwrite is True:
                target[k] = copy.copy(v)


def find_path(dirs, path_to_find):
    """
    Go through a bunch of dirs and see if dir+path_to_find exists there.
    Returns the first dir that matches. Otherwise, return None.
    """
    for dir in dirs:
        if os.path.exists(os.path.join(dir, path_to_find)):
            return dir
    return None


def to_bool(s):
    """
    Convert string `s` into a boolean. `s` can be 'true', 'True', 1, 'false',
    'False', 0.

    Examples:

    >>> to_bool("true")
    True
    >>> to_bool("0")
    False
    >>> to_bool(True)
    True
    """
    if isinstance(s, bool):
        return s
    elif s.lower() in ['true', '1']:
        return True
    elif s.lower() in ['false', '0']:
        return False
    else:
        raise ValueError("Can't cast '%s' to bool" % (s))
