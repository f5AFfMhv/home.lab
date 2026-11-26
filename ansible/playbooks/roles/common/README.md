Common
=========

Common system preparation for debian machine.

Requirements
------------


Role Variables
--------------
```yaml
apt_repositories: []    # list of deb822 repositories: name, uris, suites, components, architectures (optional), signed_by (optional key URL)
apt_legacy_sources: []  # list of old one-line *.list files in /etc/apt/sources.list.d to remove
packages: []            # list of packages to be installed by apt
resources: []           # list of .deb package URLs to be downloaded and installed
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
