class ItemsController < ApplicationController
  before_action :clearance_batches

  def index
    @items = Item.all
    @items = @items.where(status: params[:status]) if params[:status].present?
    @items = @items.where(clearance_batch_id: params[:clearance_batch_id]) if params[:clearance_batch_id].present?
    @items = @items.page(params[:page])
  end

  private

  def clearance_batches
    @clearance_batch_ids ||= ClearanceBatch.pluck(:id)
  end
end