require 'spec_helper'

RSpec.describe Dasbot::Model do

  after do
    described_class.truncate!
  end

  describe '.create' do
    let(:attributes) { { foo: 'bar' } }

    subject { described_class.create attributes }

    it 'should create a new record' do
      expect(subject.class).to eq described_class
    end

    it 'should assign an incremental id' do
      expect(subject.id).to eq 1
    end

    it 'should have the given attributes' do
      expect(subject.foo).to eq 'bar'
    end
  end

  describe '.set' do
    let(:record) { described_class.create(foo: 'bar') }
    let(:attributes) { { bar: 'foo' } }
    subject { described_class.set(record.id, attributes) }

    it 'should replace the record with given id' do
      subject
      expect(described_class.records.length).to eq 1
      expect(described_class.records.first.to_h).to eq attributes.merge(id: record.id)
    end
  end
end
