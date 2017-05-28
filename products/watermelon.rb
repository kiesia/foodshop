module Products
  class Watermelon < Product
    def self.packs
      { 3 => 6.99, 5 => 8.99 }
    end
  end
end
