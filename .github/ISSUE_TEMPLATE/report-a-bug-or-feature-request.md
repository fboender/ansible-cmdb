---
name: Report a bug or feature request
about: Report a bug of feature request

---

If you're reporting a bug:

* Don't worry if you're new to reporting bugs or don't know which information
  to provide. Just try to follow the guidelines below, and we'll figure it
  out.
* Please provide output of `ansible-cmdb --debug`
* Please reduce your facts (just delete some of the `ansible -m setup` output
  files) until you're left with a single fact or fact file that still
  reproduces the problem.
* If possible, please attach the problematic fact file.

If you're report a feature request:

* Please do not file feature requests for column additions. Every user of
  ansible-cmdb has different requirements and adding an endless variety of
  columns is both unpractical and is quite a burden on the developer of
  ansible-cmdb. You can easily add custom columns yourself with the [Custom
  Columns](https://ansible-cmdb.readthedocs.io/en/latest/usage/#custom-columns)
  feature. Pull requests are welcome if you believe the columns are useful for
  a wide audience.
