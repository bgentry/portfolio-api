class AssetClassesController < ApplicationController
  before_action :set_asset_class, only: [:show, :update, :destroy]

  # GET /asset_classes
  # GET /asset_classes.json
  def index
    @asset_classes = AssetClass.all

    render json: @asset_classes
  end

  # GET /asset_classes/1
  # GET /asset_classes/1.json
  def show
    render json: @asset_class
  end

  # POST /asset_classes
  # POST /asset_classes.json
  def create
    @asset_class = AssetClass.new(asset_class_params)

    if @asset_class.save
      render json: @asset_class, status: :created, location: @asset_class
    else
      render json: @asset_class.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /asset_classes/1
  # PATCH/PUT /asset_classes/1.json
  def update
    @asset_class = AssetClass.find(params[:id])

    if @asset_class.update(asset_class_params)
      head :no_content
    else
      render json: @asset_class.errors, status: :unprocessable_entity
    end
  end

  # DELETE /asset_classes/1
  # DELETE /asset_classes/1.json
  def destroy
    @asset_class.destroy

    head :no_content
  end

  private

    def set_asset_class
      @asset_class = AssetClass.find(params[:id])
    end

    def asset_class_params
      params.require(:asset_class).permit(:name)
    end
end
