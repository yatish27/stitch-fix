class Style < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  # The type field stored in the database should be the slug name and then there should be Hash which will
  # map the slug name to displayname. For now we are using the name stored in the database as key.
  # Currently, using the sample names used in the seed.rb.
  Style::MIN_CLEARANCE_PRICE = Hash.new(BigDecimal.new('2'))

  Style::MIN_CLEARANCE_PRICE["Pants"] = BigDecimal.new('5')
  Style::MIN_CLEARANCE_PRICE["Dress"] = BigDecimal.new('5')

  has_many :items
end
