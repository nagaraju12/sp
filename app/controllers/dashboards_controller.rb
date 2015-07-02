class DashboardsController < ApplicationController
	def index
		@products= Product.all	
	end	
end
