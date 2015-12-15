nfs4acl Chef cookbook
=====================
The nfs4acl cookbook provides the nfs4_setfacl custom resource.

Requirements
------------
- Chef 12.5 or higher
- Ruby 2.0 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories

#### Packages
- `nfs4-acl-tools` - nfs4acl needs `nfs4_getfacl` and `nfs4_setfacl` commands.

Platform Support
----------------
The following platforms have been tested with Test Kitchen:
- CentOS
- Red Hat

Usage
-----
#### metadata.rb
Include `nfs4acl` as a dependency in your cookbook's `metadata.rb`.

```
depends 'nfs4acl', '= 0.1.0'
```

#### nfs4acl::default
Default recipe is blank.

Resources
---------

Define a `nfs4_setfacl` resource in a recipe to set an ACL on a NFS4 mounted file/directory.
Specify the file/directory path as the resource name and the ACL as an array of strings.

    nfs4_setfacl '/tmp/test_file_or_dir' do
      acl [
        'A::OWNER@:rwaDxtTnNcCy',
        'D::OWNER@:o',
        'A:g:GROUP@:rxtncy',
        'D:g:GROUP@:waDTNCo',
        'A::EVERYONE@:rxtncy',
        'D::EVERYONE@:waDTNCo'
      ]
    end

Contributing
------------
1. Fork the repository on Github.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change (if applicable).
5. Run the tests, ensuring they all pass.
6. Submit a Pull Request using Github.

License and Authors
-------------------
Author: Richard Lock (University of Derby)

Copyright 2015 University of Derby

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.