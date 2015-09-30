require "rails_helper"

describe "add new monthly clearance_batch"  do
  describe "clearance_batches index", type: :feature do
    describe "see previous clearance batches" do
      let!(:clearance_batch_1) { FactoryGirl.create(:clearance_batch, complete: true) }
      let!(:clearance_batch_2) { FactoryGirl.create(:clearance_batch, complete: true) }

      it "displays a list of all past clearance batches" do
        visit clearance_batches_path
        expect(page).to have_content("Stitch Fix Clearance Tool")
        expect(page).to have_content("Clearance Batches")
        within('table.clearance_batches') do
          expect(page).to have_content("Clearance Batch #{clearance_batch_1.id}")
          expect(page).to have_content("Clearance Batch #{clearance_batch_2.id}")
        end
      end
    end

    describe "add a new clearance batch" do
      context "with total success" do
        it "allows a user to upload a new clearance batch successfully" do
          items = 5.times.map{ FactoryGirl.create(:item) }
          file_name = generate_csv_file(items)

          visit new_clearance_batch_path
          attach_file("Select batch file", file_name)
          click_button "upload batch file"
          new_batch = ClearanceBatch.first

          expect(page).to have_content("#{items.count} items clearanced in batch #{new_batch.id}")
          expect(page).not_to have_content("item ids raised errors and were not clearanced")
          within('table.clearance_batches') do
            expect(page).to have_content(/Clearance Batch \d+/)
          end
        end
      end

      context "with partial success" do
        it "allows a user to upload a new clearance batch partially successfully, and report on errors" do
          valid_items   = 3.times.map{ FactoryGirl.create(:item) }
          invalid_items = [[987654], ['no thanks']]
          file_name     = generate_csv_file(valid_items + invalid_items)

          visit new_clearance_batch_path
          attach_file("Select batch file", file_name)
          click_button "upload batch file"
          new_batch = ClearanceBatch.first

          expect(page).to have_content("#{valid_items.count} items clearanced in batch #{new_batch.id}")
          expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
          within('table.clearance_batches') do
            expect(page).to have_content(/Clearance Batch \d+/)
          end
        end
      end

      context "with total failure" do
        it "allows a user to upload a new clearance batch that totally fails to be clearanced" do
          invalid_items = [[987654], ['no thanks']]
          file_name     = generate_csv_file(invalid_items)

          visit new_clearance_batch_path
          attach_file("Select batch file", file_name)
          click_button "upload batch file"

          expect(page).not_to have_content("items clearanced in batch")
          expect(page).to have_content("No new clearance batch was added")
          expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
        end
      end
    end
  end
end
