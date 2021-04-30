class DoubleLinkedList
  include Enumerable

  class Node
    def initialize(value, next_val = nil, previous_val = nil)
      @value = value
      @next_val = next_val
      @previous_val = previous_val
    end

    attr_reader :value

    def next
      @next_val
    end

    def prev
      @previous_val
    end

    def set_prev(new_prev)
      @previous_val = new_prev
    end

    def set_next(new_next)
      @next_val = new_next
    end
  end

  def initialize
    @head = nil
    @last = nil
    @size = 0
  end

  attr_reader :size

  def each(&block)
    if block_given?
      current = @head
      while current
        yield(current)
        current = current.next
      end
    else
      Enumerator.new do |y|
        @current = @head
        loop do
          raise StopIteration unless @current
          y << @current
          @current = @current.next
        end
      end
    end
  end

  def first
    @head
  end

  def last
    @last
  end

  def drop_last
    last = @last
    @last = @last&.prev
    @last&.set_next(nil)
    @size = [0, @size - 1].max
    return last
  end

  def push(val)
    new_head = Node.new(val, @head)
    @head&.set_prev(new_head)
    @head = new_head
    @size += 1
    @last = @head unless @last
  end

  def pop
    head = @head
    @head = @head&.next
    @last = nil unless @head
    @head&.set_prev(nil)
    @size = [0, @size - 1].max
    return head
  end

  def put_on_top(node)
    node.next&.set_prev(node.prev)
    node.prev&.set_next(node.next)
    @head&.set_prev(node)
    node.set_next(@head)
    node.set_prev(nil)
    @head = node
  end
end
