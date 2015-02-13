class SellsController < ApplicationController
  before_action :set_sell, only: [:show, :update, :destroy]

  # GET /sells
  # GET /sells.json
  def index
    @sells = Sell.all

    render json: @sells
  end

  # GET /sells/1
  # GET /sells/1.json
  def show
    render json: @sell
  end

  # POST /sells
  # POST /sells.json
  def create
    @sell = Sell.new(sell_params)

    if @sell.save
      render json: @sell, status: :created, location: @sell
    else
      render json: @sell.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sells/1
  # PATCH/PUT /sells/1.json
  def update
    if @sell.update(sell_params)
      head :no_content
    else
      render json: @sell.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sells/1
  # DELETE /sells/1.json
  def destroy
    @sell.destroy

    head :no_content
  end

  private

    def set_sell
      @sell = Sell.with_pk!(params[:id])
    end

    def sell_params
      params.require(:sell).permit(:lot_id, :sold_at, :price, :quantity)
    end
end
