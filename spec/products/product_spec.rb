require 'spec_helper'
require './products/product'

RSpec.describe Products::Product do
  describe ".packs" do
    it "raises a NotImplementedError" do
      expect { Products::Product.packs }.to raise_error NotImplementedError
    end
  end
end
