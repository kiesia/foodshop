require 'spec_helper'
require './order'

RSpec.describe Order do
  subject { Order.new }

  describe "#initialize" do
    subject { Order.new({ watermelons: 10, rockmelons: 10, pineapples: 10 }) }

    it "assigns products" do
      expect(subject).to have_attributes(products: { watermelons: 10, rockmelons: 10, pineapples: 10 })
    end

    it "outputs help text when no options given" do
      allow_any_instance_of(Order).to receive(:exit)
      expect { Order.new }.to output("Empty order, try -h for available options\n").to_stdout
    end
  end
end
