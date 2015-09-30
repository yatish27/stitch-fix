class ClearanceBatchesController < ApplicationController
  before_action :check_clearance_batch_status, only: [:add_item]

  def index
    @clearance_batches  = ClearanceBatch.sorted_by_recent_status.all
    @items_count = Item.where(clearance_batch_id: @clearance_batches.map(&:id)).group(:clearance_batch_id).count
  end

  def create
    @clearance_batch = ClearanceBatch.create!
    redirect_to clearance_batch_path(@clearance_batch)
  end

  def show
    @clearance_batch = ClearanceBatch.includes(:items).find(params[:id])
  end

  def update
    if clearance_batch.update_attributes(clearance_batch_params)
      flash[:notice] = 'Clearance Batch is complete'
    else
      flash[:alert] = "Clearance Batch #{params[:id]} was not able to complete"
    end

    redirect_to clearance_batch_path(@clearance_batch)
  end

  def add_item
    clearance_error = Item.validate_clearance_eligibility(Integer(params[:item_id]))
    if clearance_error
      flash[:alert] = clearance_error
    else
      clearance_batch.clear_item!(params[:item_id])
      flash[:notice] = "Item Id #{params[:item_id]} was successfully added to Clearance Batch #{params[:id]}"
    end

    redirect_to clearance_batch_path(clearance_batch)
  end

  def create_by_file
    clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []

    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end

    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end

    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end

  private

  def clearance_batch_params
    params.require(:clearance_batch).permit(:complete)
  end

  def clearance_batch
    @clearance_batch ||= ClearanceBatch.find(params[:id])
  end

  def check_clearance_batch_status
    if clearance_batch.complete?
      flash[:alert] = "The Clearance Batch #{clearance_batch.id} is complete. No changes to items are allowed"
      redirect_to clearance_batch_path(clearance_batch)
    end
  end
end
