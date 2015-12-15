#
# Cookbook Name:: nfs4_setfacl_test
# Recipe:: default
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

# Variables
base_dir = '/mnt/nfs4_acl'
test1_dir = File.join(base_dir, 'test1')
test1_file = File.join(test1_dir, 'test1_file')
test2_dir = 'test2'
test2_mount_dir = File.join(base_dir, test2_dir)
test2_export_dir = File.join(test1_dir, test2_dir)
test3_dir = 'test3'
test3_mount_dir = File.join(base_dir, test3_dir)
test3_export_dir = File.join(test1_dir, test3_dir)

# Create directories
[test1_dir, test2_mount_dir, test3_mount_dir].each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
    not_if { ::Dir.exist?(d) }
  end
end

# Mount NFS export in test1 directory
mount test1_dir do
  device node['nfs4_acl']['nfs_export']
  fstype 'nfs4'
end

# Create test file
file test1_file do
  owner 'root'
  group 'root'
  mode '0755'
  not_if { ::File.exist?(test1_file) }
end

# Create directories under mounted test directory
[test2_export_dir, test3_export_dir].each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
    not_if { ::Dir.exist?(d) }
  end
end

# Mount test subdirectories
[test2_dir, test3_dir].each do |d|
  mount File.join(base_dir, d) do
    device File.join(node['nfs4_acl']['nfs_export'], d)
    fstype 'nfs4'
  end
end

# Set nfs4_acl on test1 file
nfs4_setfacl test1_file do
  acl [
    'A::OWNER@:rwaDxtTnNcCy',
    'D::OWNER@:o',
    'A:g:GROUP@:rxtncy',
    'D:g:GROUP@:waDTNCo',
    'A::EVERYONE@:rxtncy',
    'D::EVERYONE@:waDTNCo'
  ]
end

# Set nfs4_acl on test2 directory
nfs4_setfacl test2_mount_dir do
  acl [
    'A::OWNER@:rwaDxtTnNcCy',
    'D::OWNER@:o',
    'A:g:GROUP@:rwaDxtTnNcy',
    'D:g:GROUP@:Co',
    'A::EVERYONE@:rxtncy',
    'D::EVERYONE@:waDTNCo'
  ]
end

# Set nfs4_acl file inheritance on test3 directory
nfs4_setfacl test3_mount_dir do
  acl [
    'A::OWNER@:rwaDxtTnNcCy',
    'A:fdi:OWNER@:rwaDxtTnNcCy',
    'D::OWNER@:o',
    'A:g:GROUP@:rxtncy',
    'A:fdig:GROUP@:rwaDxtTnNcy',
    'D:g:GROUP@:waDTNCo',
    'A::EVERYONE@:rxtncy',
    'A:fdi:EVERYONE@:rwaDxtTnNcy',
    'D::EVERYONE@:waDTNCo'
  ]
end
