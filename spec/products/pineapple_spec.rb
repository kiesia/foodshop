require 'spec_helper'
require './products/product'
require './products/pineapple'

RSpec.describe Products::Pineapple do
  describe ".packs" do
    it "returns hash of Pineapple packs" do
      expect(Products::Pineapple.packs).to eq({ 2 => 9.95, 5 => 16.95, 8 => 24.95 })
    end
  end
end

