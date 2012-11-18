
require 'spec_helper'

describe 'nfs::server::export' do
  let(:title) { '/srv/test' }
  # let(:facts) { { :operatingsystem => 'ubuntu' } }
  #let(:params) {{ :server => 'nfs.int.net', :share => '/srv/share' } }
  it do
    should contain_nfs__server__export__configure('/srv/test')
  end
end
