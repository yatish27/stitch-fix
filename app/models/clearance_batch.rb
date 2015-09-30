class ClearanceBatch < ActiveRecord::Base

  has_many :items, dependent: :nullify

  scope :sorted_by_recent_status, -> { order("clearance_batches.complete ASC, clearance_batches.updated_at DESC") }

  def clear_item!(item_id)
    item = Item.find(item_id)
    item.clearance!
    self.items << item
  end

  def total_clearance_cost
    items.sum(:price_sold)
  end

  # This method should be added in the decorator class of clearance_batch
  def display_status
     complete? ? "Complete" : "Incomplete"
  end
end
