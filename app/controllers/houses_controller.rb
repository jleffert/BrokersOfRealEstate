class HousesController < ApplicationController
  def index
    @houses = House.page(params[:page])
  end

  def show
    @house = House.find(params[:id])
  end
end
