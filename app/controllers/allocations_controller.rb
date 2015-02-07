class AllocationsController < ApplicationController
  before_action :set_allocation, only: [:show, :update, :destroy]

  # GET /allocations
  # GET /allocations.json
  def index
    @allocations = Allocation.eager_graph(:asset_class).all

    render json: @allocations
  end

  # GET /allocations/1
  # GET /allocations/1.json
  def show
    render json: @allocation
  end

  # POST /allocations
  # POST /allocations.json
  def create
    @allocation = Allocation.new(allocation_params)

    if @allocation.save
      render json: @allocation, status: :created, location: @allocation
    else
      render json: @allocation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /allocations/1
  # PATCH/PUT /allocations/1.json
  def update
    if @allocation.update(allocation_params)
      head :no_content
    else
      render json: @allocation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /allocations/1
  # DELETE /allocations/1.json
  def destroy
    @allocation.destroy

    head :no_content
  end

  private

    def set_allocation
      @allocation = Allocation.with_pk!(params[:id])
    end

    def allocation_params
      params.require(:allocation).permit(:asset_class_id, :portfolio_id, :weight)
    end
end
