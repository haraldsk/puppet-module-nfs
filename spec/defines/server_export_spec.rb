
require 'spec_helper'

describe 'nfs::server::export' do
  let(:title) { '/srv/test' }
  let(:params) {{
    #:server => 'nfs.int.net',
    #:share => '/srv/share'
    :clients => [
      'localhost(ro)',
      '$network}/$netmask(rw,async,all_squash,anonuid=99,anongid=99)',
      'nfsclient(ro)',
    ]
  }}
  let(:facts){{:concat_basedir => '/var/lib/puppet/concat',}}
  it do
    should contain_nfs__server__export__configure('/srv/test')
  end
end
