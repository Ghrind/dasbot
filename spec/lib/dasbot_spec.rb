require 'spec_helper'

require 'fileutils'

RSpec.describe Dasbot, type: :application do

  let(:command) { nil }

  before(:all) do
    setup_application!
  end

  after(:all) do
    teardown_application!
  end

  subject { run command }

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
