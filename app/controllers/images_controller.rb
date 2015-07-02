class ImagesController < ApplicationController
	
	def new 
		@image =Image.new
	end

	def index
		@images =Image.all
	end

	def create
		@image = Image.new(new_params)
		@image.save
		redirect_to images_path
	end

def show
	@image =Image.find(params[:id])
end

def edit
	@image =Image.find(params[:id])
end

def update
@image=Image.find(params[:id])
if @image.update_attributes(image_params)
redirect_to image_path(@image)
else
render"exit"
end
end

def destroy
	@image =Image.find(params[:id])
	if @image.destroy
redirect_to images_path
end
end

	private
	def new_params
		params.require(:image).permit!
	end
end
