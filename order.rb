class Order
  attr_reader :products

  def initialize(options = {})
    validate_presence options
    @products = options
  end

  def validate_presence(options)
    if options.empty?
      puts "Empty order, try -h for available options"
      exit 1
    end
  end
end
