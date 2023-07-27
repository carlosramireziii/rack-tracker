RSpec.describe Rack::Tracker::Heap do
  def env
    { foo: 'bar' }
  end

  it 'will be placed in the head' do
    expect(described_class.position).to eq(:head)
    expect(described_class.new(env).position).to eq(:head)
  end

  describe 'with user_id tracking' do
    subject { described_class.new(env, { user_id: user_id }).render }

    let(:user_id) { '123' }

    it 'will include identify call with user_id value' do
      expect(subject).to match(%r{heap.identify\("123"\);})
    end

    context 'when user_id value is a proc' do
      let(:user_id) { proc { '123' } }

      it 'will include identify call with the user_id called value' do
        expect(subject).to match(%r{heap.identify\("123"\);})
      end
    end

    context 'when user_id value is blank' do
      let(:user_id) { '' }

      it 'will not include identify call' do
        expect(subject).not_to match(%r{heap.identify})
      end
    end
  end
end
