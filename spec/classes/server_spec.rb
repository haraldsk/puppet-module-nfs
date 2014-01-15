require 'spec_helper'

describe 'nfs::server' do
  let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
  it do
    should contain_concat__fragment('nfs_exports_header').with( 'target' => '/etc/exports' )
  end
  context "nfs_v4 => true" do
    let(:params) { {:nfs_v4 => true, } }
    it do
      should contain_concat__fragment('nfs_exports_root').with( 'target' => '/etc/exports' )
      should contain_file('/export').with( 'ensure' => 'directory' )
    end
  end

  shared_examples :debian do
    it { should contain_class('nfs::server::debian') }

    it do
      should contain_concat("/etc/exports").with({
        'require' => [
          'Package[nfs-kernel-server]',
        ],
        'notify'  => 'Service[nfs-kernel-server]',
      })
    end

    it do
      should_not contain_service("nfs-kernel-server").with({
        'subscribe' => 'Concat[/etc/exports]'
      })
    end
  end

  shared_examples :redhat do
    it { should contain_class('nfs::server::redhat') }

    it do
      should contain_concat("/etc/exports").with({
        'require' => [
          'Package[nfs-utils]',
        ],
        'notify'  => 'Service[nfs]',
      })
    end

    it do
      should_not contain_service("nfs").with({
        'subscribe' => 'Concat[/etc/exports]'
      })
    end
  end

  context "operatingsysten => ubuntu" do
    let(:facts) { {:operatingsystem => 'ubuntu', :concat_basedir => '/tmp', } }
    it_behaves_like :debian
  end
  context "operatingsysten => debian" do
    let(:facts) { {:operatingsystem => 'debian', :concat_basedir => '/tmp',} }
    it_behaves_like :debian
  end
  context "operatingsysten => scientific" do
    let(:facts) { {:operatingsystem => 'scientific', :concat_basedir => '/tmp', :osmajor => 6, } }
    it_behaves_like :redhat
  end
  context "operatingsysten => centos v6" do
    let(:facts) { {:operatingsystem => 'centos', :concat_basedir => '/tmp', :osmajor => 6, } }
    it_behaves_like :redhat
  end
  context "operatingsysten => redhat v6" do
    let(:facts) { {:operatingsystem => 'redhat', :concat_basedir => '/tmp', :osmajor => 6, } }
    it_behaves_like :redhat
  end
  context "operatingsysten => darwin" do
    let(:facts) { {:operatingsystem => 'darwin'} }
    it do
      expect {
        should contain_class('nfs::server::darwin')
      }.to raise_error(Puppet::Error, /NFS server is not supported on Darwin/)
    end
  end
end
