require 'spec_helper'
require './products/product'
require './products/watermelon'

RSpec.describe Products::Watermelon do
  describe ".packs" do
    it "returns hash of Watermelon packs" do
      expect(Products::Watermelon.packs).to eq({ 3 => 6.99, 5 => 8.99 })
    end
  end
end

