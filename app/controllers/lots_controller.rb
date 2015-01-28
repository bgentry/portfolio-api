class LotsController < ApplicationController
  before_action :set_lot, only: [:show, :update, :destroy]

  # GET /lots
  # GET /lots.json
  def index
    @lots = Lot.all

    render json: @lots
  end

  # GET /lots/1
  # GET /lots/1.json
  def show
    render json: @lot
  end

  # POST /lots
  # POST /lots.json
  def create
    @lot = Lot.new(lot_params)

    if @lot.save
      render json: @lot, status: :created, location: @lot
    else
      render json: @lot.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lots/1
  # PATCH/PUT /lots/1.json
  def update
    @lot = Lot.find(params[:id])

    if @lot.update(lot_params)
      head :no_content
    else
      render json: @lot.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lots/1
  # DELETE /lots/1.json
  def destroy
    @lot.destroy

    head :no_content
  end

  private

    def set_lot
      @lot = Lot.find(params[:id])
    end

    def lot_params
      params.require(:lot).permit(:fund_id, :portfolio_id, :acquired_at, :sold_at, :proceeds, :quantity, :share_cost)
    end
end
