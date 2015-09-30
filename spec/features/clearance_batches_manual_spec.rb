require 'rails_helper'

describe "clear items individually for clearance_batch" do
  describe "clearance_batches add_item", type: :feature do
    before do
      visit root_path
      click_link "Add Items Manually"
    end

    context "when item valid" do
      it "adds item to the clearance_batch" do
        item = FactoryGirl.create(:item)

        fill_in('item_id', :with => item.id )
        click_button "Submit"

        expect(page).to have_content("Item Id #{item.id} was successfully added to Clearance Batch")
      end
    end

    context "when item already cleared" do
      it "does not add the item to cleaance_batch and displays error message" do
        item = FactoryGirl.create(:item, status: 'clearanced')

        fill_in('item_id', :with => item.id )
        click_button "Submit"

        expect(page).to have_content("Item id #{item.id} could not be clearanced")
      end
    end

    context "when item invalid" do
      it "does not add the item to cleaance_batch and displays error message" do
        fill_in('item_id', :with => 0 )
        click_button "Submit"

        expect(page).to have_content("Item id 0 is not valid")
      end
    end
  end

  describe "clearance_batches finish", type: :feature do
    it "completes the clearance_batch and updates the status" do
      clearance_batch =  FactoryGirl.create(:clearance_batch)
      item = FactoryGirl.create(:item)
      clearance_batch.items << item

      visit clearance_batch_path(clearance_batch)
      click_button("Finish")
      visit clearance_batches_path


      within('table.clearance_batches') do
        expect(page).to have_content("Complete")
      end
    end
  end
end
