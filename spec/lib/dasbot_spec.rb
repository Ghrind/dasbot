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
    let(:command) { 'puts Dasbot.root' }
    it { is_expected.to eq application_path }
  end

  describe '.environment' do
    let(:command) { 'puts Dasbot.environment' }
    it { is_expected.to eq 'development' }

    context 'when changing the DASBOT_ENV environment variable' do
      let(:env_vars) { %w(DASBOT_ENV=foobar) }
      it { is_expected.to eq 'foobar' }
    end
  end

  # What we are testing here is that the models and workflows are loaded in the right order and in the subdirectories.
  describe 'loading the application' do
    before do
      add_application_file 'app/models/model_1.rb', "module Foobar; end"
      add_application_file 'app/models/model_2.rb', "Foobar"
      add_application_file 'app/workflows/a/1_workflow.rb', "module Barfoo; def self.call; 'barfoo'; end; end"
      add_application_file 'app/workflows/b/2_workflow.rb', "Barfoo"
    end

    after do
      remove_application_file 'app/models/model_1.rb'
      remove_application_file 'app/models/model_2.rb'
      remove_application_file 'app/workflows/a/1_workflow.rb'
      remove_application_file 'app/workflows/b/2_workflow.rb'
    end

    let(:command) { 'puts Barfoo.call' }
    it { is_expected.to eq 'barfoo' }
  end

  describe 'loading the boot.rb file' do
    before do
      add_application_file 'config/boot.rb', "module Config; def self.call; 'config'; end; end"
    end

    let(:command) { 'puts Config.call' }
    it { is_expected.to eq 'config' }
  end

  describe '#logger' do
    let(:command) { "Dasbot.logger.info 'a logged line'; puts 'ok'" }
    context 'when there is no log folder' do
      it 'application should run properly' do
        is_expected.to eq 'ok'
      end
    end
    context 'when there is a log folder' do
      before do
        add_application_file 'log/.keep', ''
      end
      after do
        remove_application_file 'log'
      end
      it 'should log in the proper log file' do
        is_expected.to eq 'ok'
        expect(application_file_content('log/development.log')).to match /a logged line/
      end
      context 'whith a different environment' do
        let(:env_vars) { %w(DASBOT_ENV=foobar) }
        it 'should log in the proper log file' do
          is_expected.to eq 'ok'
          expect(application_file_content('log/foobar.log')).to match /a logged line/
        end
      end
    end
  end

  describe '#adapter?' do
    let(:adapter) { :foobar }
    subject { Dasbot.adapter?(adapter) }
    it { is_expected.to eq false }

    context 'when the adapter is loaded' do
      before do
        Dasbot.adapters << :foobar
      end
      it { is_expected.to eq true }
    end
  end

  describe '#adapters=' do
    subject { Dasbot.adapters }
    context 'when there is no adapters' do
      before do
        Dasbot.adapters = []
      end
      it 'should return []' do
        is_expected.to eq []
      end
    end

    context 'when adding adapters' do
      context 'when providing :adapter' do
        before { Dasbot.adapters = :adapter }
        it { is_expected.to eq [:adapter] }
      end

      context "when providing 'adapter'" do
        before { Dasbot.adapters = 'adapter' }
        it { is_expected.to eq [:adapter] }
      end

      context "when providing 'adapter_1, :adapter 2" do
        before { Dasbot.adapters = 'adapter_1', :adapter_2 }
        it { is_expected.to eq [:adapter_1, :adapter_2] }
      end

      context "when providing ['adapter_1, :adapter 2]" do
        before { Dasbot.adapters = ['adapter_1', :adapter_2] }
        it { is_expected.to eq [:adapter_1, :adapter_2] }
      end
    end
  end

  describe 'loading adapters' do
    let(:command) { 'puts GithubAdapter.name' }
    before do
      add_application_file 'config/boot.rb', 'Dasbot.adapters = :github'
    end
    after do
      remove_application_file 'config/boot.rb'
    end
    it { is_expected.to eq 'GithubAdapter' }
  end

end
