require 'spec_helper'

RSpec.describe Dasbot::Adapters, type: :application do
  before(:all) do
    setup_application!
  end

  after(:all) do
    teardown_application!
  end

  subject { run command }

  let(:command) { nil }

  describe '#get' do
    let(:command) { 'puts Dasbot::Adapters.get(:github).name' }

    before do
      add_application_file 'config/boot.rb', 'Dasbot.adapters = :github'
    end

    after do
      remove_application_file 'config/boot.rb'
    end

    it { is_expected.to eq 'GithubAdapter' }
  end

end
