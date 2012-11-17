require 'spec_helper'

describe 'nfs::server' do
  let(:facts) { {:osfamily => 'debian', } }

  #it { should include_class('nfs::server::debian') }

end
