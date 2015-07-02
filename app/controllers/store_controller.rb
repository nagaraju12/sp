class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)
  end

   def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id )
  end
  end		
