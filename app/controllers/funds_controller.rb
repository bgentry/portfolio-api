class FundsController < ApplicationController
  before_action :set_fund, only: [:show, :update, :destroy]

  # GET /funds
  # GET /funds.json
  def index
    @funds = Fund.all

    render json: @funds
  end

  # GET /funds/1
  # GET /funds/1.json
  def show
    render json: @fund
  end

  # POST /funds
  # POST /funds.json
  def create
    @fund = Fund.new(fund_params)

    if @fund.save
      render json: @fund, status: :created, location: @fund
    else
      render json: @fund.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /funds/1
  # PATCH/PUT /funds/1.json
  def update
    @fund = Fund.find(params[:id])

    if @fund.update(fund_params)
      head :no_content
    else
      render json: @fund.errors, status: :unprocessable_entity
    end
  end

  # DELETE /funds/1
  # DELETE /funds/1.json
  def destroy
    @fund.destroy

    head :no_content
  end

  private

    def set_fund
      @fund = Fund.find(params[:id])
    end

    def fund_params
      params.require(:fund).permit(:asset_class_id, :name, :symbol, :expense_ratio, :price)
    end
end
