class Order
  attr_reader :order, :packed_order

  def initialize(options = {})
    validate_options options
    @order = options
    @packed_order = {}
  end

  def pack_products
    @order.each do |line_item|
      product, remainder = line_item
      packs = get_product(product).packs

      packs.keys.sort.reverse.each do |pack_size|
        pack_count, remainder = remainder.divmod(pack_size)
      end

      incorrect_order_size(product) if remainder > 0
    end
  end

  private

  # convert plural :products key into a classname
  # e.g. :watermelons >> Product::Watermelon
  def get_product(product)
    Products.const_get(product[0...-1].capitalize)
  end

  def validate_options(options)
    if options.empty?
      puts "Empty order, try -h for available options"
      exit 1
    end
  end

  def incorrect_order_size(product)
    output = []
    output << "Could not pack your #{product.to_s.capitalize}."
    output << "Please ensure product count fits within pack sizes."
    output << "Pack sizes: #{get_product(product).packs.keys.join(", ")}"
    puts output.join(" ")
  end
end
