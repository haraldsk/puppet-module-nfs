require 'spec_helper'
describe 'nfs::server::redhat' do
  let(:facts) { {:osmajor => 6 } }

    context ":nfs_v4 => true" do
      let(:params) {{ :nfs_v4 => true }}
      it do
        should contain_service('nfs').with( 'ensure' => 'running'  )
      end

    end
  end

