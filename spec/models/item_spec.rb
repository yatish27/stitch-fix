require 'rails_helper'

describe Item do
  describe "#clearance!" do
    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }

    before do
      item.clearance!
      item.reload
    end

    it "marks the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    context "when the clearance price is more than minimum" do
      it "sets the price_sold as 75% of the wholesale_price" do
        expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
      end
    end

    context "when the calculated clearance price is less than the set minimum" do
      let(:wholesale_price) { 5 }
      let(:item) do
        FactoryGirl.create(:item, style: FactoryGirl.create(:style,
                                                            wholesale_price: wholesale_price,
                                                            type: "Pants"))
      end

      it "sets the price_sold as the minimum price set for item's style type" do
        expect(item.price_sold).to eq(Style::MIN_CLEARANCE_PRICE["Pants"])
      end
    end
  end
end
