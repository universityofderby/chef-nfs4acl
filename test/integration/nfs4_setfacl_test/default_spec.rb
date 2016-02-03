test1_acl = [
  'A::OWNER@:rwaDxtTnNcCy',
  'D::OWNER@:o',
  'A:g:GROUP@:rxtncy',
  'D:g:GROUP@:waDTNCo',
  'A::EVERYONE@:rxtncy',
  'D::EVERYONE@:waDTNCo'
]

test2_acl = [
  'A::OWNER@:rwaDxtTnNcCy',
  'D::OWNER@:o',
  'A:g:GROUP@:rwaDxtTnNcy',
  'D:g:GROUP@:Co',
  'A::EVERYONE@:rxtncy',
  'D::EVERYONE@:waDTNCo'
].join('\n')

test3_acl = [
  'A::OWNER@:rwaDxtTnNcCy',
  'A:fdi:OWNER@:rwaDxtTnNcCy',
  'D::OWNER@:o',
  'A:g:GROUP@:rxtncy',
  'A:fdig:GROUP@:rwaDxtTnNcy',
  'D:g:GROUP@:waDTNCo',
  'A::EVERYONE@:rxtncy',
  'A:fdi:EVERYONE@:rwaDxtTnNcy',
  'D::EVERYONE@:waDTNCo'
].join('\n')

test4_acl = [
  'A:fdi:OWNER@:rwaDxtTnNcCy',
  'A:fdig:GROUP@:rwaDxtTnNcy',
  'A:fdi:EVERYONE@:rxtncy'
]

describe package('nfs4-acl-tools') do
  it { should be_installed }
end

describe command('nfs4_getfacl /mnt/nfs4_acl/test1/test1_file') do
  its(:stdout) { should match(/#{test1_acl}/) }
end

describe command('nfs4_getfacl /mnt/nfs4_acl/test2') do
  its(:stdout) { should match(/#{test2_acl}/) }
end

describe command('nfs4_getfacl /mnt/nfs4_acl/test3') do
  its(:stdout) { should match(/#{test3_acl}/) }
end

describe command('nfs4_getfacl /mnt/nfs4_acl/test4') do
  test4_acl.each do |a|
    its(:stdout) { should match(/#{a}/) }
  end
end

describe file('/mnt/nfs4_acl/test4/test4_file') do
  it { should be_mode 0775 }
end
