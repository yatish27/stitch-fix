require 'rails_helper'

describe ClearanceBatch do
  let!(:clearance_batch) { FactoryGirl.create(:clearance_batch) }

  describe "#clear_item!" do
    let!(:item) { FactoryGirl.create(:item) }

    it "clears the item and adds it to its list of cleared items"  do
      clearance_batch.clear_item!(item.id)

      expect(clearance_batch.items).to include(item)
    end
  end

  describe "#display_status" do
    it "returns the string version of the completion status" do
      clearance_batch.update_attribute(:complete, true)

      expect(clearance_batch.display_status).to eq("Complete")
    end
  end

end