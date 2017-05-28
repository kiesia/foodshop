module Products
  class Rockmelon < Product
    def self.packs
      { 3 => 5.95, 5 => 9.95, 9 => 16.99 }
    end
  end
end
