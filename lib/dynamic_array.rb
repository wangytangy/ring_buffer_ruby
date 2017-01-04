require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @store = StaticArray.new(@length)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index > @length - 1
    @store[index]
  end

  # O(1)
  def []=(index, value)
    @store[index] = value
    value
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0

    popped_val = @store[@length - 1]
    @length -= 1
    popped_val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if @length == @capacity
    @store[@length] = val
    @length += 1
    return @store
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if @length == 0
    shifted_value = @store[0]
    i = 0
    while i < @length - 1
      @store[i] = @store[i + 1]
      i += 1
    end
    @length -= 1
    shifted_value
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    @length += 1
    i = @length - 1

    while i > 0
      @store[i] = @store[i - 1]
      i -= 1
    end

    @store[0] = val
    @store
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_store = StaticArray.new(@capacity)

    i = 0
    while i < @length
      new_store[i] = @store[i]
      i += 1
    end

    @store = new_store
  end

end
