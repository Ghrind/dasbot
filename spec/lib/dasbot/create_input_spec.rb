require 'spec_helper'

RSpec.describe Dasbot::CreateInput do
  let(:adapter) { double(:adapter, adapter_name: 'my_adapter', accepted_headers: ['MY_HEADER']) }
  let(:request) { double(:request, env: { 'FORBIDDEN_HEADER' => 'XXX', 'MY_HEADER' => 'my_value' }, body: double(:body, read: 'body_content', rewind: nil)) }
  let(:params ) { double(:params, to_hash: { a: 1 }) }

  let(:input) { double(:input) }

  describe 'run!' do
    subject { described_class.run!(adapter, request, params) }

    it 'should create a new input with the right attributes' do
      expect(Dasbot::Input).to receive(:create).with(anything).and_return(input)
      is_expected.to eq input
    end

    it 'should be in pending state' do
      expect(Dasbot::Input).to receive(:create).with(hash_including(state: 'pending'))
      subject
    end

    it 'should have the request body content' do
      expect(Dasbot::Input).to receive(:create).with(hash_including(body: 'body_content'))
      subject
    end

    it 'should have the adapter name' do
      expect(Dasbot::Input).to receive(:create).with(hash_including(adapter_name: 'my_adapter'))
      subject
    end

    it 'should have the params has a hash' do
      expect(Dasbot::Input).to receive(:create).with(hash_including(params: { a: 1 }))
      subject
    end

    it 'should have the filters whitelisted by the adapter' do
      expected_headers = { 'MY_HEADER' => 'my_value' }
      expect(Dasbot::Input).to receive(:create).with(hash_including(headers: expected_headers))
      subject
    end
  end
end
