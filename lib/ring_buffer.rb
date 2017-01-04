require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @store = StaticArray.new(@length)
    @capacity = 8
    @start_idx = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index > @length - 1
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    @store[(@start_idx + index) % @capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    popped_val = self[@length - 1]
    @length -= 1
    popped_val
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    self[@length] = val
    @length += 1
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length == 0
    val = self[0]
    self[0] = nil
    @length -= 1
    @start_idx = (@start_idx + 1) % @capacity
    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity
    @start_idx = (@start_idx - 1) % @capacity
    @length += 1
    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    new_capacity = @capacity * 2
    new_store = StaticArray.new(@capacity)

    i = 0
    while i < @length
      new_store[i] = self[i]
      i += 1
    end
    @capacity = new_capacity
    @store = new_store
    @start_idx = 0
  end

end
