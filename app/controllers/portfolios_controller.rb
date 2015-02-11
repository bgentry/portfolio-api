class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :update, :destroy]

  # GET /portfolios
  # GET /portfolios.json
  def index
    @portfolios = Portfolio.eager_graph(:lots).eager_graph(allocations: {:asset_class => :funds}).all

    render json: @portfolios
  end

  # GET /portfolios/1
  # GET /portfolios/1.json
  def show
    render json: @portfolio
  end

  # POST /portfolios
  # POST /portfolios.json
  def create
    @portfolio = Portfolio.new(portfolio_params)

    if @portfolio.save
      render json: @portfolio, status: :created, location: @portfolio
    else
      render json: @portfolio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /portfolios/1
  # PATCH/PUT /portfolios/1.json
  def update
    port_params = portfolio_params
    allocation_ids = Set.new()
    if port_params[:allocations_attributes].present?
      port_params[:allocations_attributes].each do |allocation|
        allocation_ids << allocation[:id].to_i
        # delete any allocations with weight of 0
        if allocation[:weight] == BigDecimal.new("0.0")
          allocation[:_delete] = true
        end
      end
      @portfolio.allocations.each do |allocation|
        # If an allocation isn't in allocations_attributes, add it there and mark
        # it for deletion.
        unless allocation_ids.include?(allocation.id)
          port_params[:allocations_attributes] << {id: allocation.id, _delete: true}
        end
      end
    end
    if @portfolio.update(port_params)
      head :no_content
    else
      render json: @portfolio.errors, status: :unprocessable_entity
    end
  end

  # DELETE /portfolios/1
  # DELETE /portfolios/1.json
  def destroy
    @portfolio.destroy

    head :no_content
  end

  private

    def set_portfolio
      @portfolio = Portfolio.with_pk!(params[:id])
    end

    def portfolio_params
      # Rails expects allocation data as allocations_attributes, but Ember wants
      # to stick with the serialized format for creation.
      port_params = params.require(:portfolio).permit(:name, :taxable, {
        allocations: [:id, :weight, :asset_class_id],
      })
      port_params["allocations_attributes"] = port_params.delete("allocations")
      port_params
    end
end
