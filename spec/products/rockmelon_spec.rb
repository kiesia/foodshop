require 'spec_helper'
require './products/product'
require './products/rockmelon'

RSpec.describe Products::Rockmelon do
  describe ".packs" do
    it "returns hash of Rockmelon packs" do
      expect(Products::Rockmelon.packs).to eq({ 3 => 5.95, 5 => 9.95, 9 => 16.99 })
    end
  end
end

