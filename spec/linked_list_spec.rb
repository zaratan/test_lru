require_relative '../lib/linked_list.rb'

describe DoubleLinkedList do
  let(:dll) { DoubleLinkedList.new }

  describe '#init' do
    it 'has an empty first' do
      expect(dll.first).to be_nil
    end

    it 'has an empty last' do
      expect(dll.last).to be_nil
    end

    it 'has a size of 0' do
      expect(dll.size).to eq(0)
    end
  end

  describe '#push' do
    context 'when the list is empty' do
      before { dll.push(:new_first) }

      it 'correctly sets first' do
        expect(dll.first.value).to eq(:new_first)
      end

      it 'correctly sets last' do
        expect(dll.last.value).to eq(:new_first)
      end

      it 'updates the size' do
        expect(dll.size).to eq(1)
      end
    end

    context 'when the list has elements' do
      before do
        dll.push(1)
        dll.push(2)
      end

      it 'correctly set the first' do
        expect(dll.first.value).to eq(2)
      end

      it 'does not change the last' do
        expect(dll.last.value).to eq(1)
      end

      it 'sets prev correctly' do
        expect(dll.last.prev.value).to eq(2)
        expect(dll.first.prev).to be_nil
      end

      it 'sets next correctly' do
        expect(dll.first.next.value).to eq(1)
        expect(dll.last.next).to be_nil
      end

      it 'updates the size' do
        expect(dll.size).to eq(2)
      end
    end
  end

  describe '#pop' do
    before do
      dll.push(1)
      dll.push(2)
      dll.push(3)
    end

    it 'returns first elem' do
      expect(dll.pop.value).to eq(3)
    end
    it 'removes first elem' do
      dll.pop

      expect(dll.first.value).to eq(2)
    end

    it 'updates prev' do
      dll.pop

      expect(dll.first.prev).to be_nil
    end

    it 'updates the size' do
      expect { dll.pop }.to change { dll.size }.from(3).to(2)
    end

    context 'with an empty list' do
      let(:empty_dll) { DoubleLinkedList.new }

      it 'left the size at 0' do
        expect { empty_dll.pop }.not_to change { empty_dll.size }.from(0)
      end

      it 'returns nil' do
        expect(empty_dll.pop).to be_nil
      end

      it 'stays a valid dll' do
        empty_dll.pop
        expect(empty_dll).to be_a(DoubleLinkedList)
      end
    end
  end

  describe '#drop_last' do
    before do
      dll.push(1)
      dll.push(2)
      dll.push(3)
    end

    it 'returns last elem' do
      expect(dll.drop_last.value).to eq(1)
    end
    it 'removes last elem' do
      dll.drop_last

      expect(dll.last.value).to eq(2)
    end

    it 'updates next' do
      dll.drop_last

      expect(dll.last.next).to be_nil
    end

    it 'updates the size' do
      expect { dll.drop_last }.to change { dll.size }.from(3).to(2)
    end

    context 'with an empty list' do
      let(:empty_dll) { DoubleLinkedList.new }

      it 'left the size at 0' do
        expect { empty_dll.drop_last }.not_to change { empty_dll.size }.from(0)
      end

      it 'returns nil' do
        expect(empty_dll.drop_last).to be_nil
      end

      it 'stays a valid dll' do
        empty_dll.drop_last
        expect(empty_dll).to be_a(DoubleLinkedList)
      end
    end
  end

  describe '#each' do
    before do
      dll.push(3)
      dll.push(2)
      dll.push(1)
    end

    describe 'with block' do
      it 'yields correctly' do
        i = 1

        dll.each do |node|
          expect(node.value).to eq(i)
          i += 1
        end
      end
    end

    describe 'without block' do
      it 'returns a working Enumerator' do
        obj = dll.each

        expect(obj).to be_a(Enumerator)
        expect(obj.next.value).to eq(1)
        expect(obj.next.value).to eq(2)
        expect(obj.next.value).to eq(3)
        expect { obj.next }.to raise_error(StopIteration)
      end
    end
  end

  describe 'behaves like an enumerable' do
    before do
      dll.push(3)
      dll.push(2)
      dll.push(1)
    end

    it 'supports #map' do
      expect(dll.map(&:value)).to eq([1, 2, 3])
    end

    it 'supports chaining' do
      expect(dll.map.with_index { |e, i| [e.value, i] }).to eq(
        [[1, 0], [2, 1], [3, 2]],
      )
    end
  end

  describe '#put_on_top' do
    context 'when the list has one element' do
      before { dll.push(1) }

      it 'works' do
        dll.put_on_top(dll.first)
        expect(dll.first.value).to eq(1)
      end
    end
    context 'when the list is filled' do
      before do
        dll.push(4)
        dll.push(3)
        dll.push(2)
        dll.push(1)
        dll.put_on_top(moving_elem)
      end

      let(:moving_elem) { dll.first.next.next }

      it 'put the elem on top of the list' do
        expect(dll.first.value).to eq(moving_elem.value)
      end

      it 'updates the next order' do
        expect(dll.first.value).to eq(3)
        expect(dll.first.next.value).to eq(1)
        expect(dll.first.next.next.value).to eq(2)
        expect(dll.first.next.next.next.value).to eq(4)
        expect(dll.first.next.next.next.next).to be_nil
        expect(dll.map(&:value)).to eq([3, 1, 2, 4])
      end

      it 'updates the previous order' do
        expect(dll.last.value).to eq(4)
        expect(dll.last.prev.value).to eq(2)
        expect(dll.last.prev.prev.value).to eq(1)
        expect(dll.last.prev.prev.prev.value).to eq(3)
        expect(dll.last.prev.prev.prev.prev).to be_nil
      end
    end
  end
end
