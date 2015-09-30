class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  STATUES = ['sellable', 'not sellable', 'sold', 'clearanced']

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }


  def self.validate_clearance_eligibility(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      return "Item id #{potential_item_id} is not valid"
    end
    if Item.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be found"
    end
    if Item.sellable.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be clearanced"
    end

    return nil
  end

  def clearance!
    update_attributes!(status: 'clearanced', 
                       price_sold: clearance_selling_price)
  end


  private

  def clearance_selling_price
    [Style::MIN_CLEARANCE_PRICE[style.type], style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE].max
  end

end
