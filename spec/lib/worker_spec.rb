require 'spec_helper'

RSpec.describe Dasbot::Worker do
  describe '#perform_once' do
    let(:worker) { Dasbot::Worker.new }
    subject { worker.perform_once }
    let(:input) { double(:input) }

    context 'when there is no input' do
      it 'should not fail' do
        expect(subject).to eq false
      end
    end

    context 'when there is a pending input' do
      before do
        expect(Dasbot::Input).to receive(:first_pending).and_return(input)
      end
      it 'should process the first pending input' do
        expect(Dasbot::ProcessInput).to receive(:run!).with(input)
        expect(subject).to eq true
      end

      context 'when processing fails' do
        it 'should handle the error gracefully' do
          expect(Dasbot::ProcessInput).to receive(:run!).with(input).and_raise(RuntimeError)
          expect(Dasbot::HandleInputProcessError).to receive(:run!).with(input, RuntimeError)
          subject
        end
      end
    end

  end
end
