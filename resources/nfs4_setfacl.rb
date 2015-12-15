#
# Cookbook Name:: nfs4acl
# Resource:: nfs4_setfacl
#
# Copyright 2015 University of Derby
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :nfs4_setfacl
default_action :create
property :acl, [String, Array], required: true
property :file_path, String, required: true, name_property: true
current_acl = nil

load_current_value do
  # Check if nfs4_getfacl binary exists
  if ::File.exist?('/usr/bin/nfs4_getfacl')
    # Get current NFS4 ACL for file/directory
    nfs4_getfacl_cmd = Mixlib::ShellOut.new("nfs4_getfacl #{file_path}")
    if nfs4_getfacl_cmd.run_command.exitstatus == 0
      # Extract NFS4 ACEs from stdout and add to current_acl array
      current_acl = nfs4_getfacl_cmd.stdout.scan(/[ADUL]:[gdfniSF]*:.*:[rwaxdDtTnNcCoy]*/)
    end
  end
end

action :create do
  # Install nfs4-acl-tools package
  package 'nfs4-acl-tools'

  # Execute nfs_setfacl command if the current NFS4 ACL is different and the test command is successful
  execute 'nfs4_setfacl' do
    command "nfs4_setfacl -s '#{acl.to_a.join(',')}' #{file_path}"
    only_if { acl != current_acl && "nfs4_setfacl --test -s '#{acl.to_a.join(',')}' #{file_path}" }
  end
end
