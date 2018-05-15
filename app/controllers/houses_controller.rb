class HousesController < ApplicationController
  def index
    @houses = House.page(params[:page])
  end

  def show
    @house = House.find(params[:id])
  end

  def search    
  end

  def results
    @houses = House.build_search_query(search_params).page(params[:page])
  end

  private
  def search_params
    params.require(:search).permit(:minimum_price, :maximum_price, :street, :zipcode, :number_of_rooms, :number_of_bathrooms)
  end
end
