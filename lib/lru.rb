# frozen_string_literal: true

require_relative './linked_list.rb'

class LRU
  Elem = Struct.new(:key, :value)

  def initialize(max_size = 10)
    @max_size = max_size
    @queue = DoubleLinkedList.new
    @hash = {}
  end

  def get(key)
    node = @hash[key]
    @queue.put_on_top(node) if node
    node&.value&.value
  end

  def set(key, new_value)
    node = @hash[key]
    if node
      node.value.value = new_value
      @queue.put_on_top(node)
    else
      if @queue.size == @max_size
        rm_elem = @queue.drop_last
        @hash.delete(rm_elem.value.key)
      end
      @queue.push(Elem.new(key, new_value))
      @hash[key] = @queue.first
    end
  end
end
