require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'splunk class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('splunk::params') }

          it { is_expected.to contain_service('splunk') }
          it { is_expected.to contain_package('splunk').with_ensure('installed') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'splunk class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily:        'Solaris',
          operatingsystem: 'Nexenta',
          kernel:          'SunOS',
          architecture:    'sparc'
        }
      end

      it { expect { is_expected.to contain_package('splunk') }.to raise_error(Puppet::Error, %r{unsupported osfamily/arch Solaris/sparc}) }
    end
  end

  context 'included along with splunk::forwarder' do
    let(:facts) do
      {
        osfamily:        'Debian',
        operatingsystem: 'Debian',
        kernel:          'Linux',
        architecture:    'amd64'
      }
    end
    let(:pre_condition) { [ 'include splunk::forwarder' ] }

    describe 'fails by default' do
      it { is_expected.to raise_error(Puppet::Error, %r{allow_dual_install}) }
    end
  end
end
