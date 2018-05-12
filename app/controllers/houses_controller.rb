class HousesController < ApplicationController
  def index
    @houses = House.page(params[:page])
  end
end
