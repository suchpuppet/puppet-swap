# frozen_string_literal: true

require 'spec_helper'

describe 'swap::fstab' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { File.expand_path(File.join(__dir__, '../fixtures/hiera.yaml')) }

      it { is_expected.to compile.with_all_deps }

      context 'with default values from Hiera' do
        it { is_expected.to contain_class('swap::fstab') }
        it { is_expected.to contain_file_line('ensure_swap_in_fstab').with_line('/swapfile none swap sw 0 0') }
      end
    end
  end
end
