require 'spec_helper'

describe 'swap' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { File.expand_path(File.join(__dir__, '../fixtures/hiera.yaml')) }

      it { is_expected.to compile.with_all_deps }

      context 'with default values from Hiera' do
        it { is_expected.to contain_exec('create_swap_file').with_command('dd if=/dev/zero of=/swapfile bs=1M count=2048') }
        it { is_expected.to contain_mount('/swapfile') }
      end
    end
  end
end
