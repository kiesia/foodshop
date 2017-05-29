require 'optparse'
require './order'
require './products/product'
require './products/rockmelon'
require './products/watermelon'
require './products/pineapple'

options = {}

OptionParser.new do |parser|
  products = %w(rockmelons watermelons pineapples)

  products.each do |product|
    parser.on("--#{product} COUNT", Integer, "Number of #{product} to purchase") do |val|
      options[product.to_sym] = val
    end
  end
end.parse!

order = Order.new options
order.process