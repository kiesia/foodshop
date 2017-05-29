require 'spec_helper'
require './order'
require './products/product'
require './products/watermelon'

RSpec.describe Order do
  subject { Order.new(watermelons: 10, rockmelons: 10, pineapples: 10) }

  describe "#initialize" do
    it "assigns products" do
      expect(subject).to have_attributes(order: { watermelons: 10, rockmelons: 10, pineapples: 10 })
    end

    it "outputs help text when no options given" do
      allow_any_instance_of(Order).to receive(:exit)
      expect { Order.new }.to output("Empty order, try -h for available options\n").to_stdout
    end
  end

  describe "#pack_order" do
    it "packs each product into packages"

    it "prints an error message when products cannot fit to package sizes" do
      allow(Products::Watermelon).to receive(:packs).and_return({ 5 => 12.99 })
      order = Order.new(watermelons: 11)
      allow(order).to receive(:exit)
      expect { order.pack_products }.to output("Could not pack your Watermelons. Please ensure product count fits within pack sizes. Pack sizes: 5\n").to_stdout
    end
  end
end
