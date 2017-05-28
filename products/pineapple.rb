module Products
  class Pineapple < Product
    def self.packs
      { 2 => 9.95, 5 => 16.95, 8 => 24.95 }
    end
  end
end
