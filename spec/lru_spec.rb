# frozen_string_literal: true
require_relative '../lib/lru'

describe LRU do
  let(:lru) { LRU.new(5) }
  context 'when the lru is empty' do
    it 'returns nothing' do
      expect(lru.get('key')).to be_nil
    end

    it 'can set an elem' do
      lru.set('key', :val)
      expect(lru.get('key')).to eq(:val)
    end
  end

  context 'reading reset lru' do
    before do
      lru.set('a', 5)
      lru.set('b', 4)
      lru.set('c', 3)
      lru.set('d', 2)
      lru.set('e', 1)
    end

    it 'reset the order for the newly read elem' do
      expect { lru.get('c') }.to change {
        lru.instance_variable_get(:@queue).map(&:value).map(&:value)
      }.from([1, 2, 3, 4, 5]).to([3, 1, 2, 4, 5])
    end
  end

  context 'when the max_size is reach' do
    before do
      lru.set('a', 5)
      lru.set('b', 4)
      lru.set('c', 3)
      lru.set('d', 2)
      lru.set('e', 1)
    end

    context 'when adding a new element' do
      it 'drops last' do
        lru.set('f', 6)

        expect(lru.get('a')).to be_nil
      end

      it 'adds the new element on top' do
        lru.set('f', 6)

        expect(
          lru.instance_variable_get(:@queue).map(&:value).map(&:value),
        ).to eq([6, 1, 2, 3, 4])
      end
    end

    context 'when changing a value' do
      it 'does not drop last' do
        lru.set('c', 0)

        expect(lru.get('a')).not_to be_nil
        expect(lru.get('c')).to eq(0)
      end

      it 'moves the last setted to top' do
        lru.set('c', 0)

        expect(
          lru.instance_variable_get(:@queue).map(&:value).map(&:value),
        ).to eq([0, 1, 2, 4, 5])
      end
    end
  end
end
