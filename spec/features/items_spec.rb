require "rails_helper"

describe "items index" do
  context "without filter selected" do
    let!(:item) {FactoryGirl.create(:item)}

    it "displays the list of all items" do
      visit items_path

      expect(page).to have_content("Items")

      within('table.items tbody') do
        expect(page).to have_content("Item Id #{item.id}")
        expect(page).to have_content("sellable")
        expect(page).to have_xpath(".//tr", :count => 1)
      end
    end
  end

  context "with status filter selected" do
    let!(:item_1) {FactoryGirl.create(:item)}
    let!(:item_2) {FactoryGirl.create(:item, status: "clearanced")}

    it "displays the list of items filtered by selected status" do
      visit items_path
      select('Clearanced', :from => 'status')
      click_button('Filter')

      within('table.items tbody') do
        expect(page).to have_content("Item Id #{item_2.id}")
        expect(page).to have_content("clearanced")
        expect(page).to have_xpath(".//tr", :count => 1)
      end
    end
  end
end
