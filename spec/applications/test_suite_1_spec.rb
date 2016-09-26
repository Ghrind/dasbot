require 'spec_helper'

RSpec.describe 'test_suite_1' do

  let(:command) { nil }

  subject { run command }

  describe Dasbot do
    describe '.root' do
      let(:command) { 'Dasbot.root' }
      it { is_expected.to eq application_path }
    end

    describe '.environment' do
      let(:command) { 'Dasbot.environment' }
      it { is_expected.to eq 'development' }

      context 'when changing the DASBOT_ENV environment variable' do
        let(:env_vars) { %w(DASBOT_ENV=foobar) }
        it { is_expected.to eq 'foobar' }
      end
    end
  end

end
