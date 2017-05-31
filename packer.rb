class Packer
  attr_reader :packs, :amount, :pack_limits, :position

  def initialize(options = {})
    if options[:packs].nil? || options[:amount].nil?
      raise ArgumentError
    end

    @packs = options[:packs]
    @amount = options[:amount]
    @pack_limits = @packs.keys.map { |p| @amount / p }
    @position = Array.new(@packs.length, 0)
  end

  def pack
    while @position != @pack_limits
      increment @position.length
      total = @position.zip(@packs.keys).map{ |x, y| x * y }.reduce(:+)

      if total == @amount
        @solution ||= @position.clone
        packages = @position.reduce(:+)
        min_packages = @solution.reduce(:+)

        if (packages < min_packages) || (packages == min_packages && cheaper?)
          @solution = @position.clone
        end
      end
    end

    @solution ||= false
  end

  def increment(n)
    return if @position == @pack_limits

    if @position[n-1] < @pack_limits[n-1]
      @position[n-1] = @position[n-1] + 1
    else
      @position[n-1] = 0
      increment(n-1)
    end
  end

  private

  def cheaper?
    current_total = @solution.zip(@packs.values).map{ |x, y| x * y }.reduce(:+)
    new_total = @position.zip(@packs.values).map{ |x, y| x * y }.reduce(:+)
    new_total < current_total
  end
end