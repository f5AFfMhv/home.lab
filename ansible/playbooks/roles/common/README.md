Common
=========

Common system preparation for debian machine.

Requirements
------------


Role Variables
--------------
```yaml
gpg_keys: []          # list of URLs for apt repository gpg keys
apt_repositories: []  # list of apt repositories
packages: []          # list of packages to be installed by apt
resources: []         # list of .deb package URLs to be downloaded and installed
```

Dependencies
------------


Example Playbook
----------------
```yaml
- hosts: servers
  roles:
     - { role: common }
```

License
-------

GPL-2.0-or-later

Author Information
------------------

Martynas J.
