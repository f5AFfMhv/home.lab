NFS
=========

Provision NFS server

Requirements
------------


Role Variables
--------------
```yaml
nfs_path:     # nfs server file path
```

Dependencies
------------


Example Playbook
----------------
```yaml
- hosts: servers
  roles:
     - { role: nfs }
```

License
-------

GPL-2.0-or-later

Author Information
------------------

Martynas J.
