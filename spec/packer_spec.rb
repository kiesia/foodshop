require 'spec_helper'
require './packer'

RSpec.describe Packer do
  subject { Packer.new(packs: { 5 => 9.95, 12 => 15.95, 4 => 7.95 }, amount: 20) }

  describe "#initialize" do
    it "assigns @packs" do
      expect(subject.packs).to eq({ 5 => 9.95, 12 => 15.95, 4 => 7.95 })
    end

    it "assigns @amount" do
      expect(subject.amount).to eq 20
    end

    it "assigns @pack_limits" do
      expect(subject.pack_limits).to eq [4, 1, 5]
    end

    it "assigns @position" do
      expect(subject.position).to eq [0, 0, 0]
    end

    it "raises an error when incorrect options given" do
      expect{ Packer.new() }.to raise_error ArgumentError
    end
  end

  describe "#pack" do
    it "returns the smallest packing solution" do
      expect(subject.pack).to eq [0, 1, 2]
    end

    it "returns the cheapest solution when two solutions of equal size exist" do
      subject = Packer.new(packs: { 3 => 5.95, 5 => 9.95, 9 => 16.99 }, amount: 33)
      expect(subject.pack).to eq [2,0,3]
    end

    it "returns false when no packing solution can be found" do
      subject = Packer.new(packs: { 10 => 9.95 }, amount: 9)
      expect(subject.pack).to be false
    end
  end

  describe "#increment" do
    it "increments items in an array" do
      subject.increment subject.position.length
      expect(subject.position).to eq [0, 0, 1]
    end

    it "increments item[n-1] in array when item[n] exceeds max defined in @pack_limits" do
      6.times{ subject.increment(subject.position.length) }
      expect(subject.position).to eq [0, 1, 0]
    end

    it "does not increment past @pack_limits" do
      100.times{ subject.increment(subject.position.length) }
      expect(subject.position).to eq subject.pack_limits
    end
  end
end
