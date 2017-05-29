require 'spec_helper'
require './order'
require './products/product'
require './products/watermelon'
require './products/pineapple'

RSpec.describe Order do
  subject { Order.new(watermelons: 10, rockmelons: 10, pineapples: 10) }

  describe "#initialize" do
    it "assigns @order" do
      expect(subject).to have_attributes(order: { watermelons: 10, rockmelons: 10, pineapples: 10 })
    end

    it "outputs help text when no options given" do
      allow_any_instance_of(Order).to receive(:exit)
      expect { Order.new }.to output("Empty order, try -h for available options\n").to_stdout
    end
  end

  describe "#pack_order" do
    it "packs each product into packages" do
      allow(Products::Watermelon).to receive(:packs).and_return(
        { 5 => 12.99, 3 => 9.95 }
      )
      allow(Products::Pineapple).to receive(:packs).and_return(
        { 6 => 12.99, 3 => 9.95 }
      )
      order = Order.new(watermelons: 13, pineapples: 15)
      order.pack_order
      expect(order.packed_order).to eq({
        watermelons: { 5 => 2, 3 => 1 },
        pineapples: { 6 => 2, 3 => 1 }
      })
    end

    it "exits with an error state when there are incorrect order sizes" do
      allow(Products::Watermelon).to receive(:packs).and_return({ 5 => 12.99 })
      order = Order.new(watermelons: 11)
      allow(order).to receive(:exit)
      expect(order).to receive(:exit).with(1)
      order.pack_order
    end
  end

  describe "#pack_product" do
    before do
      allow(Products::Watermelon).to receive(:packs).and_return(
        { 3 => 9.95, 5 => 12.99 }
      )
    end

    it "divides a product amount into packs, with largest packs taking precedence" do
      order = Order.new(watermelons: 13)
      order.pack_product(:watermelons, 13)
      expect(order.packed_order).to eq({ watermelons: { 5 => 2, 3 => 1 }})
    end

    it "prints an error message when product count cannot fit package sizes" do
      order = Order.new(watermelons: 11)
      expect { order.pack_product(:watermelons, 11) }.to output("Could not pack your Watermelons. Please ensure product count fits within pack sizes. Pack sizes: 3, 5\n").to_stdout
    end
  end

  describe "#calculate_subtotals" do
    before do
      allow(Products::Watermelon).to receive(:packs).and_return(
        { 5 => 12.99, 3 => 9.95 }
      )
      allow(Products::Pineapple).to receive(:packs).and_return(
        { 6 => 10.99, 3 => 5.95 }
      )
    end

    it "calculates subtotals on all products" do
      order = Order.new(watermelons: 13, pineapples: 15)
      order.packed_order = {
        watermelons: { 5 => 2, 3 => 1 },
        pineapples:  { 6 => 2, 3 => 1 }
      }
      order.calculate_subtotals
      expect(order.subtotals).to eq({ watermelons: 35.93, pineapples: 27.93 })
    end
  end

  describe "#product_summary" do
    subject { Order.new(watermelons: 13) }

    before do
      allow(Products::Watermelon).to receive(:packs).and_return(
        { 3 => 9.95, 5 => 12.99 }
      )
      subject.packed_order = { watermelons: { 5 => 2, 3 => 1 }}
      subject.calculate_subtotals
    end

    it "displays number of products purchased" do
      expect(subject.product_summary(:watermelons)).to match(/13/)
    end

    it "displays product name" do
      expect(subject.product_summary(:watermelons)).to match(/Watermelons/)
    end

    it "displays product subtotal" do
      expect(subject.product_summary(:watermelons)).to match(/\$35.93/)
    end
  end
end
