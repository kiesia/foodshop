require 'spec_helper'
require './order'

RSpec.describe Order do
  subject { Order.new(watermelons: 10, rockmelons: 10, pineapples: 10) }

  before do
    allow(Products::Watermelon).to receive(:packs).and_return(
      { 3 => 9.95, 5 => 12.99 }
    )
    allow(Products::Pineapple).to receive(:packs).and_return(
      { 6 => 10.99, 3 => 5.95 }
    )
  end

  describe "#initialize" do
    it "assigns @order" do
      expect(subject).to have_attributes(order: { watermelons: 10, rockmelons: 10, pineapples: 10 })
    end

    it "outputs help text when no options given" do
      allow_any_instance_of(Order).to receive(:exit)
      expect { Order.new }.to output(/Empty order, try -h for available options/).to_stdout
    end

    it "outputs error text when an 0 is given as a product count" do
      allow_any_instance_of(Order).to receive(:exit)
      expect { Order.new(watermelons: 0) }.to output(/Please enter a number greater than 0/).to_stdout
    end
  end

  describe "#pack_order" do
    let(:packer) { instance_double("Packer") }

    before do
      allow(Packer).to receive(:new).and_return(packer)
    end

    it "packs each product into packages" do
      allow(packer).to receive(:pack).and_return([1, 2])

      order = Order.new(watermelons: 13, pineapples: 15)
      order.pack_order
      expect(order.packed_order).to eq({
        watermelons: { 5 => 2, 3 => 1 },
        pineapples: { 6 => 1, 3 => 2 }
      })
    end

    it "exits with an error state when there are incorrect order sizes" do
      allow(packer).to receive(:pack).and_return(false)

      order = Order.new(watermelons: 1)
      allow(order).to receive(:exit)
      allow(order).to receive(:puts) # silence output
      expect(order).to receive(:exit).with(1)
      order.pack_order
    end
  end

  describe "#pack_product" do
    let(:packer) { instance_double("Packer") }

    before do
      allow(Packer).to receive(:new).and_return(packer)
    end

    it "divides a product amount into packs" do
      allow(packer).to receive(:pack).and_return([1, 2])

      order = Order.new(watermelons: 13)
      order.pack_product(:watermelons, 13)
      expect(order.packed_order).to eq({ watermelons: { 5 => 2, 3 => 1 }})
    end

    it "prints an error message when product count cannot fit package sizes" do
      allow(packer).to receive(:pack).and_return(false)

      order = Order.new(watermelons: 1)
      expect { order.pack_product(:watermelons, 1) }.to output(
        /Could not pack your Watermelons. Please ensure product count fits within pack sizes: 3, 5/
      ).to_stdout
    end
  end

  describe "#calculate_subtotals" do
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

  describe "#calculate_total" do
    subject { Order.new(watermelons: 13, pineapples: 24) }

    it "sums subtotals" do
      subject.subtotals = { watermelons: 20.50, pineapples: 15.50 }
      expect(subject.calculate_total).to eq 36
    end
  end

  describe "#product_summary" do
    subject { Order.new(watermelons: 13) }

    before do
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

  describe "#pack_summary" do
    subject { Order.new(watermelons: 13) }

    before do
      subject.packed_order = { watermelons: { 5 => 2, 3 => 1 }}
    end

    it "displays a summary for each pack type purchased" do
      expect(subject.pack_summary(:watermelons)).to match(
        /2 x 5 pack @ \$12.99.*1 x 3 pack @ \$9.95/m
      )
    end
  end

  describe "#create_invoice" do
    subject { Order.new(watermelons: 13, pineapples: 3) }

    before do
      subject.packed_order = {
        watermelons: { 5 => 2, 3 => 1 },
        pineapples: { 3 => 1 }
      }
    end

    it "outputs product summary" do
      expect { subject.create_invoice }.to output(/3 Pineapples \$5.95/).to_stdout
    end

    it"outputs pack summary" do
      expect { subject.create_invoice }.to output(/ - 1 x 3 pack @ \$5.95/).to_stdout
    end

    it "outputs total" do
      expect { subject.create_invoice }.to output(/TOTAL: \$41.88/).to_stdout
    end

    it "outputs summaries for all products" do
      expect { subject.create_invoice }.to output(/Watermelons.*Pineapples/m).to_stdout
    end
  end
end
