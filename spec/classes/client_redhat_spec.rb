require 'spec_helper'
describe 'nfs::client::redhat' do

  let(:facts) { {:operatingsystem => 'redhat', :osmajor => 6 } }
  it do
    should contain_service('nfslock').with(
      'ensure' => 'running'
    )
    should contain_service('netfs').with(
      'enable' => 'true'
    )
    should contain_package('nfs-utils')
  end
  context "osmajor => 6" do
    let(:facts) { {:operatingsystem => 'redhat', :osmajor => 6 } }
    it do
      should include_class('nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end
  context "osmajor => 5" do
    let(:facts) { {:operatingsystem => 'redhat', :osmajor => 5 } }
    it do
      should include_class('nfs::client::redhat')
      should contain_package('portmap')

      should contain_service('portmap').with(
        'ensure' => 'running'
      )
    end
  end
end
