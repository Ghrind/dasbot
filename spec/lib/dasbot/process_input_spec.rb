require 'spec_helper'

RSpec.describe Dasbot::ProcessInput do
  let(:input) { double(:input, adapter_name: 'my_adapter') }
  let(:adapter) { double(:adapter, processor: processor ) }
  let(:processor) { double(:processor) }

  describe '.run!' do
    subject { described_class.run! input }

    it "should delegate the processing to the adapter's processor" do
      expect(Dasbot::Adapters).to receive(:get).with('my_adapter').and_return(adapter)
      expect(processor).to receive(:run!).with(input).and_return true
      expect(subject).to eq true
    end
  end
end
